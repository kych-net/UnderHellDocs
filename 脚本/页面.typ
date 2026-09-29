// 网页各独立页的统一入口:make 传 --input 页=<路径>(相对 内容/,不含 .typ),
// 如 --input 页=特殊能力/仙术。页标题取自 配置.typ 的 页面 清单。
// / Single entry for every standalone page: `make` passes the page path
// (relative to 内容/, without .typ) via --input 页=…. Titles come from the
// 页面 list in 配置.typ.
#import "../配置.typ": 网页模板, 页面

#let 页 = sys.inputs.at("页", default: "")
// 清单里没登记的页(不该出现)回退用路径本身当标题
#let 标题 = 页面.to-dict().at(页, default: 页)

#show: 网页模板.with(页标题: 标题)

#include "../内容/" + 页 + ".typ"