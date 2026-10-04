#!/usr/bin/env python3
"""读取 文档/配置.typ 的站点配置,并扫描 内容/ 目录树,供 Python 侧脚本共用。

只解析字面量,不执行 Typst。公开:
  根            文档/ 的绝对路径
  元素系统路径   元素系统 CSV 的绝对路径
  扫页面()       扫描 内容/ 得到的页面清单 [(路径, 标题), …],路径相对 内容/ 且不含 .typ

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


元素系统路径 = 根 / _字面量("元素系统文件")


def 扫页面():
    """扫描 内容/**/*.typ 得到页面清单 [(路径, 标题), …],按路径排序。

    路径相对 内容/ 且不含 .typ,同时是 URL 段。规则:
      内容/<路径>.typ        → (路径, 文件名)
      内容/<目录>/index.typ  → (目录, 目录名)
    排除全量入口 内容/index.typ;空文件也算一页(不按大小过滤)。
    """
    基 = 根 / "内容"
    页 = []
    for f in sorted(基.rglob("*.typ")):
        rel = f.relative_to(基)
        if rel == pathlib.Path("index.typ"):
            continue
        if f.name == "index.typ":
            页.append((rel.parent.as_posix(), rel.parent.name))
        else:
            页.append((rel.with_suffix("").as_posix(), f.stem))
    return 页


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "页面":
        print(" ".join(p for p, _ in 扫页面()))
    else:
        print("用法:python3 脚本/配置.py 页面", file=sys.stderr)
        sys.exit(1)