// 网页各独立页的统一入口:make 传 --input 页=<路径>(相对 内容/,不含 .typ),
// 如 --input 页=特殊能力/仙术。页标题取路径最后一段(URL 段即页名)。
// / Single entry for every standalone page: `make` passes the page path
// (relative to 内容/, without .typ) via --input 页=…. The title is the last
// path segment.
#import "../配置.typ": *

#let 页 = sys.inputs.at("页", default: "")
#let 标题 = if 页 == "" { 页 } else { 页.split("/").last() }
// 正文源文件(相对 文档/):make 传 --input 源=;缺省为 内容/<页>.typ,
// 目录页(如 特殊能力 → 内容/特殊能力/index.typ)由 make 显式传入
#let 源 = sys.inputs.at("源", default: "内容/" + 页 + ".typ")

#show: 网页模板.with(页标题: 标题)

#include "../" + 源