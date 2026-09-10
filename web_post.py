import pathlib, re, sys, csv, tomllib

p = pathlib.Path(sys.argv[1])
s = p.read_text(encoding="utf-8")
css = pathlib.Path(sys.argv[2]).read_text(encoding="utf-8")

# 1) 注入 CSS
s = s.replace("/*UH_WEB_CSS*/", css)

# 1.5) 字体变量:从模板语言 toml 的 [fonts] 注入 CSS 字体列表
toml_path = pathlib.Path(sys.argv[3]) if len(sys.argv) > 3 else pathlib.Path(__file__).resolve().parent.parent / "模板" / "languages" / "zh.toml"
with open(toml_path, "rb") as fh:
    fonts_cfg = tomllib.load(fh).get("fonts", {})

def _css_font_list(v):
    return ",".join(("'" + x + "'" if str(x) != "serif" else str(x)) for x in v)

body_fonts    = fonts_cfg.get("body",    ["LXGW WenKai", "serif"])
comment_fonts = fonts_cfg.get("comment", ["zhaoji-shoujin", "serif"])
s = s.replace("/* 字体(由 web_post.py 从语言 toml 注入) KEY:UH_FONTS */",
 ":root{"
 "--uh-body-font:" + _css_font_list(body_fonts) + ";"
 "--uh-comment-font:" + _css_font_list(comment_fonts) + ";}")
s = s.replace("import pathlib, re, sys, csv, io, tomllib as _toml", "import pathlib, re, sys, csv, io, tomllib")

# 2) 修 bug:语言标点替换破坏了待办表里的文件路径(.typ → 。typ 等)
s = re.sub(r"。(\w{1,6})", r".\1", s)  # 。typ/。md/。html 等通用恢复(含 csv 位置)

# 3) 修 bug:待办表内容中的字面 "#元素[xxx]" → 深红元素 span(取 CSV 指针"默认"列名)
csv_path = pathlib.Path(__file__).resolve().parent.parent / "文档" / "元素系统.csv"
name_map = {}
if csv_path.exists():
    with csv_path.open(encoding="utf-8") as fh:
        for row in csv.reader(fh):
            if not row or row[0].strip() == "id" or not row[0].strip():
                continue
            eid = row[0].strip()
            name = (row[1].strip() if len(row) > 1 and row[1].strip() else eid)
            name_map[eid] = name

def _esc(x: str) -> str:
    return x.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")

def sub_element(m: re.Match) -> str:
    eid = m.group(1)
    return '<span class="uh-element">' + _esc(name_map.get(eid, eid)) + "</span>"

s = re.sub(r"#元素\[([^\[\]]+)\]", sub_element, s)

# 4) 注入交互脚本:目录按钮/评论触发点点击开合
JS = (
  "<script>"
  "(function(){"
  "document.addEventListener('click', function(e){"
  "var head = e.target.closest('.uh-toc-head');"
  "if (head) {"
  "var toc = head.closest('.uh-toc');"
  "toc.classList.toggle('uh-open');"
  "head.setAttribute('aria-expanded', toc.classList.contains('uh-open'));"
  "return;"
  "}"
  "var tr = e.target.closest('.uh-comment-trigger');"
  "if (tr) {"
  "var panel = tr.nextElementSibling;"
  "if (panel) panel.classList.toggle('uh-open');"
  "}"
  "});"
  "})();"
  "</script>"
)
s = s.rstrip("\n") + JS

p.write_text(s, encoding="utf-8")
print("web: CSS 注入;标点/路径与字面元素 bug 已修")
