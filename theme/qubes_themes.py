"""Render Qubes palettes through the existing application templates."""
import json
import re
from pathlib import Path
from qubes_palette import LABELS, palette


def render_qubes(directory, base_tokens):
    outputs = {}
    manifest = json.loads((directory / 'editor/vscode/package.json.in').read_text())
    manifest['contributes']['themes'] = [
        entry for entry in manifest['contributes']['themes']
        if entry['label'] not in ('shotormorgh-purple-light', 'shotormorgh-purple-dark')
    ]

    def render(path, tokens):
        return re.sub(r'\{\{([a-z0-9_.]+)\}\}', lambda m: tokens[m[1]],
                      (directory / path).read_text())

    for label in LABELS:
        name = f'shotormorgh-{label}'
        tokens = dict(base_tokens)
        for mode in ('light', 'dark'):
            p = palette(label, mode)
            p.update(header=p['border'], header_fg=p['title'])
            tokens.update({f'{mode}.{role}': value for role, value in p.items()})
            ansi = [p['bg'] if mode == 'dark' else p['fg']]
            ansi += [p[k] for k in ('red', 'green', 'yellow', 'blue', 'magenta', 'cyan')]
            ansi += [p['fg'] if mode == 'dark' else p['surface']]
            brights = [p['muted']] + ansi[1:7] + [p['fg'] if mode == 'dark' else p['bg']]
            for kind, colors in [('ansi', ansi), ('brights', brights)]:
                tokens.update({f'{mode}.{kind}.{i}': c for i, c in enumerate(colors)})

        # Keep one shared Vim implementation per palette, with light/dark wrappers.
        vim = render('editor/vim/colors/shotormorgh.vim.in', tokens)
        outputs[Path(f'editor/vim/colors/{name}.vim')] = vim.replace("'shotormorgh'", f"'{name}'")
        for mode in ('light', 'dark'):
            themed = f'{name}-{mode}'
            outputs[Path(f'editor/vim/colors/{themed}.vim')] = (
                f'set background={mode}\nruntime colors/{name}.vim\n'
                f"let g:colors_name = '{themed}'\n")
            for folder, suffix in [('terminal/urxvt', 'Xresources'),
                                   ('terminal/tmux', 'conf'),
                                   ('desktop/rofi', 'rasi'),
                                   ('editor/vscode/themes', 'json')]:
                source = f'{folder}/shotormorgh-{mode}.{suffix}.in'
                outputs[Path(f'{folder}/{themed}.{suffix}')] = render(source, tokens).replace(
                    f'shotormorgh-{mode}', themed)
            manifest['contributes']['themes'].append({
                'label': themed, 'uiTheme': 'vs' if mode == 'light' else 'vs-dark',
                'path': f'./themes/{themed}.json',
            })

    for mode in ('light', 'dark'):
        lines = []
        for label in LABELS:
            p = palette(label, mode)
            lines.extend([
                f"client.background {label} {p['bg']}",
                f"client.focused {label} {p['border']} {p['border']} {p['title']} {p['accent']}",
                f"client.focused_inactive {label} {p['border']} {p['inactive']} {p['inactive_fg']} {p['accent']}",
                f"client.unfocused {label} {p['border']} {p['inactive']} {p['inactive_fg']} {p['surface']}",
                f"client.urgent {label} {p['border']} {p['urgent']} {p['urgent_fg']} {p['accent']}",
                '',
            ])
        outputs[Path(f'desktop/i3/shotormorgh-{mode}.conf')] = '\n'.join(lines)
    outputs[Path('editor/vscode/package.json')] = json.dumps(manifest, indent=2) + '\n'
    return outputs
