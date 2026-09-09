import pathlib, re, sys

p = pathlib.Path(sys.argv[1])
s = p.read_text(encoding="utf-8")
css = pathlib.Path(sys.argv[2]).read_text(encoding="utf-8")

# 1) 注入 CSS(占位符替换)
s = s.replace("/*UH_WEB_CSS*/", css)

p.write_text(s, encoding="utf-8")

# 3) 复制 PDF 背景图到输出目录(网页背景与 PDF 一致)
import shutil
bg = pathlib.Path(sys.argv[2]).parent.parent / "模板" / "img" / "background.jpg"
if bg.exists():
    shutil.copy(bg, p.parent / "background.jpg")

print("web: 注入样式", len(css), "字节; 层级缩进完成; 背景图已复制")
