// 内容/地理/index.typ —— 地理目录页(URL /地理/)
// 仅作网页独立页;全量文档(内容/index.typ)里相关小节已内联。
// / Geography index page (URL /地理/): standalone page only.
#import "../../配置.typ": *

= 地理

#for (路径, 名) in 页面.filter(p => p.at(0).starts-with("地理/")) [
  - #link("/" + 路径 + "/")[#名]
]