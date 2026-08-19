import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Drop-in replacement for `Image.network` that caches to disk and caps decode
/// size.
///
/// Why this exists (see docs/image-loading-plan.md): production album covers are
/// multi-MB PNGs drawn into 90x90 boxes. `Image.network` keeps only Flutter's
/// in-memory ImageCache, which holds *decoded* bitmaps and dies with the
/// process, so every cold start re-downloads everything and a few large photos
/// evict each other mid-scroll.
///
/// Call sites change by one word:
///
///     Image.network(url, width: 90, height: 90, fit: BoxFit.cover)
///  -> NetImage(url, width: 90, height: 90, fit: BoxFit.cover)
///
/// ## Why a wrapper and not `memCacheWidth:` at each call site
///
/// `memCacheWidth` is in PHYSICAL pixels; `width:` is in LOGICAL pixels. Writing
/// `memCacheWidth: 90` beside `width: 90` on a 3x phone decodes at one third of
/// the resolution actually needed and the thumbnail goes visibly soft. The cap
/// has to be `width * devicePixelRatio`, which needs a BuildContext -- so it
/// cannot be a literal at the call site. Computing it in one place is also one
/// place to get it wrong instead of forty.
///
/// This caps DECODING, not DOWNLOADING. A 12 MB PNG still crosses the wire in
/// full on first view; only re-encoding the source assets fixes transfer.
class NetImage extends StatelessWidget {
  const NetImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.errorWidget,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  /// Replaces the default error fill. Only for call sites that already had a
  /// specific fallback (e.g. a branded asset) worth preserving -- everywhere
  /// else the default flat fill is the point.
  final Widget? errorWidget;

  /// Convenience for the common `ClipRRect(borderRadius: ...)` wrapper. Leave
  /// null and clip outside if the call site already does.
  final BorderRadius? borderRadius;

  /// Decode ceiling for call sites with no static width, in physical pixels.
  ///
  /// Those sites are sized by their parent, so there is nothing to derive a cap
  /// from without a LayoutBuilder and its extra layout pass. 1080 is generous
  /// for any full-bleed use on a phone and still ~10x smaller than a 12 MB
  /// source decoded whole.
  static const int _unsizedCeiling = 1080;

  /// Decoded-bitmap cap in PHYSICAL pixels for a given logical [width].
  ///
  /// Split out so the devicePixelRatio conversion -- the easy thing to get
  /// wrong here -- can be tested without pumping a widget.
  /// A non-finite width is normal, not exceptional: `width: double.infinity` is
  /// how a full-bleed image says "as wide as the parent" (e.g. the hero at
  /// detail_page_widget.dart:99). `infinity * dpr` is infinity and `.round()`
  /// on that throws `Unsupported operation: Infinity or NaN toInt`, which took
  /// down the whole screen. Anything not finite and positive has no size to
  /// derive a cap from, so it takes the ceiling.
  @visibleForTesting
  static int decodeCap(double? width, double devicePixelRatio) {
    if (width == null || !width.isFinite || width <= 0) {
      return _unsizedCeiling;
    }
    final cap = width * devicePixelRatio;
    return cap.isFinite && cap >= 1 ? cap.round() : _unsizedCeiling;
  }

  @override
  Widget build(BuildContext context) {
    final cap = decodeCap(width, MediaQuery.devicePixelRatioOf(context));

    Widget image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 200),
      // Cap the decoded bitmap and the file kept on disk at what this box can
      // actually show.
      memCacheWidth: cap,
      maxWidthDiskCache: cap,
      // Flat fills, deliberately not spinners: a spinner inside a 90x90 tile
      // reads as broken, and this codebase already has spinners that never
      // resolve. Most call sites currently have no error handling at all, so a
      // bad URL renders a red error box -- this replaces that too.
      placeholder: (context, _) => _Fill(width: width, height: height),
      errorWidget: (context, _, __) =>
          errorWidget ??
          _Fill(
            width: width,
            height: height,
            icon: Icons.image_not_supported_outlined,
          ),
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}

class _Fill extends StatelessWidget {
  const _Fill({this.width, this.height, this.icon});

  final double? width;
  final double? height;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fill = theme.brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.06);

    return Container(
      width: width,
      height: height,
      color: fill,
      alignment: Alignment.center,
      child: icon == null
          ? null
          : Icon(
              icon,
              size: 20.0,
              color: theme.brightness == Brightness.dark
                  ? Colors.white24
                  : Colors.black26,
            ),
    );
  }
}
