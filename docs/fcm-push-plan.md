# Push notifications — FCM implementation plan

Status: **not started.** Nothing in `lib/` sends or receives a push today.

Decision: **FCM, not OneSignal.** See [D1](#d1--fcm-over-onesignal).

This document is the plan for `todo-fix.txt` item 1. Everything below was
verified against the tree, not carried over from memory — the previous notes
contained an error that would have shipped wrong notification copy
(see [Issue 1](#issue-1--the-event-kind-has-four-states-not-three)).

---

## Goal

Deliver a push to a user's phone when someone likes their post, likes their
comment, replies to their post, or follows them — including when the app is
closed — and open the right screen when it is tapped.

---

## Where we are now

Notifications already exist, but only inside the app. Nothing leaves the
device. `pubspec.yaml` has no push package of any kind.

| | |
|---|---|
| **Created by** | `lib/pages/community/community_widget.dart:865, :1428`<br>`lib/community/replies/replies_widget.dart:509, :906, :1278`<br>`lib/community/othersprofile/othersprofile_widget.dart:2014`<br>`lib/community/addfriend/addfriend_widget.dart:156` |
| **Read by** | `lib/community/notifications/notifications_widget.dart`, plus the unread bell badge on `myprofilepage_widget.dart` and `community_widget.dart` |
| **Schema** | `lib/backend/schema/notifications_record.dart` — `isread`, `ispost`, `is_like`, `postref`, `madeby`, `madeto`, `timestamp` |
| **Index** | `madeto ASC + timestamp DESC` already in `firestore.indexes.json` — no new index needed |

The plan adds delivery on top of documents that are **already being written**.
No create site has to change for push to work — but two of them have bugs that
push will amplify (see [Issue 2](#issue-2--self-notify-guards-missing-in-one-place-wrong-in-another)).

---

## Decisions to make before writing code

### D1 — FCM over OneSignal

`firebase/functions/package.json` still carries `@onesignal/node-onesignal
^2.0.1-beta2`, and `CLAUDE.md` names OneSignal as the provider. Nothing in
`lib/` has ever imported it and no OneSignal app id exists anywhere in the tree.
It is a dependency in name only.

FCM wins: `firebase-admin` is already installed and initialised in `index.js`,
the trigger has to be a Firestore trigger either way, and it keeps a
third-party account off the critical path.

The same change should drop the OneSignal dependency and correct `CLAUDE.md`,
or the next person re-litigates this.

### D2 — Add an explicit `type` field

The current boolean encoding cannot be decoded correctly by a function.
See [Issue 1](#issue-1--the-event-kind-has-four-states-not-three).

### D3 — Where device tokens live

**Not** on the user document. See [Issue 3](#issue-3--tokens-must-not-live-on-the-user-document).

### D4 — Which events are opt-out-able

`users` already has `announcement_notification` and `appupdate_notifications`,
toggled in `lib/settings/notificationssettings/notificationssettings_widget.dart:224, :316`.
Neither covers social events. Either add a third preference, or accept that
likes/replies/follows cannot be turned off — a poor default for a wellness app.

**Open question, needs a product call.**

---

## Architecture issues and challenges

### Issue 1 — the event kind has four states, not three

Earlier notes listed three combinations and treated `ispost=false` as "follow".
That is wrong. There are **four** states in use. Verified against both the write
sites and the render branches in `notifications_widget.dart:364, :569, :583, :829, :856`:

| `ispost` | `is_like` | Meaning | Written at |
|---|---|---|---|
| `true` | `true` | liked your post | `community:865, :1428`, `replies:509`, `othersprofile:2014` |
| **`false`** | **`true`** | **liked your comment** | **`replies_widget.dart:1278`** |
| `true` | `false` | replied to your post | `replies:906` |
| `false` | `false` | followed you | `addfriend:156` |

The UI decodes it as: `is_like == true` renders "Liked your" + ("Post" if
`ispost` else "Comment"); `is_like == false` renders "Followed you" when
`ispost` is false and "replied to your post" when true.

A function assuming three states sends **"started following you" to everyone
whose comment got liked.**

**Fix:** add a `type` string (`like_post` | `like_comment` | `reply` | `follow`)
at the write sites and switch on it. Keep a fallback to the boolean pair using
the table above — old clients keep writing the old shape for as long as they
stay installed, so the fallback is not optional.

### Issue 2 — self-notify guards: missing in one place, wrong in another

In-app this is cosmetic. As push it wakes the user's phone for their own action.

| Status | Location |
|---|---|
| Present | `community_widget.dart:860, :1300, :1424` · `replies_widget.dart:503, :900, :1272` |
| **Missing** | `othersprofile_widget.dart:2014` — liking your own post from another user's profile notifies you |
| **Wrong** | `replies_widget.dart:900` guards on `stackPostsRecord.poster == currentUserReference`, but the notification it protects is addressed to `widget!.userref`. Guarding a different reference than the recipient means it does not fire when the two differ. |

**Fix at the recipient, not per call site:** the Cloud Function drops any
document where `madeby == madeto`. One check covering all seven write sites and
any future one. The two client bugs are still worth fixing; the function is the
backstop.

### Issue 3 — tokens must not live on the user document

`firestore.rules:4-9`, on `/users/{document}`:

```
allow read: if true;
allow write: if true;
```

Putting `fcm_tokens` there publishes every device token in the app to anyone
with the public API key, and lets any unauthenticated caller overwrite or wipe
them. Token theft alone does not let an attacker send pushes — that needs the
server credential — but wiping them silently kills delivery, with no error
anywhere.

**Use a subcollection**, `users/{uid}/fcm_tokens/{token}`:

```
match /users/{uid}/fcm_tokens/{token} {
  allow read, write: if request.auth != null && request.auth.uid == uid;
}
```

Subcollections are not covered by the parent's match, so this is a genuine
tightening rather than a rule that gets overridden. Document id = the token,
which makes registration idempotent and deletion trivial. It also sidesteps the
FlutterFlow schema editor entirely.

### Issue 4 — `allow create: if true` becomes a "push any user" endpoint

`firestore.rules:89-91`. Survivable while notifications only render in-app. Not
survivable once a function delivers them: an unauthenticated caller can write a
document with any `madeto` and any `madeby`, and the function faithfully
delivers it.

Required **before** the function ships:

```
allow create: if request.auth != null
  && request.resource.data.madeby ==
     /databases/$(database)/documents/users/$(request.auth.uid);
```

This assumes `madeby` is always the acting user, which matches all seven write
sites — they all pass `currentUserReference`.

### Issue 5 — nothing about FCM delivery can be tested locally

`firebase.json` declares emulators for auth, firestore, storage and ui only —
there is no functions entry, and `firebase/emulators.cmd` starts auth, firestore,
storage. **The trigger cannot fire locally today.**

Adding `functions` to both gets the trigger running, but the send still cannot
be emulated: there is no FCM emulator, and `admin.messaging()` from a function
running against the emulator suite reaches out to real FCM.

**Consequence:** function logic is locally testable, delivery is not. Delivery
needs a real device plus the dev project.

### Issue 6 — the npm scripts point at production

```
"serve": "firebase -P yoogeeapp emulators:start --only functions"
"logs":  "firebase -P yoogeeapp functions:log"
"shell": "firebase -P yoogeeapp functions:shell"
```

`yoogeeapp` is the **production** project with live user data. `npm run serve`
starts a functions emulator whose admin SDK talks to production Firestore,
because no local Firestore runs alongside it. A trigger under development would
read and write real documents.

Point these at `yogee-e62e2`, or pass `-P` explicitly every time, before doing
any function work.

### Issue 7 — dependency resolution risk against the `intl` pin

`pubspec.yaml` pins exact versions with no carets, and per `CLAUDE.md` the build
only works on Flutter 3.41.7 because `flutter_localizations` pins `intl` to
exactly `0.20.2`. Adding `firebase_messaging` and `flutter_local_notifications`
can drag in a transitive constraint that conflicts, and the failure mode is
`version solving failed` — no build at all.

**Do not hand-pick version numbers.** Add one at a time, let pub resolve, and
check `flutter pub deps` for movement on `intl` before committing. If
`flutter_local_notifications` is the conflicting one, foreground display can be
done without it (see [Step 3](#step-3--why-both-packages)).

### Issue 8 — no collapsing; a popular post is one push per like

The function is one-document-in, one-send-out. 200 likes on a post is 200
separate banners.

FCM supports collapsing (Android `collapse_key` / notification tag, iOS
`apns-collapse-id`). Collapse per `(madeto, postref, type)` so the latest
replaces the previous rather than stacking. Worth doing in v1 — retrofitting
means users have already had the bad experience.

### Issue 9 — the notification document carries no display name

`notifications_record.dart` has `madeby` as a `DocumentReference` and nothing
else about the actor. Copy like "Sara liked your post" needs a second read of
the `madeby` user document per send. `users` has `display_name` and `username`
to choose from.

Two reads per notification is fine at this scale. If it stops being fine,
denormalise the name onto the notification at write time rather than caching in
the function.

### Issue 10 — `audio_service` already owns notification infrastructure

`AndroidManifest.xml:60` registers `com.ryanheise.audioservice.AudioService`, and
the app already holds `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_MEDIA_PLAYBACK`
and `WAKE_LOCK`. A second notification-producing plugin is fine, but channel ids
must not collide — and version conflicts between `audio_service` and
`flutter_local_notifications` are the thing to watch during Issue 7's resolution.

---

## Setup

### Step 1 — console (no code)

- Enable the Cloud Messaging API on the Google Cloud project.
- iOS: create an APNs auth key (`.p8`) in the Apple Developer portal, upload
  under **Firebase → Project settings → Cloud Messaging**.

Skip the APNs key and iOS push fails silently: no error, no delivery.

Do this on `yogee-e62e2` first. Production last, with the owner.

### Step 2 — packages

| Package | Role |
|---|---|
| `firebase_messaging` | receives messages |
| `flutter_local_notifications` | draws the banner while the app is foregrounded |

Subject to [Issue 7](#issue-7--dependency-resolution-risk-against-the-intl-pin).
Add, resolve, verify `intl` did not move.

### Step 3 — why both packages

FCM only draws its own banner when the app is backgrounded or killed. A message
arriving in the foreground is delivered as data with **no UI at all**.

If `flutter_local_notifications` conflicts, the fallback is to render foreground
events as an in-app snackbar and accept that only background pushes get a system
notification.

### Step 4 — Android config

- Add `POST_NOTIFICATIONS` to `AndroidManifest.xml`. `targetSdkVersion` is 36
  (`build.gradle:62`), so this is a runtime permission and is mandatory.
- Create a notification channel. Required since API 26 — without one the OS
  discards the notification and reports nothing.
- Tap handling: the manifest already sets `flutter_deeplinking_enabled=true` with
  an `autoVerify` intent-filter, so routing a tap through GoRouter is available
  rather than needing a new mechanism.

### Step 5 — iOS config

- `ios/Runner/Runner.entitlements` exists but is an **empty dict**. It needs
  `aps-environment` (`development`, then `production`).
- `Info.plist:56` `UIBackgroundModes` currently contains only `audio`. Add
  `remote-notification`.
- `AppDelegate.swift` registers plugins and nothing else. Add the notification
  delegate wiring / `registerForRemoteNotifications` there.

### Step 6 — token registration (`lib/custom_code/actions/`)

One custom action that:

- requests notification permission
- writes the token to `users/{uid}/fcm_tokens/{token}` ([Issue 3](#issue-3--tokens-must-not-live-on-the-user-document))
- subscribes to `onTokenRefresh` and writes the new token too
- **deletes the token on sign-out** — otherwise the next person to use that
  device receives the previous user's notifications
- handles the tap payload and navigates

The refresh listener is not optional. Tokens rotate on reinstall, restore, and
sometimes on their own; a stale token stops delivering with no error.

Put this in `lib/custom_code/actions/` — per `CLAUDE.md` that directory is
hand-written and survives, unlike the generated schema files.

Call it **after sign-in**, not in `main()`. See [Gotchas](#gotchas).

### Step 7 — Cloud Function (`firebase/functions/index.js`)

Match the existing v1 style in that file (`onPostDeleted`, `index.js:15`) —
`firebase-functions` is `^4.4.1`, which still serves v1:

```js
exports.onNotificationCreated = functions.firestore
    .document("notifications/{id}")
    .onCreate(async (snap, context) => { ... });
```

It should:

1. drop the document if `madeby == madeto` ([Issue 2](#issue-2--self-notify-guards-missing-in-one-place-wrong-in-another) backstop)
2. resolve the event kind from `type`, falling back to the `ispost`/`is_like`
   pair using the four-row table ([Issue 1](#issue-1--the-event-kind-has-four-states-not-three))
3. read the `madeto` user's `fcm_tokens` subcollection; return early if empty
4. read the `madeby` user document for a display name ([Issue 9](#issue-9--the-notification-document-carries-no-display-name))
5. build the copy and set a collapse id ([Issue 8](#issue-8--no-collapsing-a-popular-post-is-one-push-per-like))
6. send with `sendEachForMulticast`
7. inspect the per-token responses and delete every token returning
   `messaging/registration-token-not-registered` or
   `messaging/invalid-registration-token`

Use `sendEachForMulticast`, **not** `sendMulticast`/`sendAll`. `firebase-admin`
is `^11.11.0`, which has it; the older batch-endpoint methods target an API that
has since been decommissioned.

Step 7 is what stops the token collection filling with dead devices. With tokens
as subcollection documents this is a plain delete — no `arrayRemove`
read-modify-write race.

### Step 8 — verify

- **Function logic:** functions emulator, after adding it to `firebase.json` and
  `emulators.cmd` per [Issue 5](#issue-5--nothing-about-fcm-delivery-can-be-tested-locally), triggered by writing a notification document.
- **Delivery:** real device against `yogee-e62e2`. Cannot be emulated.
- Check all four event kinds × foreground / background / killed, plus the tap
  route for each.

---

## Gotchas

- **iOS shows the permission prompt exactly once, ever.** Do not ask on app
  launch — wait until the user has engaged with something that justifies it. A
  single early decline permanently kills push for that install.
- **Android 13+ silently drops notifications** when `POST_NOTIFICATIONS` was
  never granted. No exception, no log.
- Earlier notes claimed `pubspec.yaml` is regenerated by FlutterFlow and that the
  Step 2 dependencies would be wiped on re-export. Per `CLAUDE.md` the repository
  is now the source of truth, with no FlutterFlow bot commit and no `flutterflow`
  branch — so that risk is theoretical unless someone deliberately re-exports.

---

## Suggested order

Cheapest blocking work first:

1. `firestore.rules` — Issues 3 and 4. Small, and blocks everything else.
2. `madeby == madeto` backstop + the two client guard bugs — Issue 2.
3. Point the npm scripts away from production — Issue 6.
4. `type` field at the write sites, with fallback — Issue 1.
5. Packages and resolution check — Issue 7.
6. Platform config — Steps 4 and 5.
7. Token registration action — Step 6.
8. The function itself — Step 7.

Items 1–3 are worth doing regardless of whether push ever ships.
