TYPST := typst
MAIN   := 地狱之下.typ
OUT    := dist/地狱之下.pdf
PRINT_OUT := dist/地狱之下_打印版.pdf
SCREEN_OUT := dist/地狱之下_小屏版.pdf
元素系统输出 := dist/地狱之下_$(元素系统名).pdf
PNG_OUT   := dist/图片/地狱之下-{0p}.png
SVG_OUT   := dist/图片/地狱之下-{0p}.svg
# --root .. 让项目根回到仓库根,以便访问 ../图片 等根目录资源
# --input 纲要=false:make 编译时隐藏"世界纲要"页;直接 typst 编译不传则默认显示
FLAGS  := --root .. --font-path fonts --input 纲要=false

.PHONY: all print screen web 元素系统 png svg images clean

all: $(OUT) print screen

$(OUT): $(MAIN)
	@mkdir -p dist
	$(TYPST) compile $(FLAGS) $(MAIN) $(OUT)

# 打印版:通过 --input print=true 传入打印模式,生成省墨双栏 PDF
# Print version: passes --input print=true for ink-saving output
print: $(MAIN)
	@mkdir -p dist
	$(TYPST) compile $(FLAGS) --input print=true $(MAIN) $(PRINT_OUT)

# 小屏版:通过 --input screen=true 传入小屏模式,生成单栏窄边距 PDF
# Screen version: passes --input screen=true for single-column mobile/tablet reading
screen: $(MAIN)
	@mkdir -p dist
	$(TYPST) compile $(FLAGS) --input screen=true $(MAIN) $(SCREEN_OUT)

# 元素系统版:make 元素系统 元素系统名=academic 以指定元素系统编译
# Element-system version: make 元素系统 元素系统名=academic compiles with that system
元素系统: $(MAIN)
	@mkdir -p dist
	$(TYPST) compile $(FLAGS) --input 元素系统=$(元素系统名) $(MAIN) $(元素系统输出)

# 网页版:HTML 导出,单栏、样式仿标准 PDF(--features html 为实验特性)
# Web version: HTML export, single column, PDF-like styling
WEB_OUT := dist/地狱之下.html
web: $(MAIN)
	@mkdir -p dist
	$(TYPST) compile --features html $(FLAGS) --input web=true --format html $(MAIN) $(WEB_OUT)
	@python3 /tmp/web_post.py $(WEB_OUT) ../模板/web.css

# 编译为 PNG 图片,每页一图,输出到 dist/图片/
# Compile to PNG images, one file per page
# 分辨率可经 PPI 变量调整:make png PPI=192
png: $(MAIN)
	@mkdir -p dist/图片
	$(TYPST) compile $(FLAGS) --format png --ppi 144 $(MAIN) $(PNG_OUT)

# 编译为 SVG 矢量图,每页一图,输出到 dist/图片/
# Compile to SVG vector images, one file per page
svg: $(MAIN)
	@mkdir -p dist/图片
	$(TYPST) compile $(FLAGS) --format svg $(MAIN) $(SVG_OUT)

# 一次生成全部图片(PNG + SVG)
# Generate all image formats
images: png svg

clean:
	rm -rf dist