#!/usr/bin/env python3
"""Convert every README.md in the workshop folder into a styled, self-contained README.html.

Usage (from anywhere):   python3 docs/make_html.py
"""
import base64, mimetypes, pathlib, re
import markdown

ROOT = pathlib.Path(__file__).resolve().parent.parent

CSS = """
:root{--bg:#fbfaf7;--fg:#1d2433;--muted:#5b6475;--accent:#1f6feb;--code:#f1efe9;--border:#dcd8cf;--th:#ebe7de;--card:#ffffff}
@media (prefers-color-scheme: dark){:root:not([data-theme="light"]){--bg:#14171c;--fg:#e4e7ec;--muted:#9aa3b2;--accent:#6ea8fe;--code:#1d2229;--border:#313843;--th:#232a34;--card:#191d23}}
:root[data-theme="dark"]{--bg:#14171c;--fg:#e4e7ec;--muted:#9aa3b2;--accent:#6ea8fe;--code:#1d2229;--border:#313843;--th:#232a34;--card:#191d23}
*{box-sizing:border-box}
html{background:var(--bg)}
body{background:var(--bg);color:var(--fg);font:16px/1.65 system-ui,-apple-system,"Segoe UI",Roboto,Ubuntu,sans-serif;max-width:940px;margin:0 auto;padding:28px 16px 80px}
nav.crumb{font-size:.9em;color:var(--muted);margin-bottom:8px}
h1{font-size:1.85em;line-height:1.25;margin:.2em 0 .8em;padding-bottom:.35em;border-bottom:3px solid var(--accent)}
h2{font-size:1.35em;margin:2em 0 .6em;padding-bottom:.25em;border-bottom:1px solid var(--border)}
h3{font-size:1.1em;margin:1.5em 0 .5em}
p,ul,ol{margin:.6em 0}
li{margin:.25em 0}
a{color:var(--accent);text-decoration:none}a:hover{text-decoration:underline}
code{font-family:ui-monospace,"DejaVu Sans Mono",Menlo,Consolas,monospace;font-size:.88em;background:var(--code);border:1px solid var(--border);border-radius:4px;padding:.08em .35em;white-space:nowrap}
pre{background:var(--code);border:1px solid var(--border);border-radius:8px;padding:12px 16px;overflow-x:auto;line-height:1.5;margin:.9em 0}
pre code{background:none;border:0;padding:0;white-space:pre;font-size:.9em}
.tablewrap{overflow-x:auto;margin:1em 0}
table{border-collapse:collapse;width:100%;background:var(--card);font-size:.95em}
th,td{border:1px solid var(--border);padding:7px 11px;text-align:left;vertical-align:top}
th{background:var(--th);font-weight:600}
td code{white-space:nowrap}
blockquote{margin:1em 0;padding:.6em 1em;border-left:4px solid #d29922;background:var(--code);border-radius:0 6px 6px 0}
blockquote p{margin:.2em 0}
img{display:block;max-width:100%;height:auto;margin:1em auto;border:1px solid var(--border);border-radius:6px;background:#fff}
hr{border:0;border-top:1px solid var(--border);margin:2em 0}
@media (max-width:600px){body{font-size:15px}h1{font-size:1.5em}}
"""

TEMPLATE = """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{title}</title>
<style>{css}</style>
</head>
<body>
{crumb}
{body}
</body>
</html>
"""


def embed_images(html: str, folder: pathlib.Path) -> str:
    def repl(m):
        src = m.group(1)
        if src.startswith(("http:", "https:", "data:")):
            return m.group(0)
        p = folder / src
        if not p.exists():
            return m.group(0)
        mime = mimetypes.guess_type(p.name)[0] or "image/png"
        data = base64.b64encode(p.read_bytes()).decode()
        return f'src="data:{mime};base64,{data}"'
    return re.sub(r'src="([^"]+)"', repl, html)


def convert(md_path: pathlib.Path):
    text = md_path.read_text(encoding="utf-8")
    title = None
    fm = re.match(r"^---\s*\n(.*?)\n---\s*\n", text, re.S)          # strip YAML front matter
    if fm:
        t = re.search(r'title:\s*"?(.*?)"?\s*$', fm.group(1), re.M)
        title = t.group(1) if t else None
        text = text[fm.end():]
    if not title:
        h = re.search(r"^# (.+)$", text, re.M)
        title = h.group(1) if h else md_path.parent.name
    text = text.replace(r"\*", "*")
    body = markdown.markdown(text, extensions=["tables", "fenced_code", "sane_lists"])
    body = body.replace("<table>", '<div class="tablewrap"><table>').replace("</table>", "</table></div>")
    body = re.sub(r'href="([^"#:]*?)README\.md"', r'href="\1README.html"', body)
    body = embed_images(body, md_path.parent)
    crumb = "" if md_path.parent == ROOT else '<nav class="crumb"><a href="../README.html">&larr; All examples</a></nav>'
    out = md_path.with_suffix(".html")
    out.write_text(TEMPLATE.format(title=title, css=CSS, crumb=crumb, body=body), encoding="utf-8")
    print("wrote", out.relative_to(ROOT))


if __name__ == "__main__":
    for md in sorted(ROOT.glob("README.md")) + sorted(ROOT.glob("*/README.md")):
        convert(md)
