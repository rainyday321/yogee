"""Make a sticker's flat background transparent, keeping its animation.

Works on PNG/APNG, WebP (animated or not) and GIF. Every frame is composited,
the background is flood-filled away from the border only (so white eyes or
highlights inside the character survive), and the result is written back with
the original frame delays and an infinite loop.

    python tools/unbg.py public/main_content/dudu_emblem.png
    python tools/unbg.py sticker.webp --inplace
    python tools/unbg.py a.png b.webp --tol 20 --color "#ffffff"

Needs Pillow; installs it on first run if missing.
"""
import argparse
import subprocess
import sys
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageOps
except ImportError:
    print('installing Pillow...')
    subprocess.check_call([sys.executable, '-m', 'pip', 'install', '--quiet', 'pillow'])
    from PIL import Image, ImageDraw, ImageOps

# WebP animations are capped at this many colours-per-pixel decisions by the
# encoder; lossless keeps the flat sticker colours and the new alpha crisp.
SAVE_OPTS = {
    'PNG': dict(format='PNG'),
    'WEBP': dict(format='WEBP', lossless=True, quality=100),
    'GIF': dict(format='GIF'),
}


def frames_of(im):
    """Composited RGBA frames plus their delays in ms."""
    out, delays = [], []
    for i in range(getattr(im, 'n_frames', 1)):
        im.seek(i)
        out.append(im.convert('RGBA'))
        delays.append(im.info.get('duration', 100))
    return out, delays


def pick_bg(frame):
    """The background is whatever colour the corners agree on."""
    w, h = frame.size
    corners = [frame.getpixel(p) for p in ((0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1))]
    return max(set(corners), key=corners.count)


def strip(frame, bg, tol, dehalo):
    """Flood-fill the border-connected background to alpha 0."""
    # One pixel of padding turns every border-touching background region into a
    # single region reachable from (0, 0), so one fill does the whole edge.
    padded = ImageOps.expand(frame, border=1, fill=bg)
    ImageDraw.floodfill(padded, (0, 0), (0, 0, 0, 0), thresh=tol)
    w, h = frame.size
    out = padded.crop((1, 1, w + 1, h + 1))

    if dehalo:
        # Anti-aliased pixels blended towards the old background stay behind as
        # a pale fringe. Fade the ones sitting right against the new hole.
        px = out.load()
        faded = []
        for y in range(h):
            for x in range(w):
                r, g, b, a = px[x, y]
                if a == 0:
                    continue
                if not any(px[x + dx, y + dy][3] == 0
                           for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))
                           if 0 <= x + dx < w and 0 <= y + dy < h):
                    continue
                # How close is this pixel to the background it bled from?
                dist = max(abs(r - bg[0]), abs(g - bg[1]), abs(b - bg[2]))
                if dist < 55:
                    faded.append(((x, y), (r, g, b, dist * 255 // 55)))
        for xy, rgba in faded:
            px[xy] = rgba
    return out


def convert(path, args):
    src = Path(path)
    with Image.open(src) as im:
        fmt = (im.format or src.suffix.lstrip('.')).upper()
        frames, delays = frames_of(im)

    bg = args.color or pick_bg(frames[0])
    frames = [strip(f, bg, args.tol, not args.no_dehalo) for f in frames]

    dst = src if args.inplace else src.with_name(f'{src.stem}_nobg{src.suffix}')
    if args.inplace:
        backup = src.with_suffix(src.suffix + '.orig')
        if not backup.exists():
            backup.write_bytes(src.read_bytes())
    opts = SAVE_OPTS.get(fmt, dict(format=fmt))
    frames[0].save(dst, save_all=True, append_images=frames[1:],
                   duration=delays, loop=0, disposal=2, **opts)
    print(f'{src.name}: {len(frames)} frame(s), bg={bg[:3]} -> {dst.name}')


def hexcolor(s):
    s = s.lstrip('#')
    return tuple(int(s[i:i + 2], 16) for i in (0, 2, 4)) + (255,)


def main():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument('files', nargs='+')
    p.add_argument('--tol', type=int, default=12,
                   help='how far a pixel may stray from the background colour and still be cut (default 12)')
    p.add_argument('--color', type=hexcolor,
                   help='background colour, e.g. "#ffffff" (default: sampled from the corners)')
    p.add_argument('--inplace', action='store_true',
                   help='overwrite the input, keeping a .orig backup')
    p.add_argument('--no-dehalo', action='store_true',
                   help='keep the anti-aliased fringe instead of fading it')
    args = p.parse_args()
    for f in args.files:
        convert(f, args)


if __name__ == '__main__':
    main()
