#!/usr/bin/env python3
"""Build a standalone proposal; does not change deployed themes."""
from pathlib import Path
from build import contrast

ROOT = Path(__file__).resolve().parent
from qubes_palette import LABELS, palette


def card(label, mode):
    p = palette(label, mode)
    style = ';'.join(f'--{k.replace("_", "-")}:{v}' for k, v in p.items())
    chips = ''.join(f'<span><i style="background:{p[k]}"></i>{k}<small>{p[k]}</small></span>' for k in ('bg', 'surface', 'accent', 'border', 'inactive', 'selection'))
    return f'''<article class="card {mode}" style="{style}">
<div class="heading"><strong>{label.title()}</strong><span>{mode} · proposal</span></div>
<div class="window"><div class="title"><span>[{label}] terminal — focused</span><span>− □ ×</span></div>
<div class="terminal"><div><b class="green">user@work</b> <b class="accent">~/morgh</b> <span class="muted">main</span></div>
<div>❯ git status <span class="muted">--short</span></div><div class="green"> M theme/design-system/palette.json</div>
<div class="muted"># a quieter surface, a distinct Qubes identity</div><br>
<div><b class="magenta">def</b> <b class="blue">build_theme</b>(name):</div>
<div>    <b class="magenta">return</b> <span class="green">"shotormorgh-"</span> + name</div>
<div><span class="selection"> selected text </span> <span class="cursor">▏</span></div></div>
<div class="status"><b> 1: terminal </b><span>main · UTF-8</span></div></div>
<div class="title inactive"><span>[{label}] editor — inactive</span><span>− □ ×</span></div>
<div class="title urgent"><span>[{label}] request — urgent</span><span>!</span></div>
<div class="swatches">{chips}</div>
<p class="contrast">Text {contrast(p['fg'], p['bg']):.1f}:1 · muted {contrast(p['muted'], p['bg']):.1f}:1 · title {contrast(p['title'], p['border']):.1f}:1</p>
</article>'''


CSS = '''
*{box-sizing:border-box}body{margin:0;background:#141219;color:#eee9f3;font:15px/1.6 system-ui,sans-serif}
header,main,footer{max-width:1500px;margin:auto;padding:32px}header{padding-top:60px}h1{font-size:clamp(32px,5vw,56px);line-height:1.1;letter-spacing:-2px;margin:12px 0}p{color:#bdb4c9;max-width:800px}.eyebrow{color:#c4a9df;text-transform:uppercase;letter-spacing:3px;font-size:11px}
.controls{display:flex;gap:12px;flex-wrap:wrap;margin-top:24px}select{background:#28222f;border:1px solid #66566f;border-radius:6px;padding:8px;color:inherit;font:inherit}.group{margin:0 0 44px}.group h2{font-size:18px;font-weight:500;text-transform:capitalize}.grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:24px}
.card{background:var(--bg);color:var(--fg);border:1px solid var(--selection);border-radius:10px;padding:20px;overflow:hidden}.heading{display:flex;justify-content:space-between;margin-bottom:18px}.heading span{color:var(--muted);font-size:12px}.window{border:2px solid var(--border)}.title{background:var(--border);color:var(--title);padding:8px 12px;display:flex;justify-content:space-between;font-size:12px;font-weight:600}.terminal{font:13px/1.9 'DejaVu Sans Mono',monospace;padding:18px;overflow:auto;white-space:nowrap}.terminal div{white-space:pre}.status{background:var(--surface);display:flex;justify-content:space-between;padding:6px 12px;font:12px monospace}.status b{color:var(--accent)}.inactive{margin-top:12px;background:var(--inactive);color:var(--inactive-fg);border-left:2px solid var(--border)}.urgent{margin-top:8px;background:var(--urgent);color:var(--urgent-fg);border-left:4px solid var(--border)}
.green{color:var(--green)}.magenta{color:var(--magenta)}.blue{color:var(--blue)}.accent{color:var(--accent)}.muted{color:var(--muted)}.selection{background:var(--selection)}.cursor{background:var(--accent);color:var(--bg)}.swatches{display:grid;grid-template-columns:repeat(6,1fr);gap:8px;margin-top:22px}.swatches i{display:block;height:26px;border:1px solid #8885;border-radius:3px}.swatches span{font-size:10px}.swatches small{display:block;color:var(--muted);font:10px monospace}.contrast{font-size:11px;color:var(--muted);margin:16px 0 0}
body:has(#mode option[value=light]:checked) .dark,body:has(#mode option[value=dark]:checked) .light{display:none}body:not(:has(#mode option[value=both]:checked)) .grid{grid-template-columns:minmax(0,800px)}footer{color:#bdb4c9;font-size:12px}@media(max-width:900px){.grid{grid-template-columns:1fr}header,main,footer{padding:20px}.card{padding:12px}}
'''
for label in LABELS:
    CSS += f'body:has(#label option[value={label}]:checked) .group:not(.{label}){{display:none}}\n'
options = ''.join(f'<option value="{label}">{label.title()}</option>' for label in LABELS)
sections = ''.join(f'<section class="group {label}"><h2>{label}</h2><div class="grid">{card(label, "light")}{card(label, "dark")}</div></section>' for label in LABELS)
page = f'''<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Shotormorgh · Qubes color studies</title><style>{CSS}</style>
<header><div class="eyebrow">Shotormorgh / Qubes / color studies</div><h1>Eight identities.<br>A calmer desktop.</h1><p>Light and dark palettes for each Qubes label, with proposed i3 decoration colors. Label identity stays visible; application surfaces use a gentler tint. Gray is slate; black is charcoal.</p><div class="controls"><label>Label <select id="label"><option value="all">All eight</option>{options}</select></label><label>Appearance <select id="mode"><option value="both">Light + dark</option><option value="light">Light</option><option value="dark">Dark</option></select></label></div></header>
<main>{sections}</main><footer>Proposal only: no live i3 or application settings are changed. These are HTML mockups, not screenshots. Colors use OKLCH converted to sRGB by the existing theme builder. No JavaScript or external assets.</footer></html>'''
(ROOT / 'qubes-preview.html').write_text(page)
print('Generated theme/qubes-preview.html — 16 palettes; text contrast checks passed.')
