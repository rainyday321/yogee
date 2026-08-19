# Sign-in: silent failures, no loading state, raw errors

Status: **not started.** Plan for `todo-fix.txt` item 4.

Scope is wider than Google. **All six providers** — Email, Google, Apple,
GitHub, JWT, Anonymous — funnel through one method, so all six share the same
defects. Fixing them at that chokepoint fixes every entry point at once.

```
signInWithEmail      ┐
createAccountWithEmail│
signInWithGoogle     ├──> _signInOrCreateAccount()   firebase_auth_manager.dart:303
signInWithApple      │       one try / one catch
signInWithGithub     │
signInWithJwtToken   │
signInAnonymously    ┘
```

---

## Symptoms

| # | Symptom | Applies to |
|---|---|---|
| a | Tap the button, nothing happens, no error | Google (mostly), any provider via [Cause 2](#cause-2--emessage-force-unwrap-throws-inside-the-catch-block) |
| b | Screen looks frozen while working, no spinner | **Google only** — see [Cause 3](#cause-3--loading-indicator-is-off-by-default-on-the-google-buttons-only) |
| c | Raw Firebase text when an error does surface | all providers |

---

## Cause 1 — the wrong exception type is caught

`lib/auth/firebase_auth/firebase_auth_manager.dart:315`. This is the **only**
catch in `_signInOrCreateAccount`:

```dart
} on FirebaseAuthException catch (e) {
```

Google's failures do not come from Firebase. They come from the native Play
Services plugin as **`PlatformException`**:

| ApiException | Meaning |
|---|---|
| **10** | `DEVELOPER_ERROR` — SHA-1 not registered for this package + project. **The likely one.** See [Cause 5](#cause-5--the-actual-production-bug--sha-1-not-registered). |
| 7 | `NETWORK_ERROR` |
| 12501 | user cancelled the account picker |
| 12500 | generic sign-in failure |

None is a `FirebaseAuthException`, so none is caught. They propagate out of the
button's `onPressed` as an unhandled async error: no snackbar, no crash dialog,
nothing. Exactly the reported symptom.

**Fix:** add `on PlatformException catch (e)` and map the codes to plain
language. Treat 12501 as a silent no-op — cancelling is a normal user action,
not an error.

## Cause 2 — `e.message!` force unwrap throws inside the catch block

`firebase_auth_manager.dart:321`, the fallback arm of the message switch:

```dart
_ => 'Error: ${e.message!}',
```

`FirebaseAuthException.message` is **nullable**. When it is null, this throws a
second exception *inside the error handler*, which nothing catches. The original
error is lost and the user sees nothing at all.

**This is why email/password sign-in also fails silently.** Email errors are
`FirebaseAuthException`, so Cause 1 does not apply to them — they reach the
catch fine. But any exception carrying a null `message` turns the handler itself
into a silent crash. Same defect, different route in.

Same force unwrap also at `:125` (`updatePassword`) and `:141` (`resetPassword`).

**Fix:** `e.message ?? 'Something went wrong. Please try again.'` at all three.

## Cause 3 — loading indicator is off by default on the Google buttons only

The previous notes said both call sites lack a loading state and proposed a
shared wrapper in `lib/custom_code/`. **That is wrong, and the wrapper is not
needed.** The widgets already implement loading; they just default differently:

| Widget | `showLoadingIndicator` default | Used by |
|---|---|---|
| `FFButtonWidget` (`flutter_flow_widgets.dart:60`) | **`true`** | email login `login_widget.dart:526`, signup `signup_widget.dart:1197` |
| `FlutterFlowIconButton` (`flutter_flow_icon_button.dart:18`) | **`false`** | Google `login_widget.dart:628`, `signup_widget.dart:1338` |

Neither Google call site passes the flag, so it stays `false` — no spinner, and
the `IgnorePointer` that would block the tap stays inactive.

**Fix is one argument at two call sites:**

```dart
FlutterFlowIconButton(
  showLoadingIndicator: true,   // <- add
  buttonSize: 40.0,
  ...
```

Email already shows a spinner. If it *looks* like it doesn't, the likely reason
is that `FFButtonWidget` swaps the label for a 23px indicator inside a 35px-high
button — easy to miss, worth a visual check before changing anything.

> **Correction to the old notes:** they also claimed repeated taps "stack
> multiple concurrent sign-in attempts". They do not. *Both* widgets guard
> re-entry with `if (loading) return;` before setting state, and that guard runs
> regardless of `showLoadingIndicator`. Concurrency was never the bug — only the
> missing visual was.

## Cause 4 — cancel and failure are indistinguishable

Every call site:

```dart
final user = await authManager.signInWithGoogle(context);
if (user == null) {
  return;                       // silent no-op
}
```

`null` is returned both when the user deliberately dismissed the account picker
**and** when sign-in genuinely broke. On mobile, `googleSignInFunc` returns null
on cancel because `_googleSignIn.signIn()` returns null (`google_auth.dart:14`),
which is correct — but the caller cannot tell it apart from a real failure.

**Fix:** have the manager distinguish the two — either a sentinel result or an
explicit "cancelled" flag — so genuine failures always produce feedback and
cancels stay silent.

On **web** the same journey throws `FirebaseAuthException` with
`popup-closed-by-user` (a cancel) or `popup-blocked` (a real failure, and one
worth its own copy: the user has to allow popups). Both currently render as raw
text. `google_auth.dart:9` takes the `signInWithPopup` path when `kIsWeb`.

## Cause 5 — the actual production bug: SHA-1 not registered

Verified 2026-08-18. The local debug keystore SHA-1

```
4E:00:BA:DF:9D:45:A5:79:C6:7A:E9:97:E2:92:B9:4F:63:14:6C:61
```

is registered on the **dev** project `yogee-e62e2`
(`android/app/src/debug/google-services.json`) but **not** on production
`yoogeeapp`, whose `google-services.json` lists five other hashes.

So Google sign-in works on debug builds and fails with `ApiException: 10` on
release builds. **That is the "sometimes".**

**Fix:** register the release/upload keystore's SHA-1 on `yoogeeapp` in the
Firebase console, then re-download `android/app/google-services.json`.
**Blocked on production Firebase access.**

Causes 1–4 are why nobody could tell *what* was failing. Cause 5 is the failure.

## Cause 6 — `notifyOnAuthChange` is left stuck false after a failed attempt

Secondary, but it explains intermittent "no callback" reports after a first
failed try.

Every call site opens with `GoRouter.of(context).prepareAuthEvent()`
(`nav.dart:391`), which sets `notifyOnAuthChange = false`. That flag is only
restored inside `AppStateNotifier.update()` (`nav.dart:72`) — which runs on an
actual auth change.

If sign-in fails or is cancelled, `update()` never runs and **the flag stays
false**. Until the next real auth event, an unexpected sign-out or token
expiry will not `notifyListeners()`, so the router does not refresh.

`signup_widget.dart:1219` makes this easy to hit: it calls `prepareAuthEvent()`
*before* the password-match check, then `return`s early on mismatch — flag set,
no auth event, no reset.

**Fix:** restore the flag when the attempt ends without an auth change — a
`finally` in `_signInOrCreateAccount`, and move the signup validation above the
`prepareAuthEvent()` call.

---

## Fix order

Cheapest and highest-value first. Items 1–3 are one-liners.

| # | Fix | File | Effort |
|---|---|---|---|
| 1 | `e.message ?? '...'` — stop the handler crashing | `firebase_auth_manager.dart:321`, `:125`, `:141` | 3 lines |
| 2 | `showLoadingIndicator: true` on both Google buttons | `login_widget.dart:628`, `signup_widget.dart:1338` | 2 lines |
| 3 | Move signup password check above `prepareAuthEvent()` | `signup_widget.dart:1219` | move 8 lines |
| 4 | Catch `PlatformException`, map ApiException codes, 12501 silent | `firebase_auth_manager.dart:315` | small |
| 5 | Friendly copy for common `FirebaseAuthException` codes | same switch | small |
| 6 | Distinguish cancel from failure | manager + 4 call sites | medium |
| 7 | Reset `notifyOnAuthChange` in a `finally` | `firebase_auth_manager.dart` | small |
| 8 | Register release SHA-1 on `yoogeeapp` | Firebase console | **blocked** |

Codes worth real copy in item 5: `wrong-password`, `user-not-found`,
`invalid-credential`, `network-request-failed`, `too-many-requests`,
`account-exists-with-different-credential`, `popup-blocked`,
`email-already-in-use` (already has copy), `INVALID_LOGIN_CREDENTIALS`
(already has copy).

## Verification

- Google, release build, before the SHA-1 fix → should now show a real message
  instead of nothing. This is the test that proves Cause 1 is fixed.
- Google, cancel the picker → spinner stops, no error shown.
- Email, wrong password → friendly copy, not `Error: The supplied auth
  credential is incorrect, malformed or has expired`.
- Email, airplane mode → friendly network copy, not silence.
- Tap Google twice quickly → one attempt, spinner visible throughout.
- Fail a sign-in, then sign in successfully → redirect still works (Cause 6).

## Note on editing these files

`login_widget.dart` and `signup_widget.dart` are generated page widgets. Per
`CLAUDE.md` this repo is now the source of truth and they are edited by hand, so
direct edits are correct here. The manager fixes live in `lib/auth/`, which is
not regenerated either.
