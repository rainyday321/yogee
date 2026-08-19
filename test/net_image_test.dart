// Guards the decode cap. The bug this prevents: memCacheWidth is in PHYSICAL
// pixels while `width:` is LOGICAL, so writing `memCacheWidth: 90` next to
// `width: 90` decodes a 3x phone's thumbnail at a third of the needed
// resolution and it goes visibly soft.
import 'package:flutter_test/flutter_test.dart';

import 'package:yogee/custom_code/net_image.dart';

void main() {
  test('cap scales with device pixel ratio, not logical width', () {
    expect(NetImage.decodeCap(90.0, 1.0), 90);
    expect(NetImage.decodeCap(90.0, 2.0), 180);
    expect(NetImage.decodeCap(90.0, 3.0), 270);
  });

  test('a fractional ratio rounds rather than truncating', () {
    // 2.625 is a real Android dpr (xxhdpi-ish). 90 * 2.625 = 236.25.
    expect(NetImage.decodeCap(90.0, 2.625), 236);
    expect(NetImage.decodeCap(65.0, 2.75), 179);
  });

  test('no width falls back to the ceiling, not to zero or null', () {
    final cap = NetImage.decodeCap(null, 3.0);
    expect(cap, greaterThan(0));
    expect(cap, 1080);
  });

  test('the cap is always at least the logical width', () {
    // Guards against the inverted-conversion mistake (dividing by dpr).
    for (final w in [47.0, 52.0, 90.0, 260.0]) {
      for (final dpr in [1.0, 2.0, 3.0, 3.5]) {
        expect(NetImage.decodeCap(w, dpr), greaterThanOrEqualTo(w.round()),
            reason: 'width $w at dpr $dpr decoded below its own size');
      }
    }
  });
}
