TYPST := typst
MAIN   := 内容/index.typ
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
# 与 template/Makefile 的 web 目标一致:扫 内容/ 全部 .typ,入口 → dist/index.html,
# 其余页经统一入口 脚本/页面.typ → dist/<路径>/index.html;再拷 内容/ 下的静态 .html,
# 收尾跑 脚本/web_post.sh。页面集合按目录树自动扫出,新增页不必改 Makefile。
# Web version: HTML export; mirrors template/Makefile's web target (scans 内容/).
web:
	@set -e; for f in $$(find 内容 -name '*.typ' | sort); do \
	  rel="$${f#内容/}"; \
	  case "$$rel" in \
	    index.typ)   out="dist/index.html"; src="$$f"; args="";; \
	    */index.typ) p="$${rel%/index.typ}"; out="dist/$$p/index.html"; \
	                 src="脚本/页面.typ"; args="--input 页=$$p --input 源=$$f";; \
	    *)           p="$${rel%.typ}"; out="dist/$$p/index.html"; \
	                 src="脚本/页面.typ"; args="--input 页=$$p --input 源=$$f";; \
	  esac; \
	  mkdir -p "$$(dirname "$$out")"; \
	  echo "HTML $$f -> $$out"; \
	  $(TYPST) compile --features html $(FLAGS) --input web=true $$args --format html "$$src" "$$out"; \
	done
	@set -e; for f in $$(find 内容 -name '*.html' | sort); do \
	  out="dist/$${f#内容/}"; \
	  mkdir -p "$$(dirname "$$out")"; \
	  echo "COPY $$f -> $$out"; \
	  cp "$$f" "$$out"; \
	done
	@sh 脚本/web_post.sh dist
	@mkdir -p dist/webfonts
	@cp ../模板/webfonts/*.woff2 dist/webfonts/

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