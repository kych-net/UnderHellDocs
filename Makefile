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
# 独立页:统一入口 脚本/页面.typ,页名取自 配置.typ 的 页面 清单(脚本/配置.py 读取)
# Standalone pages: one entry (脚本/页面.typ); the page list lives in 配置.typ
PAGES := $(shell python3 脚本/配置.py 页面 2>/dev/null)
WEB_PAGES := $(patsubst %,dist/%/index.html,$(PAGES))
内容全部typ := $(shell find 内容 -name '*.typ' 2>/dev/null)

web: $(MAIN) $(WEB_PAGES) 配置.typ 脚本/页面.typ ../模板/lib.typ ../模板/web.css ../模板/webfonts/段宁毛笔小楷.ttf ../模板/languages/zh.toml
	@mkdir -p dist
	$(TYPST) compile --features html $(FLAGS) --input web=true --format html $(MAIN) $(WEB_OUT)
	@cp $(WEB_OUT) dist/index.html
	@python3 脚本/web_post.py dist
	@mkdir -p dist/webfonts
	@cp ../模板/webfonts/duan-kaixiao-full.woff2 ../模板/webfonts/zhaoji-shoujin.woff2 ../模板/webfonts/lxgw-wenkai-mono.woff2 ../模板/webfonts/zhenkai-gb.woff2 dist/webfonts/

# 独立页路由:% 可跨斜杠匹配,天然支持多级(特殊能力/仙术);页名经 --input 页= 传给统一入口
# / Standalone page route: % matches across slashes (特殊能力/仙术); the stem is
# passed to the single entry as --input 页=<path>
dist/%/index.html: 脚本/页面.typ 内容/%.typ $(内容全部typ) 配置.typ 附件/元素系统.csv ../模板/lib.typ ../模板/web.css
	@mkdir -p $(dir $@)
	$(TYPST) compile --features html $(FLAGS) --input web=true --input 页=$* --format html $< $@

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