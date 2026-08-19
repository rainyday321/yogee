// Covers the sign-in error mapping. The bug this guards against: a null
// `message` used to be force-unwrapped, which threw a second exception from
// inside the catch block and left the user with no feedback at all.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yogee/auth/firebase_auth/firebase_auth_manager.dart';

void main() {
  const cancelled = null;

  test('a null message never throws and never leaks empty copy', () {
    final msg = FirebaseAuthManager.authErrorMessage(
      FirebaseAuthException(code: 'something-new', message: null),
    );
    expect(msg, isNotNull);
    expect(msg, isNotEmpty);
  });

  test('user backing out is silent, not an error', () {
    expect(
      FirebaseAuthManager.authErrorMessage(
        FirebaseAuthException(code: 'popup-closed-by-user'),
      ),
      cancelled,
    );
    expect(
      FirebaseAuthManager.authErrorMessage(
        PlatformException(code: 'sign_in_canceled'),
      ),
      cancelled,
    );
    // Android reports a dismissed account picker as ApiException 12501.
    expect(
      FirebaseAuthManager.authErrorMessage(
        PlatformException(
          code: 'sign_in_failed',
          message: 'com.google.android.gms.common.api.ApiException: 12501: ',
        ),
      ),
      cancelled,
    );
  });

  test('PlatformException is mapped at all (it used to escape uncaught)', () {
    final msg = FirebaseAuthManager.authErrorMessage(
      PlatformException(
        code: 'sign_in_failed',
        message: 'com.google.android.gms.common.api.ApiException: 10: ',
      ),
    );
    expect(msg, isNotNull);
    // ApiException 10 is DEVELOPER_ERROR: the signing SHA-1 is not registered.
    // The user must not be shown the raw Play Services string.
    expect(msg, isNot(contains('ApiException')));
  });

  test('common credential failures get copy, not raw Firebase text', () {
    for (final code in [
      'wrong-password',
      'user-not-found',
      'invalid-credential',
      'network-request-failed',
      'too-many-requests',
    ]) {
      final msg = FirebaseAuthManager.authErrorMessage(
        FirebaseAuthException(code: code, message: 'RAW_FIREBASE_TEXT'),
      );
      expect(msg, isNotNull, reason: '$code produced no message');
      expect(msg, isNot(contains('RAW_FIREBASE_TEXT')),
          reason: '$code fell through to the raw Firebase message');
    }
  });

  test('an unknown non-auth error still produces something to show', () {
    final msg = FirebaseAuthManager.authErrorMessage(StateError('boom'));
    expect(msg, isNotNull);
    expect(msg, isNotEmpty);
  });
}
