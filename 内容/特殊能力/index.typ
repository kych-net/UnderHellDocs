// 内容/特殊能力/index.typ —— 特殊能力目录页(URL /特殊能力/)
// 仅作网页独立页;全量文档(内容/index.typ)里"特殊系统"一节已内联。
// / Special-ability index page (URL /特殊能力/): standalone page only.
#import "/模板/lib.typ": *
#import "../../配置.typ": 页面

= 特殊能力

#元素[特殊能力者]使用的#元素[特殊能力],按来源分为:

#for (路径, 名) in 页面.filter(p => p.at(0).starts-with("特殊能力/")) [
  - #link("/" + 路径 + "/")[#名]
]