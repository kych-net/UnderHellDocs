#import "../../配置.typ": *
#import "../../附件/模块.typ": *


#元素[怪动植物]的监狱,#元素[嗜血仙子]的乐园,#元素[天堂]的试验场

#元素[主行星]的半径约 $1.5 times 10^4 "km"$,重力加速度约为 $20 "m/s"^2$.#评论[增加逃离地狱的难度]

#设定元素(level: 1)[主火山]

= 大气

== 成分

$"He"$ 约 20%,$"O"_2$ 约 20%,$"Xe"$ 约 59.95%,$"N"_2$ 约 500 ppm,平均摩尔质量约 $0.086 "kg/mol"$.

#align(center)[#大气成分饼图]

== 性质

海平面气压约 $1.013 times 10^5 "Pa"$.大气按分子量分层:重气体 $"Xe"$、$"O"_2$ 沉降,$"He"$ 浮于高层.组分随高度显著变化:约 $15 "km"$ 以上 $"He"$ 占比超 99%,$"Xe"$ 在对流层顶以上迅速消失.

对流层递减率取干绝热值 $Gamma = g slash c_p$,随成分变:$"Xe"$ 重,$c_p$ 低,海平面约 $76 "K/km"$;$"He"$ 富集使 $c_p$ 升高,近对流层顶降到约 $4 "K/km"$.对流层顶温度约 $216.65 "K"$,赤道海平面约 $300 "K"$,极点约 $240 "K"$,故赤道对流层顶高约 $1.5 "km"$,极点约 $0.33 "km"$.

对流层顶以上先等温 $216.65 "K"$:赤道约 $1.5$ 至 $17.2 "km"$,极点约 $0.3$ 至 $8.0 "km"$.再往上臭氧加热占优,温度回升,赤道升率约 $2.35 "K/km"$,极点约 $1.11 "K/km"$,至平流层顶达 $232.65 "K"$:赤道约 $24 "km"$,极点约 $22.4 "km"$.平流层顶以上进入中间层,温度以 $2.5 "K/km"$ 回落.

温度、密度、声速与组分随高度分层:

// 下表与四张图均由 附件/模块.typ 的解析模型生成(分层扩散平衡 + Γ=g/c_p)
#let 表高 = (0, 1, 2, 3, 5, 8.5, 10, 12, 15, 17, 20, 24, 30)
// 三位有效数字
#let 有效(x) = {
  if x >= 1 { str(calc.round(x, digits: 2)) }
  else if x >= 0.1 { str(calc.round(x, digits: 3)) }
  else { str(calc.round(x, digits: 4)) }
}
#let 大气表(区, 顶) = 表高.map(hkm => {
  let h = hkm * 1000
  let 比 = 组分比(区, 顶, h)
  (
    [#hkm],
    [#calc.round(大气温度(区, 顶, h), digits: 1)],
    [#有效(大气密度(区, 顶, h))],
    [#calc.round(大气声速(区, 顶, h))],
    [#calc.round(比.at(0) * 100, digits: 1)],
    [#calc.round(比.at(2) * 100, digits: 1)],
    [#calc.round(比.at(1) * 100, digits: 1)],
  )
}).flatten()

#pagebreak() // 分页符,避免表格跨页

#set page(columns: 1) // 单栏,否则写不下

#表格("赤道大气", columns: 7,
  table.header([*高度 km*], [*温度 K*], [*密度 $"kg/m"^3$*], [*声速 $"m/s"$*], [*He %*], [*Xe %*], [$"O"_2$ %]),
  ..大气表(赤道参数, 赤道顶),
)

#表格("极点大气", columns: 7,
  table.header([*高度 km*], [*温度 K*], [*密度 $"kg/m"^3$*], [*声速 $"m/s"$*], [*He %*], [*Xe %*], [$"O"_2$ %]),
  ..大气表(极点参数, 极点顶),
)

#set page(columns: 2) // 恢复2栏

// 绘图数据、配色与函数见 附件/模块.typ

#block(breakable: false)[
  #align(center)[*#text(size: 1.3em)[温度剖面]*]
  #align(center)[#曲线图例]
  #剖面图(大气温度, (
    x-min: 190, x-max: 310, x-tick-step: 20,
    x-label: [温度 (K)],
  ))
]

#block(breakable: false)[
  #align(center)[*#text(size: 1.3em)[密度剖面]*]
  #align(center)[#曲线图例]
  #剖面图(大气密度, (
    x-min: 0, x-max: 5, x-tick-step: 1,
    x-label: [密度 ($"kg/m"^3$)],
  ))
]

#block(breakable: false)[
  #align(center)[*#text(size: 1.3em)[声速剖面]*]
  #align(center)[#曲线图例]
  #剖面图(大气声速, (
    x-min: 150, x-max: 950, x-tick-step: 200,
    x-label: [声速 ($"m/s"$)],
  ))
]

#block(breakable: false)[
  #align(center)[*#text(size: 1.3em)[组分剖面]*]
  #align(center)[#组分图例]
  #组分剖面图
]