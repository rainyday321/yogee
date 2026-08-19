import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';

/// Runs [action] behind a full-screen loading overlay, then removes it.
///
/// Used by the sign-in buttons. Google sign-in is several seconds of account
/// picker, token exchange and user-document write, and the 23px spinner built
/// into the button is too small to read as "the app is working".
///
/// Implemented as an OverlayEntry rather than a dialog route on purpose. A
/// dialog sits on the Navigator stack, so popping it after the caller has
/// already navigated would pop the *new* page instead. An overlay entry is not
/// a route, so removing it can never take the wrong thing with it.
///
/// Removal is in a `finally`. This codebase already has spinners that never
/// resolve, and a blocking one that leaked would make the app look frozen.
Future<T> withLoadingOverlay<T>(
  BuildContext context,
  Future<T> Function() action, {
  String? message,
}) async {
  final overlay = Overlay.maybeOf(context);
  if (overlay == null) {
    // No Overlay in this tree. Still run the action -- a missing spinner is
    // better than a failed sign-in.
    return action();
  }

  final entry = OverlayEntry(
    builder: (_) => _LoadingScrim(message: message),
  );
  overlay.insert(entry);
  try {
    return await action();
  } finally {
    if (entry.mounted) {
      entry.remove();
    }
  }
}

class _LoadingScrim extends StatelessWidget {
  const _LoadingScrim({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    // Material: an overlay entry has no Material ancestor of its own, and Text
    // without one renders with the debug yellow underline.
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // ModalBarrier rather than a coloured Container: it swallows taps, so
          // the buttons underneath cannot be pressed a second time mid-sign-in.
          const ModalBarrier(
            dismissible: false,
            color: Color(0xCC000000),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 44.0,
                  height: 44.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 18.0),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
