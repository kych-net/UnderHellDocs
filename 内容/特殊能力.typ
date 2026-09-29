// 内容/特殊能力.typ —— 特殊能力总览页
// 仅作网页独立页;不在全量文档中(全量里"特殊系统"一节已内联)。
// / Special-ability overview page: standalone page only; the full doc inlines its own section.
#import "/模板/lib.typ": *
#import "../配置.typ": 页面

= 特殊能力

#元素[特殊能力者]使用的#元素[特殊能力],按来源分为:

#for (路径, 名) in 页面.filter(p => p.at(0).starts-with("特殊能力/")) [
  - #link("/" + 路径 + "/")[#名]
]