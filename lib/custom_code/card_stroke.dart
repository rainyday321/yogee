// Shared card stroke: used by the dashboard cards and by the audio player's
// download / like / playlist buttons.
//
// Lives directly in lib/custom_code/ rather than lib/custom_code/widgets/ or
// lib/custom_code/actions/ on purpose - those two carry index.dart barrels that
// FlutterFlow regenerates on export.

import 'package:flutter/material.dart';

const double kCardStrokeWidth = 1.0;

/// Figma: 2px card stroke, ~121deg (top-left -> bottom-right).
///
/// NOT 180deg. Measured off the Figma export (image copy.png), sampling border
/// luminance around a 133x129 card:
///
///   top edge,    left->right:  153 131 112  94  78  64
///   bottom edge, left->right:   63  56  49  41  38  39
///   left edge,   top->bottom:  129 119 108  99  90  81  73  65  62
///   right edge,  top->bottom:   57  53  54  49  47  46  46  45  43
///
/// A 180deg gradient would leave the top edge uniformly bright across its
/// width. It falls 153->64 instead, and the right edge is flat and dim because
/// it is already deep into the ramp. Brightest at the top-left corner, dimmest
/// at the bottom-right. Falloff measured 0.892/px horizontal, 0.547/px
/// vertical, which is atan2 -> ~121deg.
///
/// begin/end below encode that 121deg. For a clean 135deg (exact
/// topLeft->bottomRight) use (-1,-1) -> (1,1) instead.
///
///   #D4D2D2  100%    opacity  at   0%   -> 0xFFD4D2D2  (255/255 = 100.00%)
///   #353434   36.85% opacity  at  78%   -> 0x5E353434  ( 94/255 =  36.86%)
///   #303030    2.97% opacity  at 100%   -> 0x08303030  (  8/255 =   3.14%)
///
/// Dart's Color alpha is one 8-bit channel, so those bytes are the nearest
/// representable values to the Figma percentages - there is nothing finer to
/// store. Do not "correct" them to 0x5D / 0x07; those are further off.
///
/// The stroke is meant to dissolve, not outline. By the last stop it is 3%
/// opacity over a grey close to the card fill (the card gradient ends at
/// #181818), so the bottom edge reads as no border at all. A flat colour cannot
/// express this - it is either too bright at the bottom or too dim at the top.
///
/// Plain [Alignment], NOT AlignmentDirectional: the painter calls
/// createShader() itself, outside the widget tree, so there is no ambient
/// Directionality to resolve against. AlignmentDirectional asserts there and
/// the stroke silently fails to paint - "To resolve AlignmentDirectional
/// properties, it must be provided with a TextDirection."
const kCardStrokeGradient = LinearGradient(
  begin: Alignment(-1.0, -0.6),
  end: Alignment(1.0, 0.6),
  colors: [
    Color(0xFFD4D2D2),
    Color(0x5E353434),
    Color(0x08303030),
  ],
  stops: [0.0, 0.78, 1.0],
);

/// Paints [kCardStrokeGradient] as a rounded [kCardStrokeWidth] ring.
///
/// BoxDecoration.border only accepts a flat Color per side, so a gradient
/// stroke cannot go through `border:`. Used as a Container's
/// `foregroundDecoration`, which keeps the call sites a one-line change instead
/// of re-nesting every card in an outer gradient container.
///
/// Card call sites pair this with `padding: EdgeInsets.all(kCardStrokeWidth)`
/// to reproduce the child inset that Border.all used to apply. A fixed-size
/// child such as an icon button skips the padding and keeps its own size.
class GradientStroke extends Decoration {
  const GradientStroke({required this.radius});

  /// Outer corner radius, matching the container's own borderRadius.
  final double radius;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _GradientStrokePainter(radius);
}

class _GradientStrokePainter extends BoxPainter {
  _GradientStrokePainter(this.radius);

  final double radius;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size;
    if (size == null) return;
    final bounds = offset & size;
    // Stroke straddles the path, so inset by half its width to keep the ring
    // fully inside the container - the same place Border.all drew it.
    final ring = RRect.fromRectAndRadius(
      bounds.deflate(kCardStrokeWidth / 2),
      Radius.circular(radius - kCardStrokeWidth / 2),
    );
    canvas.drawRRect(
      ring,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = kCardStrokeWidth
        ..shader = kCardStrokeGradient.createShader(bounds),
    );
  }
}
