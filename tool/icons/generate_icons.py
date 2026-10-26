#!/usr/bin/env python3
"""Generates every platform's app icon from one piece of artwork.

The mark matches the in-app BrandMark: a deep-teal gradient tile with Lucide's
square-code glyph. Run from the repository root after `flutter pub get`:

    python3 tool/icons/generate_icons.py

Requires Pillow. Each platform gets the shape its OS expects: full-bleed opaque
squares for iOS and Android adaptive layers (the OS applies the mask), and
pre-rounded tiles for macOS, Windows, Android legacy launchers and the web.
"""

import json
import os
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parents[2]
MASTER = 2048

TOP_LEFT = (12, 92, 86)
BOTTOM_RIGHT = (22, 163, 142)
GLYPH = ''  # Lucide square-code (FIcons.squareCode).


def _package_root(name):
    config = json.loads((ROOT / '.dart_tool/package_config.json').read_text())
    for package in config['packages']:
        if package['name'] == name:
            uri = package['rootUri']
            path = uri[len('file://'):] if uri.startswith('file://') else uri
            return (ROOT / '.dart_tool' / path).resolve() if not uri.startswith('file://') else Path(path)
    raise SystemExit(f'package {name} not found; run flutter pub get')


LUCIDE = _package_root('forui_assets') / 'assets/lucide.ttf'


def _gradient(size):
    """Diagonal teal gradient with a soft light source at the top left."""
    small = 256
    grad = Image.new('RGB', (small, small))
    pixels = grad.load()
    for y in range(small):
        for x in range(small):
            t = (x + y) / (2 * (small - 1))
            pixels[x, y] = tuple(
                round(a + (b - a) * t) for a, b in zip(TOP_LEFT, BOTTOM_RIGHT)
            )
    grad = grad.resize((size, size), Image.BICUBIC)

    glow = Image.new('L', (size, size), 0)
    ImageDraw.Draw(glow).ellipse(
        (-size * 0.5, -size * 0.6, size * 0.6, size * 0.4), fill=46
    )
    glow = glow.filter(ImageFilter.GaussianBlur(size * 0.22))
    white = Image.new('RGB', (size, size), (255, 255, 255))
    return Image.composite(white, grad, glow)


def _glyph(size, scale):
    """The white glyph centred on a transparent canvas, `scale` of its width."""
    canvas = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    font = ImageFont.truetype(str(LUCIDE), round(size * scale))
    draw = ImageDraw.Draw(canvas)
    left, top, right, bottom = draw.textbbox((0, 0), GLYPH, font=font)
    x = (size - (right - left)) / 2 - left
    y = (size - (bottom - top)) / 2 - top
    shadow = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).text(
        (x, y + size * 0.012), GLYPH, font=font, fill=(4, 40, 36, 90)
    )
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(size * 0.012)))
    draw.text((x, y), GLYPH, font=font, fill=(255, 255, 255, 255))
    return canvas


def full_bleed(glyph_scale=0.56):
    """Opaque square artwork; the OS masks it (iOS, Android adaptive)."""
    image = _gradient(MASTER).convert('RGBA')
    image.alpha_composite(_glyph(MASTER, glyph_scale))
    return image.convert('RGB')


def rounded_tile(inset=0.0, radius=0.225, shadow=False, glyph_scale=0.56):
    """A rounded tile on a transparent canvas (macOS, Windows, web, legacy)."""
    size = MASTER
    tile_size = round(size * (1 - 2 * inset))
    tile = full_bleed(glyph_scale).resize((tile_size, tile_size), Image.LANCZOS)
    mask = Image.new('L', (tile_size, tile_size), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, tile_size - 1, tile_size - 1), radius=round(tile_size * radius), fill=255
    )
    canvas = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    offset = (size - tile_size) // 2
    if shadow:
        drop = Image.new('L', (size, size), 0)
        drop.paste(mask, (offset, offset + round(size * 0.012)))
        drop = drop.filter(ImageFilter.GaussianBlur(size * 0.02))
        drop = ImageChops.multiply(drop, Image.new('L', (size, size), 90))
        canvas.putalpha(drop)
    rgba = tile.convert('RGBA')
    rgba.putalpha(mask)
    canvas.alpha_composite(rgba, (offset, offset))
    return canvas


def save(image, path, px):
    path = ROOT / path
    path.parent.mkdir(parents=True, exist_ok=True)
    image.resize((px, px), Image.LANCZOS).save(path, optimize=True)


def ios(master):
    folder = 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
    entries = [
        ('iphone', 20, 2), ('iphone', 20, 3), ('iphone', 29, 2), ('iphone', 29, 3),
        ('iphone', 40, 2), ('iphone', 40, 3), ('iphone', 60, 2), ('iphone', 60, 3),
        ('ipad', 20, 1), ('ipad', 20, 2), ('ipad', 29, 1), ('ipad', 29, 2),
        ('ipad', 40, 1), ('ipad', 40, 2), ('ipad', 76, 1), ('ipad', 76, 2),
        ('ipad', 83.5, 2), ('ios-marketing', 1024, 1),
    ]
    for old in (ROOT / folder).glob('*.png'):
        old.unlink()
    images = []
    for idiom, points, scale in entries:
        px = round(points * scale)
        name = f'icon-{px}.png'
        save(master, f'{folder}/{name}', px)
        size = f'{points:g}x{points:g}'
        images.append({'filename': name, 'idiom': idiom, 'scale': f'{scale}x', 'size': size})
    (ROOT / folder / 'Contents.json').write_text(
        json.dumps({'images': images, 'info': {'author': 'xcode', 'version': 1}}, indent=2) + '\n'
    )


def macos(tile):
    folder = 'macos/Runner/Assets.xcassets/AppIcon.appiconset'
    for old in (ROOT / folder).glob('*.png'):
        old.unlink()
    images = []
    for points in (16, 32, 128, 256, 512):
        for scale in (1, 2):
            px = points * scale
            name = f'icon-{px}.png'
            save(tile, f'{folder}/{name}', px)
            images.append({
                'filename': name, 'idiom': 'mac', 'scale': f'{scale}x',
                'size': f'{points}x{points}',
            })
    (ROOT / folder / 'Contents.json').write_text(
        json.dumps({'images': images, 'info': {'author': 'xcode', 'version': 1}}, indent=2) + '\n'
    )


def android(legacy, background, foreground):
    densities = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}
    for base in ('android/app/src/main/res', 'assets/icon/android'):
        for name, factor in densities.items():
            folder = f'{base}/mipmap-{name}'
            save(legacy, f'{folder}/ic_launcher.png', round(48 * factor))
            save(background, f'{folder}/ic_launcher_background.png', round(108 * factor))
            save(foreground, f'{folder}/ic_launcher_foreground.png', round(108 * factor))


def web(tile, maskable):
    save(tile, 'web/favicon.png', 64)
    save(tile, 'web/icons/favicon-16x16.png', 16)
    save(tile, 'web/icons/favicon-32x32.png', 32)
    save(tile, 'web/icons/Icon-192.png', 192)
    save(tile, 'web/icons/Icon-512.png', 512)
    save(maskable, 'web/icons/Icon-maskable-192.png', 192)
    save(maskable, 'web/icons/Icon-maskable-512.png', 512)


def windows(tile):
    path = ROOT / 'windows/runner/resources/app_icon.ico'
    sizes = [(s, s) for s in (16, 24, 32, 48, 64, 128, 256)]
    tile.resize((256, 256), Image.LANCZOS).save(path, sizes=sizes)


def main():
    master = full_bleed()
    background = _gradient(MASTER)
    foreground = _glyph(MASTER, 0.40)
    android(rounded_tile(inset=0.04, radius=0.22), background, foreground)
    ios(master)
    macos(rounded_tile(inset=0.098, radius=0.225, shadow=True))
    web(rounded_tile(inset=0.0, radius=0.22), full_bleed(glyph_scale=0.44))
    windows(rounded_tile(inset=0.02, radius=0.2))
    save(master, 'assets/icon/igitea_icon_1024.png', 1024)
    save(master, 'assets/icon/play_store_512.png', 512)
    print('icons written')


if __name__ == '__main__':
    os.chdir(ROOT)
    main()
