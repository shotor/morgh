#!/usr/bin/env python3

import argparse
import json
import math
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent
BUILD = ROOT / '.build'


def linear_rgb(value):
    lightness, chroma, hue = value
    a = chroma * math.cos(math.radians(hue))
    b = chroma * math.sin(math.radians(hue))

    l = (lightness + 0.3963377774 * a + 0.2158037573 * b) ** 3
    m = (lightness - 0.1055613458 * a - 0.0638541728 * b) ** 3
    s = (lightness - 0.0894841775 * a - 1.2914855480 * b) ** 3

    return (
        4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s,
    )


def in_gamut(rgb):
    return all(-1e-7 <= channel <= 1 + 1e-7 for channel in rgb)


def convert(value):
    lightness, chroma, hue = value
    rgb = linear_rgb(value)
    mapped = not in_gamut(rgb)

    if mapped:
        low, high = 0, chroma

        for _ in range(40):
            middle = (low + high) / 2

            if in_gamut(linear_rgb((lightness, middle, hue))):
                low = middle
            else:
                high = middle

        chroma = low
        rgb = linear_rgb((lightness, chroma, hue))

    channels = []

    for channel in rgb:
        channel = min(1, max(0, channel))
        encoded = (
            12.92 * channel
            if channel <= 0.0031308
            else 1.055 * channel ** (1 / 2.4) - 0.055
        )
        channels.append(f'{math.floor(encoded * 255 + 0.5):02x}')

    return '#' + ''.join(channels), mapped, chroma


def luminance(color):
    rgb = [int(color[i:i + 2], 16) / 255 for i in (1, 3, 5)]
    linear = [
        value / 12.92 if value <= 0.04045 else ((value + 0.055) / 1.055) ** 2.4
        for value in rgb
    ]

    return sum(value * weight for value, weight in zip(linear, (0.2126, 0.7152, 0.0722)))


def contrast(first, second):
    low, high = sorted((luminance(first), luminance(second)))
    return (high + 0.05) / (low + 0.05)


def valid_color(name, value):
    return (
        re.fullmatch(r'[a-z][a-z0-9_]*', name)
        and isinstance(value, list)
        and len(value) == 3
        and all(type(v) in (int, float) and math.isfinite(v) for v in value)
        and 0 <= value[0] <= 1
        and 0 <= value[1] <= 1
        and 0 <= value[2] < 360
    )


def palette_tokens(source):
    if not isinstance(source, dict) or source.get('space') != 'oklch' or source.get('version') != 1:
        raise ValueError('Unsupported palette format')

    modes = source.get('modes')

    if not isinstance(modes, dict):
        raise ValueError('Missing palettes')

    tokens = {}

    for mode in ('light', 'dark', 'purple_light', 'purple_dark'):
        palette = modes.get(mode)

        if not isinstance(palette, dict) or not isinstance(palette.get('colors'), dict):
            raise ValueError(f'Missing {mode} palette')

        colors = {}
        rows = []
        mapped_count = 0

        for name, value in palette['colors'].items():
            if not valid_color(name, value):
                raise ValueError(f'Invalid OKLCH color: {mode}.{name}')

            color, mapped, chroma = convert(value)
            colors[name] = color
            tokens[f'{mode}.{name}'] = color

            oklch = f'oklch({value[0] * 100:.3f}% {value[1]:.5f} {value[2]:.2f})'
            gamut = f'Chroma → {chroma:.5f}' if mapped else 'In sRGB'
            rows.append(
                '          <tr>\n'
                f'            <td>{name}</td>\n'
                f'            <td>{oklch}</td>\n'
                f'            <td>{color}</td>\n'
                f'            <td>{gamut}</td>\n'
                '          </tr>'
            )

            if mapped:
                mapped_count += 1
                print(f'{mode}.{name}: chroma {value[1]} → {chroma:.6f} to fit sRGB')

        for kind in ('ansi', 'brights'):
            names = palette.get(kind)

            if (
                not isinstance(names, list)
                or len(names) != 8
                or any(not isinstance(name, str) or name not in colors for name in names)
            ):
                raise ValueError(f'{mode}.{kind} must reference eight named colors')

            for index, name in enumerate(names):
                tokens[f'{mode}.{kind}.{index}'] = colors[name]

        roles = ('fg', 'muted', 'accent', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan')
        required = ('bg', 'header', 'header_fg', 'selection', 'surface', 'add', 'del', 'change')

        for role in required + roles:
            if role not in colors:
                raise ValueError(f'Missing color {mode}.{role}')

        for role in roles:
            ratio = contrast(colors[role], colors['bg'])

            if ratio < 4.5:
                print(f'Contrast warning: {mode}.{role} on bg = {ratio:.2f}:1', file=sys.stderr)

        minimum = min(contrast(colors[name], colors['bg']) for name in palette['ansi'][1:7])
        tokens[f'{mode}.contrast_fg'] = f"{contrast(colors['fg'], colors['bg']):.1f}"
        tokens[f'{mode}.contrast_muted'] = f"{contrast(colors['muted'], colors['bg']):.1f}"
        tokens[f'{mode}.contrast_ansi'] = f'{minimum:.1f}'
        tokens[f'{mode}.color_details'] = '\n'.join((
            '<details class="color-details">',
            f'  <summary>OKLCH source → sRGB ({mapped_count} gamut-mapped)</summary>',
            '  <div class="table-scroll">',
            '    <table>',
            '      <thead>',
            '        <tr><th>Role</th><th>Source</th><th>Output</th><th>Gamut</th></tr>',
            '      </thead>',
            '      <tbody>',
            '\n'.join(rows),
            '      </tbody>',
            '    </table>',
            '  </div>',
            '</details>',
        ))

    return tokens


def render(tokens):
    directory = ROOT / '.templates'
    outputs = {}

    for path in sorted(directory.rglob('*.in')):
        def replace(match):
            key = match[1]

            if key not in tokens:
                raise ValueError(f'Unknown token {key} in {path.relative_to(directory)}')

            return tokens[key]

        contents = re.sub(r'\{\{([a-z0-9_.]+)\}\}', replace, path.read_text(encoding='utf-8'))

        if '{{' in contents:
            raise ValueError(f'Unresolved template syntax in {path.relative_to(directory)}')

        outputs[path.relative_to(directory).with_suffix('')] = contents

    if not outputs:
        raise ValueError('No templates found')

    for path in (
        Path('terminal/starship/starship.toml'),
        Path('terminal/wezterm/preview.lua'),
    ):
        outputs[path] = (ROOT / path).read_text(encoding='utf-8')

    return outputs


def main():
    parser = argparse.ArgumentParser(description='Generate Shotor themes from the OKLCH palette.')
    parser.add_argument('--check', action='store_true', help='Check generated files without writing them')
    args = parser.parse_args()

    source = json.loads((ROOT / 'design-system/palette.json').read_text(encoding='utf-8'))
    outputs = render(palette_tokens(source))
    stale = False

    for path, contents in outputs.items():
        target = BUILD / path

        try:
            current = target.read_text(encoding='utf-8')
        except FileNotFoundError:
            current = None

        if current == contents:
            continue

        if args.check:
            print(f'Needs regeneration: {path}', file=sys.stderr)
            stale = True
        else:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(contents, encoding='utf-8')
            print(f'Generated {path}')

    if stale:
        return 1

    print('Generated themes are current.' if args.check else 'Themes generated from OKLCH.')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError) as error:
        print(f'Error: {error}', file=sys.stderr)
        sys.exit(1)
