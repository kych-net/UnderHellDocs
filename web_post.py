import pathlib, re, sys, csv, io

p = pathlib.Path(sys.argv[1])
s = p.read_text(encoding="utf-8")
css = pathlib.Path(sys.argv[2]).read_text(encoding="utf-8")

# 1) 注入 CSS
s = s.replace("/*UH_WEB_CSS*/", css)

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

# 注入交互脚本:目录按钮/评论触发点点击开合
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
