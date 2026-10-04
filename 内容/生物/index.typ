// 内容/生物/index.typ —— 生物目录页(URL /生物/)
// 仅作网页独立页;全量文档(内容/index.typ)里相关小节已内联。
// / Biology index page (URL /生物/): standalone page only.
#import "../../配置.typ": *

= 生物

#for (路径, 名) in 导航.filter(p => p.at(0).starts-with("生物/")) [
  - #link("/" + 路径 + "/")[#名]
]