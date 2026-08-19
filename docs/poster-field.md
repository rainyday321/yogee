# `posts.poster` — author reference

The `poster` field on a `posts` document is a `DocumentReference` to
`users/{uid}`. It is the only link between a post and its author: there is no
denormalised author name, handle, or avatar on the post itself. Every screen
that shows a post therefore resolves the author with a second read.

## Schema

`lib/backend/schema/posts_record.dart`

```dart
// "poster" field.
DocumentReference? _poster;
DocumentReference? get poster => _poster;
bool hasPoster() => _poster != null;
```

Nullable in Dart, and nothing enforces its presence in Firestore.
`createPostsRecordData({DocumentReference? poster, ...})` also takes it as
optional and drops nulls (`.withoutNulls`), so a post document created without
a poster is schema-valid.

Related fields on the same document: `topic`, `image`, `images`, `date`,
`likes` (list of `users` refs), `tags`, `des`, `artist`, `comments`.

## Write path

One place writes it — `lib/community/newpost/newpost_widget.dart:114`:

```dart
await PostsRecord.collection.doc().set({
  ...createPostsRecordData(
    topic: _model.textController.text,
    poster: currentUserReference,
    image: _model.uploadedFileUrl_uploadData2dt,
    date: getCurrentTimestamp,
  ),
  ...mapToFirestore({'tags': FFAppState().selectedtags}),
});
```

`poster` is always `currentUserReference` and is never updated afterwards.
Treat it as immutable once written.

## Read paths

| What | Where | Query / use |
|---|---|---|
| Own post count | `myprofilepage_widget.dart:74` | `queryPostsRecordCount(where poster == currentUserReference)` |
| Own posts list | `myprofilepage_widget.dart:1272` | `where poster == currentUserReference` + `orderBy date desc`, paged by `_model.postsPageSize` |
| Author lookup | `myprofilepage_widget.dart:1427` | `UsersRecord.getDocument(listViewPostsRecord.poster!)` |
| Replies nav param | `myprofilepage_widget.dart:1723` | passed as `userref` to `RepliesWidget` |
| Delete-button gate | `myprofilepage_widget.dart:1795` | `if (listViewPostsRecord.poster == currentUserReference)` |
| Global feed | `community_widget.dart:398` | `whereNotIn('poster', currentUserDocument.blocked)` |
| Following feed | `community_widget.dart:1026`, `:1066` | `whereIn('poster', currentUserDocument.following)` |
| Avatar/name tap | `community_widget.dart:546`, `:630`, `:1224`, `:1280` | own post goes to `MyprofilepageWidget`, else `OthersprofileWidget(profileowner: poster)` |
| Like notification | `community_widget.dart:852`, `othersprofile_widget.dart:2014`, `replies_widget.dart:504` | skips self-notify, else writes `NotificationsRecord(madeto: poster)` |
| Other user's profile | `othersprofile_widget.dart:279`, `:1607`, `:1678` | same three queries as the own-profile page, keyed on `widget.profileowner` |

## Index

`firebase/firestore.indexes.json` carries the composite index the profile
queries need:

```json
{ "collectionGroup": "posts",
  "fields": [ { "fieldPath": "poster", "order": "ASCENDING" },
              { "fieldPath": "date",   "order": "DESCENDING" } ] }
```

Any new `poster` + `orderBy` combination needs its own entry here, otherwise the
stream fails with `FAILED_PRECONDITION: The query requires an index`.

## Security rule

`firebase/firestore.rules` — `poster` is the delete authorisation key:

```
match /posts/{document} {
  allow create: if true;
  allow read:   if true;
  allow update: if true;
  allow delete: if request.auth != null
    && resource.data.poster == /databases/$(database)/documents/users/$(request.auth.uid);
}
```

Note `allow update: if true` — anyone may rewrite any post, including its
`poster`. The delete rule is only as strong as the update rule allows.
`allow write` is deliberately *not* used, because `write` covers delete and
allow rules are OR'd, which would nullify the ownership check.

The client-side check at `myprofilepage_widget.dart:1795` only hides the
button; the rule is what enforces it.

## Cascade on delete

Deleting a post removes the document only. Comments live in a separate
`comments` collection pointing back at the post, and clients cannot delete
them. `onPostDeleted` (`firebase/functions/index.js:15`) runs the cascade with
admin privileges.

## Gotchas

- **Nullable, dereferenced with `!`.** `poster!` at `myprofilepage_widget.dart:1430`,
  `community_widget.dart:492`, `:1173`, and `othersprofile_widget.dart:1816`.
  A post document missing `poster` crashes the list build, not just that row.
  Seed and import scripts must always set it.
- **30-value cap on `whereIn` / `whereNotIn`.** The blocked and following feeds
  pass user lists straight into the filter. Past 30 entries Firestore rejects the
  query and the feed goes empty. Empty lists are already handled — the
  `QueryExtension` helpers in `lib/backend/backend.dart:600-606` degrade to an
  unfiltered query rather than throwing.
- **N+1 reads.** Each rendered post opens its own `UsersRecord.getDocument`
  stream. A 20-post page is 21 listeners.
- **No denormalised author data.** Renaming a user updates everywhere for free,
  but every feed pays the extra read for it.
- **Two spellings in the codebase.** `songs.poster` (`songs_record.dart:44`) is
  an unrelated `String` cover-image URL, as is `posterUrl` in
  `lib/custom_code/song_data.dart`. Neither has anything to do with post
  authorship.
