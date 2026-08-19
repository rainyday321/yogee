import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import '../auth_manager.dart';
import '../base_auth_user_provider.dart';
import '../../flutter_flow/flutter_flow_util.dart';

import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stream_transform/stream_transform.dart';
import 'anonymous_auth.dart';
import 'apple_auth.dart';
import 'email_auth.dart';
import 'firebase_user_provider.dart';
import 'google_auth.dart';
import 'jwt_token_auth.dart';
import 'github_auth.dart';

export '../base_auth_user_provider.dart';

class FirebasePhoneAuthManager extends ChangeNotifier {
  bool? _triggerOnCodeSent;
  FirebaseAuthException? phoneAuthError;
  // Set when using phone verification (after phone number is provided).
  String? phoneAuthVerificationCode;
  // Set when using phone sign in in web mode (ignored otherwise).
  ConfirmationResult? webPhoneAuthConfirmationResult;
  // Used for handling verification codes for phone sign in.
  void Function(BuildContext)? _onCodeSent;

  bool get triggerOnCodeSent => _triggerOnCodeSent ?? false;
  set triggerOnCodeSent(bool val) => _triggerOnCodeSent = val;

  void Function(BuildContext) get onCodeSent =>
      _onCodeSent == null ? (_) {} : _onCodeSent!;
  set onCodeSent(void Function(BuildContext) func) => _onCodeSent = func;

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}

class FirebaseAuthManager extends AuthManager
    with
        EmailSignInManager,
        GoogleSignInManager,
        AppleSignInManager,
        AnonymousSignInManager,
        JwtSignInManager,
        GithubSignInManager,
        PhoneSignInManager {
  // Set when using phone verification (after phone number is provided).
  String? _phoneAuthVerificationCode;
  // Set when using phone sign in in web mode (ignored otherwise).
  ConfirmationResult? _webPhoneAuthConfirmationResult;
  FirebasePhoneAuthManager phoneAuthManager = FirebasePhoneAuthManager();

  @override
  Future signOut() {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future deleteUser(BuildContext context) async {
    try {
      if (!loggedIn) {
        print('Error: delete user attempted with no logged in user!');
        return;
      }
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Too long since most recent sign in. Sign in again before deleting your account.')),
        );
      }
    }
  }

  @override
  Future updateEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        print('Error: update email attempted with no logged in user!');
        return;
      }
      await currentUser?.updateEmail(email);
      await updateUserDocument(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Too long since most recent sign in. Sign in again before updating your email.')),
        );
      }
    }
  }

  @override
  Future updatePassword({
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        print('Error: update password attempted with no logged in user!');
        return;
      }
      await currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authErrorMessage(e) ?? '')),
        );
      }
    }
  }

  @override
  Future resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authErrorMessage(e) ?? '')),
      );
      return null;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password reset email sent')),
    );
  }

  @override
  Future<BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _signInOrCreateAccount(
        context,
        () => emailSignInFunc(email, password),
        'EMAIL',
      );

  @override
  Future<BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _signInOrCreateAccount(
        context,
        () => emailCreateAccountFunc(email, password),
        'EMAIL',
      );

  @override
  Future<BaseAuthUser?> signInAnonymously(
    BuildContext context,
  ) =>
      _signInOrCreateAccount(context, anonymousSignInFunc, 'ANONYMOUS');

  @override
  Future<BaseAuthUser?> signInWithApple(BuildContext context) =>
      _signInOrCreateAccount(context, appleSignIn, 'APPLE');

  @override
  Future<BaseAuthUser?> signInWithGoogle(BuildContext context) =>
      _signInOrCreateAccount(context, googleSignInFunc, 'GOOGLE');

  @override
  Future<BaseAuthUser?> signInWithGithub(BuildContext context) =>
      _signInOrCreateAccount(context, githubSignInFunc, 'GITHUB');

  @override
  Future<BaseAuthUser?> signInWithJwtToken(
    BuildContext context,
    String jwtToken,
  ) =>
      _signInOrCreateAccount(context, () => jwtTokenSignIn(jwtToken), 'JWT');

  void handlePhoneAuthStateChanges(BuildContext context) {
    phoneAuthManager.addListener(() {
      if (!context.mounted) {
        return;
      }

      if (phoneAuthManager.triggerOnCodeSent) {
        phoneAuthManager.onCodeSent(context);
        phoneAuthManager
            .update(() => phoneAuthManager.triggerOnCodeSent = false);
      } else if (phoneAuthManager.phoneAuthError != null) {
        final e = phoneAuthManager.phoneAuthError!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(authErrorMessage(e) ?? ''),
        ));
        phoneAuthManager.update(() => phoneAuthManager.phoneAuthError = null);
      }
    });
  }

  @override
  Future beginPhoneAuth({
    required BuildContext context,
    required String phoneNumber,
    required void Function(BuildContext) onCodeSent,
  }) async {
    phoneAuthManager.update(() => phoneAuthManager.onCodeSent = onCodeSent);
    if (kIsWeb) {
      phoneAuthManager.webPhoneAuthConfirmationResult =
          await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
      phoneAuthManager.update(() => phoneAuthManager.triggerOnCodeSent = true);
      return;
    }
    final completer = Completer<bool>();
    // If you'd like auto-verification, without the user having to enter the SMS
    // code manually. Follow these instructions:
    // * For Android: https://firebase.google.com/docs/auth/android/phone-auth?authuser=0#enable-app-verification (SafetyNet set up)
    // * For iOS: https://firebase.google.com/docs/auth/ios/phone-auth?authuser=0#start-receiving-silent-notifications
    // * Finally modify verificationCompleted below as instructed.
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout:
          Duration(seconds: 0), // Skips Android's default auto-verification
      verificationCompleted: (phoneAuthCredential) async {
        await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
        phoneAuthManager.update(() {
          phoneAuthManager.triggerOnCodeSent = false;
          phoneAuthManager.phoneAuthError = null;
        });
        // If you've implemented auto-verification, navigate to home page or
        // onboarding page here manually. Uncomment the lines below and replace
        // DestinationPage() with the desired widget.
        // await Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => DestinationPage()),
        // );
      },
      verificationFailed: (e) {
        phoneAuthManager.update(() {
          phoneAuthManager.triggerOnCodeSent = false;
          phoneAuthManager.phoneAuthError = e;
        });
        completer.complete(false);
      },
      codeSent: (verificationId, _) {
        phoneAuthManager.update(() {
          phoneAuthManager.phoneAuthVerificationCode = verificationId;
          phoneAuthManager.triggerOnCodeSent = true;
          phoneAuthManager.phoneAuthError = null;
        });
        completer.complete(true);
      },
      codeAutoRetrievalTimeout: (_) {},
    );

    return completer.future;
  }

  @override
  Future verifySmsCode({
    required BuildContext context,
    required String smsCode,
  }) {
    if (kIsWeb) {
      return _signInOrCreateAccount(
        context,
        () => phoneAuthManager.webPhoneAuthConfirmationResult!.confirm(smsCode),
        'PHONE',
      );
    } else {
      final authCredential = PhoneAuthProvider.credential(
        verificationId: phoneAuthManager.phoneAuthVerificationCode!,
        smsCode: smsCode,
      );
      return _signInOrCreateAccount(
        context,
        () => FirebaseAuth.instance.signInWithCredential(authCredential),
        'PHONE',
      );
    }
  }

  /// Tries to sign in or create an account using Firebase Auth.
  /// Returns the User object if sign in was successful.
  Future<BaseAuthUser?> _signInOrCreateAccount(
    BuildContext context,
    Future<UserCredential?> Function() signInFunc,
    String authProvider,
  ) async {
    try {
      final userCredential = await signInFunc();
      if (userCredential?.user != null) {
        await maybeCreateUser(userCredential!.user!);
      }
      if (userCredential == null) {
        // The user backed out (e.g. dismissed the Google account picker). Not
        // an error, but no auth event is coming either.
        _abandonAuthEvent();
        return null;
      }
      return YogeeFirebaseUser.fromUserCredential(userCredential);
    } catch (e, stackTrace) {
      // Deliberately catches everything, not just FirebaseAuthException. Google
      // sign-in reports Play Services failures as PlatformException, so a
      // narrower catch let them escape as unhandled async errors: no snackbar,
      // no crash, nothing on screen. That was the "tap the button and nothing
      // happens" bug.
      _abandonAuthEvent();

      if (e is! FirebaseAuthException && e is! PlatformException) {
        // Not an auth failure at all, so it is a bug rather than something the
        // user did. Record it -- an exception that reaches nobody is exactly
        // what made this class of failure invisible.
        debugPrint('Unexpected $authProvider sign-in error: $e');
        if (!kIsWeb) {
          FirebaseCrashlytics.instance
              .recordError(e, stackTrace, reason: '$authProvider sign-in');
        }
      }

      final errorMsg = authErrorMessage(e);
      if (errorMsg != null && context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
      return null;
    }
  }

  /// Every sign-in call site calls `prepareAuthEvent()` first, which sets
  /// `notifyOnAuthChange = false` so the router does not refresh mid-sign-in.
  /// Only `AppStateNotifier.update()` restores it, and that runs only when an
  /// auth change actually arrives. When an attempt ends without one -- failure
  /// or cancellation -- the flag would stay false, and the next unexpected
  /// sign-out would not refresh the router. So restore it here.
  void _abandonAuthEvent() =>
      AppStateNotifier.instance.updateNotifyOnAuthChange(true);

  /// Copy for a failed sign-in, or null when the user simply backed out and
  /// there is nothing worth telling them.
  @visibleForTesting
  static String? authErrorMessage(Object error) {
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'popup-closed-by-user' || 'cancelled-popup-request' => null,
        'email-already-in-use' =>
          'That email is already in use by a different account.',
        'INVALID_LOGIN_CREDENTIALS' ||
        'invalid-credential' ||
        'wrong-password' ||
        'user-not-found' =>
          'That email and password do not match an account.',
        'invalid-email' => 'That email address is not valid.',
        'user-disabled' => 'This account has been disabled.',
        'weak-password' => 'Please choose a longer, less common password.',
        'network-request-failed' =>
          'No connection. Check your network and try again.',
        'too-many-requests' =>
          'Too many attempts. Wait a moment and try again.',
        'account-exists-with-different-credential' =>
          'You already have an account with this email. Sign in the way you did the first time.',
        'popup-blocked' =>
          'Your browser blocked the sign-in popup. Allow popups and try again.',
        'operation-not-allowed' =>
          'That sign-in method is not enabled for this app.',
        'requires-recent-login' =>
          'Please sign in again before making this change.',
        // Never force-unwrap `message`. It is nullable, and unwrapping it threw
        // a second exception from inside this handler, which destroyed the
        // original error and left the user staring at an unchanged screen.
        _ => error.message ?? 'Something went wrong. Please try again.',
      };
    }
    if (error is PlatformException) {
      // google_sign_in surfaces Play Services failures here.
      if (error.code == 'sign_in_canceled') {
        return null;
      }
      if (error.code == 'network_error') {
        return 'No connection. Check your network and try again.';
      }
      final details = error.message ?? '';
      if (details.contains('12501')) {
        return null; // account picker dismissed
      }
      if (details.contains('ApiException: 10')) {
        // DEVELOPER_ERROR: this build's signing SHA-1 is not registered on the
        // Firebase project it points at. See docs/auth-signin-plan.md.
        return 'Google sign-in is not set up for this build of the app.';
      }
      if (details.contains('12500')) {
        return 'Google sign-in could not complete. Please try again.';
      }
      return error.message ?? 'Something went wrong. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}
