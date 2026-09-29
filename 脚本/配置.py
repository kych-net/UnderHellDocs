#!/usr/bin/env python3
"""读取 文档/配置.typ 里的站点配置,供 Python 侧脚本共用。

只解析字面量,不执行 Typst。公开:
  根            文档/ 的绝对路径
  元素系统路径   元素系统 CSV 的绝对路径
  读页面()       页面清单 [(路径, 标题), …],路径相对 内容/ 且不含 .typ

命令行:python3 脚本/配置.py 页面   → 空格分隔的页面路径(供 Makefile $(shell …))
"""
import pathlib, re, sys

根 = pathlib.Path(__file__).resolve().parent.parent          # 文档/
文本 = (根 / "配置.typ").read_text(encoding="utf-8")


def _字面量(名):
    """取 配置.typ 里 `#let <名> = "…"` 的字符串值。"""
    m = re.search(r'#let\s+' + re.escape(名) + r'\s*=\s*"([^"]+)"', 文本)
    if not m:
        raise SystemExit("配置.py: 配置.typ 里未找到 " + 名)
    return m.group(1)


def _括号块(名):
    """取 `#let <名> = ( … )` 的括号内文本(按括号配对,不解析字符串)。"""
    i = 文本.find("#let " + 名)
    if i < 0:
        raise SystemExit("配置.py: 配置.typ 里未找到 " + 名)
    i = 文本.find("(", i)
    depth = 0
    for j in range(i, len(文本)):
        if 文本[j] == "(":
            depth += 1
        elif 文本[j] == ")":
            depth -= 1
            if depth == 0:
                return 文本[i + 1:j]
    raise SystemExit("配置.py: " + 名 + " 括号不配对")


元素系统路径 = 根 / _字面量("元素系统文件")


def 读页面():
    """页面清单 [(路径, 标题), …];路径相对 内容/ 且不含 .typ。"""
    return re.findall(r'\(\s*"([^"]+)"\s*,\s*"([^"]+)"\s*\)', _括号块("页面"))


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "页面":
        print(" ".join(p for p, _ in 读页面()))
    else:
        print("用法:python3 脚本/配置.py 页面", file=sys.stderr)
        sys.exit(1)