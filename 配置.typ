// 站点配置:集中模板再导出、网页模板与页面清单。
// 页面 #import "…/配置.typ": 网页模板 后即可用;正文文件自行
// #import "/模板/lib.typ": *(include 不继承作用域,必须自带)。
// / Site config: re-exports the template, defines the web template and page list.

#import "../模板/lib.typ": *

// 元素系统数据:全站唯一来源。Python 侧脚本(脚本/配置.py)从同一行读路径。
// / Element-system data: single source of truth; 脚本/配置.py reads the same line.
#let 元素系统文件 = "附件/元素系统.csv"

// 全量入口用的 #导入:模板版本以仓库根为基准(#include "/" + 路径),这里改成
// 相对本文件(文档/)解析,调用处直接写 "内容/怪动植物.typ",不必带 "文档/"。
// / 导入 for the full entry: the template version resolves against the repo root
// (--root); this one resolves against 文档/, so callers write "内容/怪动植物.typ".
#let 导入(路径, 偏移: 1) = {
  set heading(offset: 偏移)
  include 路径
}

// 站点导航链接:站内用绝对路径,外链(http)自动新窗口打开。
// / Site nav links: in-site links use absolute paths; http links open in a new tab.
#let 站内链接 = (
  (标签: "首页", 网址: "/", 提示: "完整文档"),
  (标签: "世界纲要", 网址: "/世界纲要/"),
  (标签: "怪动植物", 网址: "/怪动植物/"),
  (标签: "嗜血仙子", 网址: "/嗜血仙子/"),
  (标签: "主行星", 网址: "/主行星/"),
  (标签: "特殊能力", 网址: "/特殊能力/"),
  (标签: "附录", 网址: "/附录/"),
  (标签: "PDF", 网址: "https://github.com/kych-net/UnderHell/releases/latest", 提示: "下载 PDF(GitHub 最新发行版)"),
  (标签: "GitHub", 网址: "https://github.com/kych-net/UnderHell", 提示: "GitHub 仓库"),
  (标签: "GitCode", 网址: "https://gitcode.com/CrossDark/UnderHell", 提示: "GitCode 仓库"),
)

// 网页模板:各页用 脚本/页面.typ 统一入口(带 --input 页=<路径>)。
// / Web template: applied by the single entry 脚本/页面.typ with --input 页=<path>.
#let 网页模板 = 地狱之下模板.with(
  title: "地狱之下",
  subtitle: "一个崭新的世界",
  author: "跨越晨昏",
  lang: "zh",
  元素系统数据: csv(元素系统文件),
  页脚链接: 站内链接,
)

// 页面清单:(路径, 标题)。路径相对 内容/(不含 .typ),同时是 URL 段;
// 脚本/配置.py 与 Makefile 据此决定编译哪些页,总览页据此列子页。
// / Page list: (path, title). Path is relative to 内容/ (no .typ) and doubles
// as the URL segment; 脚本/配置.py & the Makefile derive pages from it.
#let 页面 = (
  ("世界纲要", "世界纲要"),
  ("怪动植物", "怪动植物"),
  ("嗜血仙子", "嗜血仙子"),
  ("主行星", "主行星"),
  ("特殊能力", "特殊能力"),
  ("特殊能力/仙术", "仙术"),
  ("特殊能力/魔法", "魔法"),
  ("附录", "附录"),
)