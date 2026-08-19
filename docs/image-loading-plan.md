# Images load slowly

Status: **not started.** Plan for `todo-fix.txt` item 2.

Counts below were re-verified against the tree on 2026-08-19. Two claims in the
original notes were wrong; both are corrected inline and flagged.

---

## Symptom

Images take a long time to appear, and keep reloading.

## Root cause: the source assets are enormous

Measured against production (`yoogeeapp`) on 2026-08-18, `albums` collection:

| Album | Size | Type |
|---|---:|---|
| Dark to Light | 12,608 KB | `image/png` |
| Big Budda – Part 1 | 7,080 KB | `image/png` |
| Tuscany, Italy | 3,899 KB | `image/png` |
| Ko Mak living hammock | 3,627 KB | `image/png` |
| Buzzas resort | 2,997 KB | `image/png` |
| Koh Yai Yao jungle | 1,945 KB | `image/jpeg` |
| Riparbella, Tuscany | 1,621 KB | `application/octet-stream` |

**~33 MB across seven albums.** The dashboard carousel fetches five of them to
draw at **90×90** (`dashboard_widget.dart:1277`).

These are photographs stored as PNG — a lossless format meant for flat-colour
graphics. As WebP or JPEG at display resolution they would be roughly 20–50 KB
each. One has no image content-type at all. A CMS filename seen earlier
(`Screenshot 2024-09-19 at 13.10.41 Copy.png`) suggests raw screenshots are being
uploaded unprocessed.

---

## Four compounding problems

**a. Unoptimised source assets** (above). Worth 50–100× and needs **no code** —
but needs production Storage access.

**b. Nothing is cached to disk.** 40 `Image.network` call sites against **2**
`CachedNetworkImage`, even though `cached_network_image` 3.4.1 is already a
dependency. The only two uses are `meditation_widget.dart:1432` and `:1716`.
`Image.network` uses Flutter's in-memory `ImageCache` only, which dies with the
process — so every cold start re-downloads all 33 MB.

**c. The in-memory cache thrashes within a session.** Flutter's default
`ImageCache` holds 100 MB of *decoded* bitmaps. Decoded size is
`width × height × 4` bytes and is unrelated to file size, so a few large photos
evict each other and get re-downloaded mid-scroll.

**d. No downscaling at decode time.** `cacheWidth` / `memCacheWidth` appear
**zero** times in the codebase (verified). Every image decodes at full resolution
and is then scaled down for painting, so CPU and memory cost is paid in full
regardless of the 90×90 box it lands in.

Minor: `dashboard_widget.dart` imports `flutter_blurhash` (`:18`) and
`octo_image` (`:20`) and uses neither — an abandoned progressive-placeholder
attempt. Safe to delete.

---

## Call-site survey

Verified counts (reliable, from direct search):

| | |
|---|---|
| `Image.network` occurrences | **40**, across **24** files |
| `CachedNetworkImage` | **2** (`meditation_widget.dart:1432`, `:1716`) |
| `cacheWidth` / `memCacheWidth` / `maxWidthDiskCache` | **0** |
| `double.infinity` width | **1** — `detail_page_widget.dart:98`, the full-bleed hero |
| Largest fixed width | **260** logical px |
| Distinct fixed widths | 47, 52, 60, 65, 70, 80, 90, 100, 204, 220, 230, 260 |

> **Correction 1 — error handling.** The original notes said *"3 have any error
> handling, all in `music_player_widget.dart`"*. Wrong on both count and location.
> There are **4** image `errorBuilder`s across **two** files:
> `music_player_widget.dart:189`, `:268` and `community_widget.dart:599`, `:768`.
> (A fifth `errorBuilder` at `nav.dart:86` is GoRouter's, not an image.)
> So **36** sites lack error handling, not 37.

> **Correction 2 — the dashboard has two sites**, `dashboard_widget.dart:312` and
> `:1277`, not just `:1277`.

> **Open: the sized/unsized split needs a manual recount.** The original notes say
> 27 sized / 12 unsized. An automated pass over the call sites gave 22 sized /
> 17 unsized, but that parser also undercounted `errorBuilder` (2 vs the true 4),
> so it is not trustworthy either. **Count by hand during implementation.** The
> design decision below does not change — only the size of the unsized group does.

---

## Proposed fix — one wrapper widget, not 40 hand-edits

Add a widget in `lib/custom_code/` (same placement as `card_stroke.dart` and the
new `loading_overlay.dart`, which FlutterFlow leaves alone). It takes the
arguments the call sites already pass, so each site is a one-word rename:

```dart
Image.network(url, width: 90, height: 90, fit: BoxFit.cover)
  ->  NetImage(url, width: 90, height: 90, fit: BoxFit.cover)
```

Internally it wraps `CachedNetworkImage` and derives the cache caps itself.

### The DPR trap — why it must be a wrapper

`memCacheWidth` is in **physical** pixels; `width:` is in **logical** pixels.
Writing `memCacheWidth: 90` beside `width: 90` on a 3× phone decodes at one third
of the needed resolution and every thumbnail goes visibly soft.

The cap must be `width × MediaQuery.devicePixelRatioOf(context)`, which needs a
`BuildContext` and therefore **cannot be a literal at each site**. One wrapper
computes it correctly once; 40 inline literals would be 40 chances to get it wrong.

Pass the same value to `maxWidthDiskCache` so the stored file is small too.

### The unsized sites

No static width means no derivable cap. Either a `LayoutBuilder` (exact, costs a
layout pass) or a fixed ceiling when `width` is null.

**Recommend the ceiling at ~1080 physical px:** one branch instead of a
wrapper-wide layout pass, and still far below a 12 MB source. The genuine
full-bleed hero at `detail_page_widget.dart:98` wants the larger budget anyway.

### Placeholder and error

`CachedNetworkImage` requires both. Use a flat neutral-fill box for each, **not a
spinner** — a spinner in a 90×90 tile reads as broken, and this codebase already
has a history of spinners that never resolve (profile page, New Meditations
carousel; see also `upload_data.dart:357`, which uses `Duration(days: 1)`).

Side benefit: **36 sites gain error handling** they do not currently have.

---

## Rollout order

Worst thrash first, so it can stop early if that turns out to be enough.

1. `dashboard_widget.dart:1277` — 90×90 carousel, five multi-MB albums (and `:312`)
2. `meditation_widget.dart:1432`, `:1716` — already cached, just missing the caps
3. Feed and list images — `community_widget.dart:1272`, `:1381`, replies,
   playlists, `next_widget`, `play_list`
4. Avatars — 52–90 px, many per screen
5. One-offs and settings screens

---

## What this fixes and what it does not

`memCacheWidth` caps **decoding**, not **downloading**. The 12.6 MB PNG still
crosses the wire in full on first view.

| | before | after |
|---|---|---|
| First load, cold | 33 MB down, full-res decode | 33 MB down, small decode |
| Second load, same session | often re-downloaded | from memory |
| After app restart | re-downloads everything | from disk |
| Memory / jank | large bitmaps evicting | flat |
| Web | broken by CORS | still broken by CORS |

Scrolling gets smooth and restarts get fast, but the first view of a 12 MB cover
is still slow. **Only re-encoding the source assets fixes transfer.**

Do **not** raise the global `ImageCache` limit in `main.dart`. With decode capped,
the default 100 MB stops being the constraint; raising it papers over the cause.

---

## Risks

- `CachedNetworkImage` has no `loadingBuilder` / `frameBuilder`. The two sites in
  `music_player_widget.dart` use `errorBuilder` and are hand-written custom code —
  leave those alone rather than translate them.
- Sites wrapped in `Visibility(visible: isValidUrl(...))` keep that guard; it is
  orthogonal.
- If the FlutterFlow project is ever re-exported, the page-file renames revert.
  The wrapper in `lib/custom_code/` survives. Per `CLAUDE.md` the repo is now the
  source of truth, so this is theoretical unless someone deliberately re-exports.
