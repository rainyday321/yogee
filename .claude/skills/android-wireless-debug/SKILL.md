---
name: android-wireless-debug
description: Connect an Android phone to this machine over wireless debugging (pair, connect, install an APK, read logs) and diagnose why a phone is not showing up in `adb devices`. Use when asked to install a build on a physical device, pair a phone, run logcat, or when `adb devices` is empty.
---

# Android wireless debugging (Honor X6a / MagicOS notes)

`adb` is **not on PATH** on this machine. Always use the full path:

```
C:\Users\normalUser\AppData\Local\Android\Sdk\platform-tools\adb.exe
```

Verified working device: `WDY-LX2` (HONOR X6a), typically `192.168.1.181`.
Phone and PC must be on the same Wi-Fi network.

---

## 1. Pair (first time only, per machine)

On the phone: **Developer options → Wireless debugging → on → Pair device with pairing code.**
Keep that dialog **open** — the port and code change every time it opens and are single-use.

```powershell
$adb = "C:\Users\normalUser\AppData\Local\Android\Sdk\platform-tools\adb.exe"
& $adb pair 192.168.1.181:<PAIR_PORT> <6_DIGIT_CODE>
```

### The pairing error that is not an error

```
error: protocol fault (couldn't read status message): No error
```

**This message is unreliable — pairing frequently succeeds anyway.** It appeared on
every attempt in practice while the pairing had in fact gone through.

Do **not** keep re-pairing on seeing it. Go straight to the connect step. Only
treat pairing as genuinely failed if the connect step also fails.

## 2. Find the connect port

The **connect port is different from the pairing port.** Read it off the main
Wireless debugging screen, or discover both without touching the phone:

```powershell
& $adb mdns services
```

```
adb-XXXX  _adb-tls-pairing._tcp   192.168.1.181:42585   <- pairing (single use)
adb-XXXX  _adb-tls-connect._tcp   192.168.1.181:36381   <- connect (use this)
```

## 3. Connect

```powershell
& $adb connect 192.168.1.181:36381
& $adb devices -l
```

Expect: `192.168.1.181:36381  device product:WDY-LX2 model:WDY_LX2`.

The connect port **changes when wireless debugging is toggled off/on or the phone
reboots**. Re-run `adb mdns services` to find the new one; re-pairing is not needed.

## 4. Install

```powershell
$d = "192.168.1.181:36381"
& $adb -s $d install -r "C:\Users\normalUser\yogee\build\app\outputs\flutter-apk\app-release.apk"
```

### `INSTALL_FAILED_UPDATE_INCOMPATIBLE`

```
Existing package com.mycompany.yoogeeapp signatures do not match newer version
```

The installed app was signed with a different key. Android will not update across a
signature change, and this **cannot be forced** — `-r` does not help, and
`uninstall -k` leaves the old signature registered so the reinstall fails the same way.

The only path is a full uninstall, which **permanently deletes on-device app data**:
the signed-in session, `shared_preferences` (everything `FFAppState` persists), the
`sqflite` database, and caches. Firestore data is server-side and unaffected.

**Confirm with the user before doing this.**

```powershell
& $adb -s $d uninstall com.mycompany.yoogeeapp
& $adb -s $d install "<apk path>"
```

Since the release build now uses the upload keystore (see `yogee-build-run`), this
should be a one-time break. Future releases update in place.

## 5. Launch and watch logs

```powershell
& $adb -s $d shell monkey -p com.mycompany.yoogeeapp -c android.intent.category.LAUNCHER 1

& $adb -s $d logcat -c                                   # clear buffer first
& $adb -s $d logcat -v time flutter:V AndroidRuntime:E System.err:W GoogleSignIn:V *:S
```

Run logcat in the background and read the output file, rather than blocking.

---

## Diagnosing "phone not in `adb devices`"

Work out **which half is broken** before giving advice — Windows-visible and
adb-visible are independent.

```powershell
# Does Windows see the phone at all?
Get-PnpDevice -PresentOnly | Where-Object { $_.FriendlyName -match 'Android|ADB|Honor|Huawei' } |
  Select-Object Status,Class,FriendlyName
```

| What you see | Meaning |
|---|---|
| `WPD  HONOR X6a` only | Cable + MTP fine, **USB debugging NOT active**. MTP working proves nothing about debugging. |
| An `ADB Interface` entry too | Debugging is active; the problem is adb-side — restart the server. |
| Nothing | Cable is charge-only, or the phone is not connected. |

Restart the adb server (it caches a stale device list and will not pick up a phone
plugged in after it started):

```powershell
& $adb kill-server; Start-Sleep 2; & $adb start-server; Start-Sleep 3; & $adb devices -l
```

Check for a competing adb server — a second `adb.exe` from another SDK owning port
5037 causes protocol faults:

```powershell
Get-Process adb | Select-Object Id,Path
Get-NetTCPConnection -LocalPort 5037 | Select-Object State,OwningProcess -Unique
```

### Honor / MagicOS specifics

These cost the most time and are easy to miss:

- The **master toggle** at the top of Developer options must be on. The 7 taps on
  Build number enable developer *mode*; every sub-toggle stays inert until the
  master switch is on.
- **Install via USB** is a separate toggle from USB debugging. `adb install` fails
  without it, it needs a signed-in Honor ID plus network, and it **switches itself
  back off** after a reboot or a period of inactivity.
- **Select USB configuration** (in Developer options) must be MTP. It is independent
  of the file-transfer mode chosen from the notification shade.
- The **"Allow USB debugging?"** RSA prompt only appears while the screen is
  unlocked. Tick "Always allow from this computer".
- A live debugging session shows a persistent **"USB debugging connected"**
  notification. No notification means no debugging, whatever the toggle looks like.

**When USB resists, go wireless.** It bypasses the ADB-interface registration,
cable quality, and the Install-via-USB requirement in one step. That is what
finally worked here.
