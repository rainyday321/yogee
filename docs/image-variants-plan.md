# Image variants — pre-generated sizes in a modern format

Status: **not started. Blocked on production Storage access.**

Companion to [`image-loading-plan.md`](image-loading-plan.md). That one is about
how the client *decodes and caches* images; this one is about what crosses the
wire in the first place.

---

## Why this exists

`NetImage` caps **decoding** (`memCacheWidth` / `maxWidthDiskCache`). It does not
cap **downloading**. A 12.6 MB PNG still transfers in full on first view, every
time the disk cache is cold.

That is the remaining half of the problem, and no client-side change can fix it.
The only fix is to stop serving 12.6 MB when 30 KB would do.

Measured on production (`yoogeeapp`) 2026-08-18: **~33 MB across seven album
covers**, largest 12,608 KB, mostly PNG — a lossless format meant for flat-colour
graphics, used here for photographs. One has content-type
`application/octet-stream`. A filename seen earlier
(`Screenshot 2024-09-19 at 13.10.41 Copy.png`) suggests raw screenshots are being
uploaded unprocessed, so this will keep happening without a fix at the upload
side.

---

## The client half is already done

All 44 image call sites route through `lib/custom_code/net_image.dart`, which
already computes the physical pixel width it needs:

```dart
static int decodeCap(double? width, double devicePixelRatio)
```

Variant selection is therefore **one function in one file**, not a 44-site
change. This is the cheap part. The work is on the asset side.

### Sizes actually needed

From the call-site survey — the largest fixed width in the entire app is
**260 logical px**, and there is exactly one full-bleed image
(`detail_page_widget.dart:99`, `width: double.infinity`).

| Variant (px) | Serves | Call sites |
|---:|---|---|
| **128** | avatars | 47–90pt |
| **400** | cards, carousels, list rows | 150–260pt |
| **1080** | the one hero | `detail_page_widget.dart:99` |

At 3× DPI a 260pt card needs 780px, so 400 is a slight under-serve on the largest
card at the highest density; 512 would be the safe alternative if that shows.
Everything else has generous headroom.

**Format: WebP.** Photographs at 400px land around 20–40 KB against 12.6 MB
today. That is the 50–100× win, and it requires no client change at all — even
without variant selection, re-encoding alone fixes most of this.

---

## How to generate them

### Recommended: Firebase Extension `storage-resize-images`

Official, no backend code, runs on upload. No extensions are configured today
(`firebase/firebase.json` has no `extensions` block, and there is no
`firebase/extensions/` directory).

Configure: sizes `128,400,1080`, output format WebP, keep original.

### Alternatives considered

| Option | Verdict |
|---|---|
| **Custom Cloud Function** (`sharp` on finalize) | More control, more code to own. Only worth it if the extension's naming or paths do not fit. |
| **Image CDN** (Cloudflare Images, imgix, Cloudinary) | Best ergonomics — `?w=400&fm=webp` on demand, no backfill, no variant bookkeeping. Costs a vendor and a monthly bill. Hard to justify for seven covers. |
| **Client-side resize before upload** | Cheapest, but only helps future uploads and discards the original. Worth doing *as well*, at the CMS/upload side. |

---

## Three things that will bite

### 1. Firebase Storage download URLs are not derivable

The URLs in this codebase look like:

```
https://firebasestorage.googleapis.com/v0/b/yoogeeapp.firebasestorage.app/o/thumb.png?alt=media&token=e6577b33-e529-48be-8df3-6a94f5b68e16
```

**That `token` is per-object.** Replacing `thumb.png` with `thumb_400x400.webp`
in the string produces a URL that 403s, because the variant is a different object
with a different token. This is the detail that sinks the naive implementation,
and it must be decided before any code is written.

Two viable routes:

**(a) Store the variant URLs.** Add fields (or a map) next to the existing image
field and have the extension or a function write them. Explicit, no security
change, but it is a schema change on every collection below and the client must
handle documents written before the change.

**(b) Make image objects publicly readable** and address them by token-free path:

```
https://storage.googleapis.com/<bucket>/<path>_400x400.webp
```

Derivable, so `NetImage` can construct variant URLs itself with no schema change
at all. The trade-off is that those objects become world-readable.

> Worth weighing honestly: `firestore.rules` already grants
> `allow read: if true` on most collections, and the covers are already served to
> every client, so (b) is close to a no-op in practice here. It is still a
> deliberate widening and should be an explicit decision, not a side effect.

**Recommendation: (b)**, given the existing posture and that it keeps the client
trivial. If the security posture is ever tightened (which it should be), revisit.

### 2. The extension only processes new uploads

Existing objects are untouched. A **one-off backfill** is required — re-upload
each, or run the existing objects back through the resizer. Seven album covers is
small enough to do by hand; `users.photo_url` and `posts.image` are not, if those
have accumulated.

### 3. It needs production Storage access

Same blocker as the CORS item in `todo-fix.txt`. Do everything on `yogee-e62e2`
first and promote once proven. Do not experiment against `yoogeeapp`.

---

## Scope: which collections carry images

| Collection | Field(s) | Priority |
|---|---|---|
| `albums` | `cover_image` | **Highest** — the measured 33 MB |
| `songs` | `songCoverImage` | High — player and lists |
| `users` | `photo_url` | High — avatars appear many-per-screen |
| `artists` | `image` | Medium |
| `posts` | `image`, `images` | Medium — user-generated, will grow |
| `chat_messages` | `image` | Medium — user-generated |
| `downloads` | `SongImage`, `coverimage` | Low — mirrors song data |

User-generated collections (`posts`, `chat_messages`) matter most long-term: they
grow without supervision, so the upload-side fix is what keeps this from
recurring.

---

## Client change, once variants exist

In `net_image.dart`, pick the smallest variant at or above the width already
computed:

```dart
final needed = decodeCap(width, dpr);   // exists today
final url    = _pickVariant(baseUrl, needed);   // 128 / 400 / 1080
```

Keep `memCacheWidth` regardless. Variants reduce transfer; the cap still protects
decode when a variant is missing, when a document predates the change, or when a
URL points somewhere without variants (several defaults point at pixabay and
dropbox).

**Fallback is mandatory.** Any variant scheme must degrade to the original URL,
or every image written before this change breaks.

---

## Suggested order

1. **Re-encode the seven existing album covers by hand.** No infrastructure, an
   afternoon, captures most of the win. Do this first — it also validates the
   50–100× estimate before anyone builds anything.
2. Install the extension on `yogee-e62e2`, WebP at 128/400/1080.
3. Decide the URL strategy — (a) stored URLs or (b) public paths. **This is the
   blocking decision**; everything downstream depends on it.
4. Backfill.
5. Teach `NetImage` to select a variant, with fallback to the original.
6. Promote to production, with the owner.
7. Fix the upload path so raw screenshots stop entering the bucket.

Steps 1 and 7 are worth doing even if the rest never happens.

---

## What this does not fix

- **Web is still broken by CORS** (item 3 in `todo-fix.txt`) regardless of image
  size. Unrelated, still blocked on the same access.
- **First view is still a network round-trip.** Smaller, but not free. `NetImage`
  already caches to disk, so this is a first-view-only cost.
- **The `ImageCache` still holds decoded bitmaps.** Variants make each one
  cheaper; they do not change the eviction behaviour.
