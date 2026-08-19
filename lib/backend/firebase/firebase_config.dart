import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Opt-in local emulator mode. Off unless you pass
/// `--dart-define=USE_FIREBASE_EMULATOR=true`, so a normal `flutter run`
/// still talks to production exactly as before.
const bool kUseFirebaseEmulator =
    bool.fromEnvironment('USE_FIREBASE_EMULATOR', defaultValue: false);

/// Host the emulators are reachable on, overridable with
/// `--dart-define=FIREBASE_EMULATOR_HOST=<ip>`.
///
/// Defaults to this machine's LAN address. The phone and the PC must be on the
/// same Wi-Fi network, the emulators must be bound to 0.0.0.0 (see
/// firebase/firebase.json), and the host firewall must allow inbound 8080,
/// 9099, and 9199.
///
/// This address is handed out by DHCP, so it can change after a router reboot.
/// When it does, either update this default or pass the define:
///   flutter run --dart-define=USE_FIREBASE_EMULATOR=true \
///               --dart-define=FIREBASE_EMULATOR_HOST=192.168.1.x
///
/// Alternatives if Wi-Fi proves flaky: `127.0.0.1` combined with
/// `adb reverse tcp:8080 tcp:8080` (and 9099, 9199) tunnels over USB instead,
/// and `10.0.2.2` is the host alias from inside an Android AVD.
const String _emulatorHost = String.fromEnvironment(
  'FIREBASE_EMULATOR_HOST',
  defaultValue: '192.168.1.219',
);

/// Opt-in "my own cloud project" mode:
///   --dart-define=USE_DEV_FIREBASE=true
///
/// Points at yogee-e62e2 instead of the shared production project yoogeeapp.
/// Unlike the emulator this is real Firebase, so Google Sign-In works - the
/// emulator cannot do it, because the native google_sign_in plugin talks to
/// Play Services and needs a real OAuth client.
///
/// Android does NOT read the values below; it reads
/// android/app/src/debug/google-services.json, which is scoped to debug builds
/// so release builds keep pointing at yoogeeapp. Web and the defines here have
/// to be kept in sync with that file by hand.
///
/// Takes precedence over USE_FIREBASE_EMULATOR if both are passed.
const bool kUseDevFirebase =
    bool.fromEnvironment('USE_DEV_FIREBASE', defaultValue: false);

const FirebaseOptions _devFirebaseOptions = FirebaseOptions(
  apiKey: 'AIzaSyBw0GbUE7bFx6AO4qPh2Q8GcrMI6kSZ9_o',
  authDomain: 'yogee-e62e2.firebaseapp.com',
  projectId: 'yogee-e62e2',
  storageBucket: 'yogee-e62e2.firebasestorage.app',
  messagingSenderId: '991611069164',
  appId: '1:991611069164:web:85c4d98ecd8fb0419efbc9',
);

Future initFirebase() async {
  if (kUseDevFirebase) {
    // On Android, google-services.json in src/debug wins, so passing options
    // here would conflict - let the platform files drive it there.
    if (kIsWeb) {
      await Firebase.initializeApp(options: _devFirebaseOptions);
    } else {
      await Firebase.initializeApp();
    }
    debugPrint('Firebase: DEV CLOUD project yogee-e62e2');
    return;
  }

  if (kUseFirebaseEmulator) {
    // Project id must match the one the emulator was seeded under
    // (`firebase emulators:start --project demo-yoogee`), otherwise Firestore
    // serves a different, empty namespace. The api key is unused by the
    // emulators but must be non-empty.
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'demo-key',
        appId: '1:453398507872:web:843ff4d8173a691c962e05',
        messagingSenderId: '453398507872',
        projectId: 'demo-yoogee',
        storageBucket: 'demo-yoogee.appspot.com',
      ),
    );
    FirebaseFirestore.instance.useFirestoreEmulator(_emulatorHost, 8080);
    await FirebaseAuth.instance.useAuthEmulator(_emulatorHost, 9099);
    await FirebaseStorage.instance.useStorageEmulator(_emulatorHost, 9199);

    // The Android Auth SDK fetches a reCAPTCHA config from Google's production
    // servers before signInWithPassword, even when pointed at the emulator.
    // "demo-yoogee" does not exist upstream, so that call fails and surfaces as
    // "A network error (such as timeout, interrupted connection or unreachable
    // host) has occurred" on the login screen. Disabling app verification skips
    // the reCAPTCHA/Play Integrity path entirely. Emulator-only.
    await FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: true,
      forceRecaptchaFlow: false,
    );
    debugPrint('Firebase: EMULATOR mode on $_emulatorHost (project demo-yoogee)');
    return;
  }

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBGLpIBh4jP3fVzkONlOxDpBdSXsXojeyM",
            authDomain: "yoogeeapp.firebaseapp.com",
            projectId: "yoogeeapp",
            storageBucket: "yoogeeapp.firebasestorage.app",
            messagingSenderId: "453398507872",
            appId: "1:453398507872:web:843ff4d8173a691c962e05",
            measurementId: "G-E8TVQT0SML"));
  } else {
    await Firebase.initializeApp();
  }
}
