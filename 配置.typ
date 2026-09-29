// 站点配置:集中模板再导出、网页模板与页面清单。
// 页面 #import "…/配置.typ": 网页模板 后即可用;正文文件自行
// #import "/模板/lib.typ": *(include 不继承作用域,必须自带)。
// / Site config: re-exports the template, defines the web template and page list.

#import "../模板/lib.typ": *

// 站点导航链接:站内用绝对路径,外链(http)自动新窗口打开。
// / Site nav links: in-site links use absolute paths; http links open in a new tab.
#let 站内链接 = (
  (标签: "首页", 网址: "/", 提示: "完整文档"),
  (标签: "世界纲要", 网址: "/01-世界纲要/"),
  (标签: "怪动植物", 网址: "/02-怪动植物/"),
  (标签: "嗜血仙子", 网址: "/03-嗜血仙子/"),
  (标签: "主行星", 网址: "/04-主行星/"),
  (标签: "特殊能力", 网址: "/05-特殊能力/"),
  (标签: "附录", 网址: "/06-附录/"),
  (标签: "PDF", 网址: "https://github.com/kych-net/UnderHell/releases/latest", 提示: "下载 PDF(GitHub 最新发行版)"),
  (标签: "GitHub", 网址: "https://github.com/kych-net/UnderHell", 提示: "GitHub 仓库"),
  (标签: "GitCode", 网址: "https://gitcode.com/CrossDark/UnderHell", 提示: "GitCode 仓库"),
)

// 网页模板:各页用 #show: 网页模板.with(页标题: "…")。
// / Web template: applied via #show: 网页模板.with(页标题: "…") on each page.
#let 网页模板 = 地狱之下模板.with(
  title: "地狱之下",
  subtitle: "一个崭新的世界",
  author: "跨越晨昏",
  lang: "zh",
  元素系统数据: csv("元素系统.csv"),
  页脚链接: 站内链接,
)

// 页面清单:(目录名, 标题)。目录名同时是 URL 段(编号前缀只用于排序与定序);
// 总览页据此列子页,新增页面只需加一行。
// / Page list: (dir, title). The dir doubles as the URL segment.
#let 页面 = (
  ("01-世界纲要", "世界纲要"),
  ("02-怪动植物", "怪动植物"),
  ("03-嗜血仙子", "嗜血仙子"),
  ("04-主行星", "主行星"),
  ("05-特殊能力", "特殊能力"),
  ("05-特殊能力/01-仙术", "仙术"),
  ("05-特殊能力/03-魔法", "魔法"),
  ("06-附录", "附录"),
)