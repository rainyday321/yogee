"""Convert images between formats and shrink them for the web.

Reads anything Pillow can open, plus HEIC/HEIF from an iPhone. Applies the EXIF
rotation, optionally scales the long edge down, and writes the target format
with sane compression. Prints the before/after byte count for each file.

    python tools/imgconv.py public/main_content/first_pic_ever.HEIC --to webp
    python tools/imgconv.py photo.HEIC --to png --max 1600 --colors 256
    python tools/imgconv.py public/main_content/*.png --to webp --max 1200
    python tools/imgconv.py --selftest

Needs Pillow (+ pillow-heif for HEIC); installs them on first run if missing.
"""
import argparse
import subprocess
import sys
from pathlib import Path

try:
    from PIL import Image, ImageOps
except ImportError:
    print('installing Pillow...')
    subprocess.check_call([sys.executable, '-m', 'pip', 'install', '--quiet', 'pillow'])
    from PIL import Image, ImageOps

EXT = {'webp': '.webp', 'png': '.png', 'jpg': '.jpg', 'jpeg': '.jpg', 'avif': '.avif'}


def opts_for(fmt, quality):
    """Encoder settings per target format. method/effort 6 = slowest, smallest."""
    if fmt == 'webp':
        return dict(format='WEBP', quality=quality, method=6)
    if fmt == 'avif':
        return dict(format='AVIF', quality=quality)
    if fmt in ('jpg', 'jpeg'):
        return dict(format='JPEG', quality=quality, optimize=True, progressive=True)
    return dict(format='PNG', optimize=True)


def load(path):
    if path.suffix.lower() in ('.heic', '.heif'):
        try:
            import pillow_heif
        except ImportError:
            print('installing pillow-heif...')
            subprocess.check_call([sys.executable, '-m', 'pip', 'install', '--quiet', 'pillow-heif'])
            import pillow_heif
        pillow_heif.register_heif_opener()
    return ImageOps.exif_transpose(Image.open(path))


def convert(path, args):
    src = Path(path)
    im = load(src)

    # JPEG has no alpha; WebP/AVIF/PNG keep it.
    if args.to in ('jpg', 'jpeg'):
        im = im.convert('RGB')
    elif im.mode not in ('RGB', 'RGBA'):
        im = im.convert('RGBA' if 'A' in im.getbands() else 'RGB')
    if args.max:
        im.thumbnail((args.max, args.max), Image.LANCZOS)
    if args.colors:
        # Palette mode is the only way a photo gets small as a PNG; it also
        # costs real quality, so it stays opt-in.
        im = im.quantize(colors=args.colors, method=Image.FASTOCTREE,
                         dither=Image.FLOYDSTEINBERG)

    dst = Path(args.out or src.parent) / (src.stem + EXT[args.to])
    if dst.resolve() == src.resolve():
        dst = dst.with_name(f'{src.stem}_opt{EXT[args.to]}')
    dst.parent.mkdir(parents=True, exist_ok=True)
    im.save(dst, **opts_for(args.to, args.quality))

    before, after = src.stat().st_size, dst.stat().st_size
    print(f'{src.name} {before // 1024}K -> {dst.name} {after // 1024}K '
          f'({100 - after * 100 // before}% smaller, {im.size[0]}x{im.size[1]})')
    return dst


def selftest():
    """Round-trip a synthetic photo through every target format."""
    import tempfile
    with tempfile.TemporaryDirectory() as d:
        src = Path(d) / 'src.png'
        Image.effect_mandelbrot((900, 600), (-3, -2.5, 2, 2.5), 40).convert('RGB').save(src)
        for to in ('webp', 'png', 'jpg'):
            args = argparse.Namespace(to=to, max=300, quality=80, colors=None, out=d)
            dst = convert(src, args)
            assert dst.suffix == EXT[to], dst
            with Image.open(dst) as out:
                assert max(out.size) == 300, out.size
                assert out.size == (300, 200), out.size
        args = argparse.Namespace(to='png', max=None, quality=80, colors=64, out=d)
        small = convert(src, args)
        assert small.stat().st_size < src.stat().st_size, 'quantized PNG should shrink'
    print('selftest ok')


def main():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument('files', nargs='*')
    p.add_argument('--to', choices=sorted(EXT), default='webp',
                   help='target format (default webp: smallest for photos, keeps alpha)')
    p.add_argument('--max', type=int, default=1600,
                   help='cap the long edge at this many pixels, 0 to keep the original size (default 1600)')
    p.add_argument('--quality', type=int, default=82,
                   help='lossy quality for webp/jpg/avif (default 82)')
    p.add_argument('--colors', type=int,
                   help='quantize to N colours; the only way a PNG photo gets small, at a visible cost')
    p.add_argument('--out', help='write here instead of next to the input')
    p.add_argument('--selftest', action='store_true')
    args = p.parse_args()

    if args.selftest:
        return selftest()
    if not args.files:
        p.error('give me some files (or --selftest)')

    # One bad file must not take the batch with it. A 166-photo run died on a
    # single transient OSError from the filesystem and lost the 130 conversions
    # that had not happened yet; re-running the whole thing to get past one file
    # is the expensive kind of tidy. Failures are reported and counted, and the
    # exit code still says something went wrong.
    failed = 0
    for f in args.files:
        try:
            convert(f, args)
        except Exception as e:
            failed += 1
            print(f'{Path(f).name}: FAILED — {e}')
    if failed:
        print(f'{failed} of {len(args.files)} failed')
        return 1


if __name__ == '__main__':
    sys.exit(main())
