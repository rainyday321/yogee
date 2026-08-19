---
name: yogee-build-run
description: Run or build the Yogee Flutter app against the right Firebase backend — debug, dev cloud, local emulator, or production release — plus release signing, APK verification, and the environment requirements. Use when asked to run the app, build an APK, switch Firebase projects, start the emulators, or check which backend a build points at.
---

# Yogee — run and build

## Environment (the build fails without these)

| Requirement | Why |
|---|---|
| **Flutter 3.41.7** (Dart 3.11.5) | Its `flutter_localizations` pins `intl` to exactly **0.20.2**, which is what `pubspec.yaml` requires. Newer Flutter needs `intl ^0.20.3` and `flutter pub get` fails with "version solving failed". |
| **JDK 21** | Gradle 8.12 supports ≤23; Android Studio's bundled JBR 25 fails with `Error resolving plugin [dev.flutter.flutter-plugin-loader] > 25.0.2`. Located here at `C:\Program Files\Microsoft\jdk-21.0.12.8-hotspot`. |

`pubspec.yaml` pins **exact** versions with no carets. Never hand-pick a version when
adding a package — add it, let pub resolve, then check `flutter pub deps` for movement
on `intl` before committing.

---

## Which backend am I hitting?

**On Android the platform files decide, not the dart-defines.**

| Project | Reached by | Safety |
|---|---|---|
| `yoogeeapp` | **release** builds — `android/app/google-services.json` | **PRODUCTION. Live user data.** Rules are `allow read/write: if true`, and `allow delete: if false` on nearly everything, so anything written is permanent. |
| `yogee-e62e2` | **debug** builds — `android/app/src/debug/google-services.json` | Dev project, safe to write to |
| `demo-yoogee` | `--dart-define=USE_FIREBASE_EMULATOR=true` | Local emulator, wiped on restart |

> ⚠️ **Currently broken: `android/app/src/debug/google-services.json` is MISSING.**
> It is untracked and not in `.gitignore`, so git never had a copy. Without it,
> **debug builds fall through to `android/app/google-services.json` and hit
> PRODUCTION.** There is presently no build configuration that avoids live data on
> Android. Restore it from the `yogee-e62e2` console before relying on debug being safe.

`USE_DEV_FIREBASE` and the `FirebaseOptions` in `lib/backend/firebase/firebase_config.dart`
only affect **web**. On Android the Gradle plugin bakes in whichever
`google-services.json` matches the build type (`firebase_config.dart:42-45`).

### Verify rather than assume

```powershell
# Which project does an APK actually point at?
$apk = "build\app\outputs\flutter-apk\app-release.apk"
foreach ($p in "yoogeeapp","yogee-e62e2","demo-yoogee") {
  "$p : " + (Select-String -Path $apk -Pattern $p -AllMatches -Encoding Byte -ErrorAction SilentlyContinue).Count
}
```

---

## Run

```bash
flutter pub get
flutter run                      # debug -- see the warning above
flutter analyze
flutter test
flutter test test/auth_error_message_test.dart
```

### Against the dev cloud project (web only)

```bash
flutter run -d chrome --dart-define=USE_DEV_FIREBASE=true
```

Real Firebase, so Google sign-in works — the emulator cannot do Google sign-in,
because `google_sign_in` talks to Play Services and needs a real OAuth client.

### Against the local emulator

```bash
firebase/emulators.cmd                       # auth, firestore, storage under JDK 21
cd firebase/functions && npm run seed        # seed the emulator
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Seeded login: `demo@yogee.test` / `password123`.

- Emulator host defaults to **`192.168.1.219`** (this machine's LAN IP,
  `firebase_config.dart:31`). It is DHCP-assigned and changes after a router reboot —
  override with `--dart-define=FIREBASE_EMULATOR_HOST=<ip>`.
- Phone and PC on the same Wi-Fi; emulators bound to `0.0.0.0` (already set in
  `firebase/firebase.json`); host firewall must allow inbound **8080, 9099, 9199**.
- Flaky Wi-Fi? Use `127.0.0.1` plus `adb reverse tcp:8080 tcp:8080` (and 9099, 9199).
  Inside an Android AVD the host alias is `10.0.2.2`.
- `seed.mjs` refuses to run unless `FIRESTORE_EMULATOR_HOST` is loopback with
  something listening. **Do not weaken that guard** — without it a stopped emulator
  makes the Admin SDK silently fall through to real Firebase.

---

## Release build

```bash
flutter build apk --release      # ~2-3 min; output 92 MB
flutter build appbundle --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

**This targets PRODUCTION (`yoogeeapp`).** Signing in on a release build creates real
user documents that no client can delete.

### Signing

`android/app/build.gradle` uses `signingConfigs.release` when `android/key.properties`
exists, and falls back to the debug key when it does not — so a fresh clone still
builds, but produces a **different signature and therefore a different SHA-1**, which
decides whether Google sign-in works.

| | |
|---|---|
| Keystore | `android/app/upload-keystore.jks` (gitignored via `*.jks`) |
| Config | `android/key.properties` (gitignored) |
| Alias | `upload` |
| SHA-1 | `20:9E:B5:E5:84:58:6E:8D:58:5F:5B:D9:91:BC:35:B2:01:14:22:DF` |

Both files exist **only on this machine** and are unrecoverable if lost — losing them
means no further updates to anything published under that key. `storeFile` must be an
**absolute path**: `file()` in the app module resolves relative to `android/app`, so a
repo-relative value silently misresolves.

That SHA-1 is registered on `yoogeeapp`. Google sign-in fails with `ApiException: 10`
(DEVELOPER_ERROR) on any build whose signing key is not registered on the project it
points at.

### Check an APK's signature

```powershell
$bt = Get-ChildItem "$env:LOCALAPPDATA\Android\Sdk\build-tools" -Directory |
      Sort-Object Name -Descending | Select-Object -First 1
& (Join-Path $bt.FullName "apksigner.bat") verify --print-certs "build\app\outputs\flutter-apk\app-release.apk"
```

`CN=Yogee` = correctly signed. `CN=Android Debug` = the fallback fired, meaning
`key.properties` was missing.

### Get a keystore's SHA-1 (to register in Firebase)

```powershell
& "C:\Program Files\Microsoft\jdk-21.0.12.8-hotspot\bin\keytool.exe" `
  -list -v -keystore "android\app\upload-keystore.jks" -alias upload
```

Register it at Firebase Console → project → Project settings → Your apps →
`com.mycompany.yoogeeapp` → **Add fingerprint**, then re-download
`google-services.json`.

**Always verify the downloaded file actually contains the fingerprint** — the console
gives no confirmation, and a SHA-**256** produces no change to this file at all, since
only SHA-1 generates the `oauth_client` entries:

```powershell
py -c "import json,io; d=json.load(io.open(r'<path>',encoding='utf-8')); print([o.get('android_info',{}).get('certificate_hash') for c in d['client'] for o in c.get('oauth_client',[])])"
```

---

## Cloud Functions

```bash
cd firebase/functions
npm install
npm run lint            # ESLint, zero warnings allowed
npm run compile
```

> ⚠️ `npm run serve`, `npm run logs` and `npm run shell` all pass **`-P yoogeeapp`**,
> which is **production**. `npm run serve` starts a functions emulator whose admin SDK
> talks to production Firestore, because no local Firestore runs beside it. Retarget
> them at `yogee-e62e2` before doing function work.

There is also no `functions` entry in `firebase.json`'s emulator block, so Firestore
triggers cannot fire locally until one is added.

---

## Install to a phone

See the **`android-wireless-debug`** skill.
