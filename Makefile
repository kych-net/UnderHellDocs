TYPST := typst
MAIN   := 地狱之下.typ
OUT    := dist/地狱之下.pdf
PRINT_OUT := dist/地狱之下_打印版.pdf
SCREEN_OUT := dist/地狱之下_小屏版.pdf
NOMEN_OUT := dist/地狱之下_$(NOMEN).pdf
PNG_OUT   := dist/图片/地狱之下-{0p}.png
SVG_OUT   := dist/图片/地狱之下-{0p}.svg
# --root .. 让项目根回到仓库根,以便访问 ../图片 等根目录资源
FLAGS  := --root .. --font-path fonts

.PHONY: all print screen nomen png svg images clean

all: $(OUT)

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

# 名词系统版:make nomen NOMEN=academic 以指定名词系统编译
# Nomenclature version: make nomen NOMEN=academic compiles with that system
nomen: $(MAIN)
	@mkdir -p dist
	$(TYPST) compile $(FLAGS) --input nomen=$(NOMEN) $(MAIN) $(NOMEN_OUT)

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