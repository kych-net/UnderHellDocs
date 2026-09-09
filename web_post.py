import pathlib, re, sys

p = pathlib.Path(sys.argv[1])
s = p.read_text(encoding="utf-8")
css = pathlib.Path(sys.argv[2]).read_text(encoding="utf-8")

# 1) 注入 CSS(占位符替换)
s = s.replace("/*UH_WEB_CSS*/", css)

# 2) 按标题层级给内容加 lv-N class(标题本身由 CSS h2..h6 缩进;内容块加 class)
body_at = s.find("<body")
head, body = s[:body_at], s[body_at:]

# 标题事件:h 开标签(可能被 span/div 包裹,取 h 自身)
events = [(m.start(), int(m.group(1))) for m in re.finditer(r'<h([1-6])[^>]*>', body)]
# 每个事件后缀的 class 加到"随后出现的非 h 开标签"
for idx in range(len(events)):
    start, lvl = events[idx]
    end = events[idx + 1][0] if idx + 1 < len(events) else len(body)
    seg = body[start:end]
    # 对段内每个非 h 开标签加 class lv-lvl(跳过该段首个 h 标签自身)
    def add_lv(m):
        tag = m.group(1)
        attrs = m.group(2)
        if re.match(r"h[1-6]$", tag):
            return m.group(0)
        cls = f"lv-{lvl}"
        if 'class="' in attrs:
            return f"<{tag}{attrs[:-1]} {cls}\"" + ">"
        if attrs:
            return f"<{tag}{attrs} class=\"{cls}\">"
        return f"<{tag} class=\"{cls}\">"
    seg2 = re.sub(r"<(p|span|div|table|ul|ol|blockquote|figure|img|header)([^>]*)>", add_lv, seg, count=0)
    body = body[:start] + seg2 + body[end:]

p.write_text(head + body, encoding="utf-8")

# 3) 复制 PDF 背景图到输出目录(网页背景与 PDF 一致)
import shutil
bg = pathlib.Path(sys.argv[2]).parent.parent / "img" / "background.jpg"
if bg.exists():
    shutil.copy(bg, p.parent / "background.jpg")

print("web: 注入样式", len(css), "字节; 层级缩进完成; 背景图已复制")
