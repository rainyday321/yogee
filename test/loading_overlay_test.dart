// Guards against infinite loading on the sign-in buttons.
//
// Removing the scrim in a `finally` only helps if the future completes. Two
// real paths do not: Firestore's set() resolves only on server ack, so an
// offline device leaves it pending forever (backend.dart:680, awaited by
// _signInOrCreateAccount), and google_sign_in can orphan its pending result if
// Android destroys the activity while the picker is showing.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yogee/custom_code/loading_overlay.dart';

/// Pumps a host with an Overlay and hands back a context inside it.
Future<BuildContext> _host(WidgetTester tester) async {
  late BuildContext ctx;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox.expand();
          },
        ),
      ),
    ),
  );
  return ctx;
}

void main() {
  testWidgets('scrim is removed once the action completes', (tester) async {
    final ctx = await _host(tester);
    final completer = Completer<String>();

    final future = withLoadingOverlay(ctx, () => completer.future,
        message: 'Signing you in…');
    await tester.pump();
    expect(find.text('Signing you in…'), findsOneWidget);

    completer.complete('ok');
    await tester.pumpAndSettle();

    expect(find.text('Signing you in…'), findsNothing);
    expect(await future, 'ok');
  });

  testWidgets('scrim is removed when the action throws', (tester) async {
    final ctx = await _host(tester);
    final completer = Completer<String>();

    final future = withLoadingOverlay(ctx, () => completer.future,
        message: 'Signing you in…');
    await tester.pump();
    expect(find.text('Signing you in…'), findsOneWidget);

    completer.completeError(StateError('boom'));
    await expectLater(future, throwsStateError);
    await tester.pumpAndSettle();

    expect(find.text('Signing you in…'), findsNothing);
  });

  testWidgets('scrim comes down even if the action NEVER completes',
      (tester) async {
    final ctx = await _host(tester);
    // Never completed on purpose: this is the offline-Firestore-write case.
    final never = Completer<String>();

    withLoadingOverlay(
      ctx,
      () => never.future,
      message: 'Signing you in…',
      safetyTimeout: const Duration(seconds: 2),
    );
    await tester.pump();
    expect(find.text('Signing you in…'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Signing you in…'), findsOneWidget,
        reason: 'must not disappear before the timeout');

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Signing you in…'), findsNothing,
        reason: 'infinite loading: scrim outlived its safety timeout');

    // Leave the pending future resolved so the test does not leak a timer.
    never.complete('late');
  });

  testWidgets('a completed action cancels the safety timer', (tester) async {
    final ctx = await _host(tester);

    await withLoadingOverlay(
      ctx,
      () async => 'fast',
      message: 'Signing you in…',
      safetyTimeout: const Duration(seconds: 2),
    );
    await tester.pumpAndSettle();

    expect(find.text('Signing you in…'), findsNothing);
    // If the Timer were still live, the test framework would fail here with a
    // pending-timer error.
  });
}
