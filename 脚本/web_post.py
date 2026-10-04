import csv, pathlib, re, sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))   # 脚本/
from 配置 import 根, 元素系统路径, 扫页面                          # 文档/ 与站点配置

参数 = sys.argv[1] if len(sys.argv) > 1 else "dist"
dist = pathlib.Path(参数)
if not dist.is_absolute():
    dist = 根 / 参数

# ---------- 元素定义 → 所在页 URL ----------
# 扫全量入口与各独立页正文,建"元素名 → 页面 URL",供跨页元素重写。
# / Map element name → page URL by scanning the full entry and page sources.
页映射 = {}

def 登记(名, url):
    名 = 名.strip()
    if 名 and 名 not in 页映射:
        页映射[名] = url

def 扫(文本, url):
    # #设定元素(level: n)[名]
    for m in re.finditer(r"#设定元素\(\s*level\s*:\s*\d+\s*\)\[([^\]]+)\]", 文本):
        登记(m.group(1), url)
    # markup 标题的显式标签: = 标题 <label>
    for m in re.finditer(r"^=+ +.+?\s*<([^<>\s]+)>\s*$", 文本, re.M):
        登记(m.group(1), url)

扫((根 / "内容" / "index.typ").read_text(encoding="utf-8"), "/")
for 页, _标题 in 扫页面():
    # 页面正文:优先 内容/<页>.typ,没有则取目录页 内容/<页>/index.typ(如 特殊能力)
    正文 = 根 / "内容" / (页 + ".typ")
    if not 正文.exists():
        正文 = 根 / "内容" / 页 / "index.typ"
    if 正文.exists():
        扫(正文.read_text(encoding="utf-8"), "/" + 页 + "/")

# CSV:元素 id 与"默认"显示名不同的,把显示名一并登记(HTML 里显示的是默认名)
# / Also register CSV display names that differ from the element id.
名映射 = {}
if 元素系统路径.exists():
    with 元素系统路径.open(encoding="utf-8") as fh:
        for row in csv.reader(fh):
            if not row or not row[0].strip() or row[0].strip() == "id":
                continue
            eid = row[0].strip()
            默认 = row[1].strip() if len(row) > 1 and row[1].strip() else eid
            名映射[eid] = 默认
            if 默认 != eid and eid in 页映射:
                登记(默认, 页映射[eid])

htmls = sorted(dist.rglob("*.html"))
if not htmls:
    print("web_post: 未找到 HTML 产物")
    sys.exit(0)

# ---------- 内嵌网页样式 → 外部 /assets/underhell.css ----------
CSS块 = re.compile(r"<style>(/\*uh-raw\*/.*?)</style>", re.S)
CSS链接 = '<link rel="stylesheet" href="/assets/underhell.css">'

第一份 = None
for f in htmls:
    m = CSS块.search(f.read_text(encoding="utf-8"))
    if m:
        第一份 = m.group(1)
        break
if 第一份 is not None:
    (dist / "assets").mkdir(parents=True, exist_ok=True)
    (dist / "assets" / "underhell.css").write_text(第一份, encoding="utf-8")
elif not (dist / "assets" / "underhell.css").exists():
    print("web_post: 未找到内嵌网页样式,跳过 CSS 抽取")

def 页URL(文件):
    rel = 文件.relative_to(dist)
    if rel.parent == pathlib.Path("."):
        return "/"
    return "/" + rel.parent.as_posix() + "/"

def _esc(x):
    return x.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")

元素span = re.compile(r'<span class="uh-element" title="未定义">([^<]*)</span>')

# 交互脚本:目录按钮/评论触发点点击开合(幂等,靠标记 uhTocToggle 判定)
# / Interaction script: TOC & comment toggles (idempotent via the uhTocToggle marker)
JS = (
  "<script>"
  "(function(){var uhTocToggle=1;"
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

计数 = [0]
for f in htmls:
    s = f.read_text(encoding="utf-8")
    本页 = 页URL(f)

    # 1) 内嵌样式 → 外部样式表链接
    if CSS块.search(s):
        s = CSS块.sub(CSS链接, s, count=1)

    # 2) 修 bug:语言标点替换破坏了文本里的文件路径(怪动植物.typ → 怪动植物。typ)。
    #    只恢复 ASCII 段,避免把中文句子误并(如 "。所以")。
    # / Only restore ASCII runs, so CJK sentences are untouched.
    s = re.sub(r"。([A-Za-z0-9_./\\-]{1,8})", r".\1", s)

    # 3) 字面 "#元素[xxx]"(待办表等文本里)→ 深红元素 span,取 CSV"默认"列名
    s = re.sub(r"#元素\[([^\[\]]+)\]",
               lambda m: '<span class="uh-element">' + _esc(名映射.get(m.group(1), m.group(1))) + "</span>", s)

    # 4) 跨页元素:定义在别页的 span(HTML 里 title="未定义")改成指向该页的链接;
    #    真正无定义的(如仅在文本里提到)保持原样。
    # / Cross-page elements: spans undefined here become links to their defining page.
    def 重写(m):
        名 = m.group(1)
        目标 = 页映射.get(名)
        if 目标 and 目标 != 本页:
            计数[0] += 1
            return '<a href="' + 目标 + "#" + 名 + '"><span class="uh-element">' + 名 + "</span></a>"
        return m.group(0)
    s = 元素span.sub(重写, s)

    # 5) 交互脚本
    if "uhTocToggle" not in s:
        s = s.rstrip("\n") + JS

    f.write_text(s, encoding="utf-8")

print("web: " + str(len(htmls)) + " 页;CSS 抽取;标点/路径与字面元素 bug 已修;跨页元素链接 " + str(计数[0]) + " 个")