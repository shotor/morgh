"""Shared OKLCH palettes for Qubes label themes and their preview."""
from build import convert, contrast

LABELS = {
    'red': (12, .15), 'orange': (65, .14), 'yellow': (95, .13),
    'green': (145, .12), 'blue': (255, .13), 'purple': (305, .13),
    'gray': (260, .012), 'black': (270, .008),
}


def color(l, c, h):
    return convert([l, c, h])[0]


def palette(label, mode):
    hue, chroma = LABELS[label]
    neutral = label in ('gray', 'black')
    tint = .006 if neutral else .025
    if mode == 'dark' and label in ('red', 'orange'):
        tint = .04
    if mode == 'dark':
        bg = .16 if label == 'black' else .24
        values = dict(bg=(bg, tint), fg=(.95, tint / 2), surface=(bg + .045, tint),
                      muted=(.73, tint), accent=(.81, chroma * .65),
                      selection=(.38, tint * 1.6))
    else:
        values = dict(bg=(.98, tint / 3), fg=(.27, tint), surface=(.935, tint / 2),
                      muted=(.50, tint), accent=(.48, chroma), selection=(.87, tint * 1.5))
    p = {key: color(l, c, hue) for key, (l, c) in values.items()}
    if label == 'yellow' and mode == 'dark':
        p['bg'] = color(.29, .065, 90)
        p['surface'] = color(.33, .065, 90)
        p['selection'] = color(.39, .065, 90)
    # Label colors remain recognizable independently of the application's theme.
    level = {'yellow': .80, 'orange': .73, 'gray': .60, 'black': .24}.get(label, .62)
    p['border'] = color(level, chroma, hue)
    p['title'] = max(('#16131b', '#fffaff'), key=lambda c: contrast(c, p['border']))
    p['inactive'] = color(.38 if mode == 'dark' else .85, chroma * .3, hue)
    p['inactive_fg'] = max(('#16131b', '#fffaff'), key=lambda c: contrast(c, p['inactive']))
    p['urgent'] = color(.75, .14, 65)
    p['urgent_fg'] = '#16131b'
    for name, h in [('red', 25), ('green', 145), ('yellow', 95), ('blue', 255), ('magenta', 325), ('cyan', 190)]:
        p[name] = color(.78 if mode == 'dark' else .47, .085, h)
    for role, background in [('fg', 'bg'), ('muted', 'bg'), ('accent', 'bg'), ('title', 'border'), ('inactive_fg', 'inactive')]:
        assert contrast(p[role], p[background]) >= 4.5, (label, mode, role)
    return p

