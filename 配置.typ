// 站点配置:集中模板再导出、网页模板与页面清单。
// 其余 .typ 一律 #import "…/配置.typ": *(不再直接引模板/lib.typ),模板成员与站点配置
// 走同一个出口;include 不继承作用域,每个正文文件必须自带这一行。
// / Site config: re-exports the template, defines the web template and page list.
// Every other .typ imports from here instead of 模板/lib.typ directly.

// #import "@preview/underhell:0.4.1"

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

// 导航栏链接(渲染为右上角 uh-site):站内只留"首页",其余分页入口在首页的导航段;
// 外链(http)自动新窗口打开。
// / Top-nav links: in-site keeps only 首页 (other pages are listed on the home page);
// http links open in a new tab.
#let 站内链接 = (
  (标签: "首页", 网址: "/", 提示: "完整文档"),
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
// 脚本/配置.py 与 Makefile 据此决定编译哪些页。源文件取 内容/<路径>.typ,
// 没有则取目录页 内容/<路径>/index.typ(如 特殊能力)。
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