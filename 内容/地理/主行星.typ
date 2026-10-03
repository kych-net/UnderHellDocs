#import "../../配置.typ": *
#import "@preview/cetz:0.4.0": canvas
#import "@preview/cetz-plot:0.1.2": plot, chart


#元素[主行星]的半径约 $1.5 times 10^4 "km"$,重力加速度约为 $20 "m/s"^2$.#评论[增加逃离地狱的难度]

#设定元素(level: 1)[主火山]

= 大气

== 成分

$"N"_2$ 约 78.1%,$"O"_2$ 约 20.95%,其余为氩、二氧化碳等,摩尔质量约 $0.029 "kg/mol"$.

// 大气成分(体积比)与饼图配色
#let 大气成分 = (
  (名: [$"N"_2$], 占比: 78.1, 色: rgb("#4C78A8")),
  (名: [$"O"_2$], 占比: 20.95, 色: rgb("#F58518")),
  (名: [其它], 占比: 0.95, 色: rgb("#BAB0AC")),
)

// 大气成分饼图(cetz-plot 内置)
#align(center)[
  #canvas({
    chart.piechart(
      大气成分,
      value-key: "占比",
      label-key: "名",
      slice-style: 大气成分.map(项 => 项.色),
      radius: 1.2,
      gap: 0deg,
      outer-label: (content: none),
    )
  })
]

== 性质

海平面气压约 $1.013 times 10^5 "Pa"$.取 $gamma = 1.4$,声速 $a = sqrt(gamma R T slash M)$:

#表格("其它大气参数", columns: 2,
  table.header([*参数*], [*数值*]),
  [海平面声速], [赤道 $347 "m/s"$,极点 $310 "m/s"$],
  [对流层顶声速], [$295 "m/s"$],
  [对流层顶气压], [赤道 $3.08 "kPa"$,极点 $33.8 "kPa"$],
  [气压标高], [海平面 $4.30 "km"$,对流层顶 $3.11 "km"$],
  [大气总质量], [$1.43 times 10^19 "kg"$],
)

对流层递减率约 $6.5 "K/km"$,低于干绝热递减率 $19.9 "K/km"$,大气层结稳定;对流层顶温度约 $216.65 "K"$,赤道海平面约 $300 "K"$,极点海平面约 $240 "K"$,故赤道对流层顶高约 $12.8 "km"$,极点约 $3.6 "km"$.

温度与密度随高度分层,$h$ 以米计:

*赤道*

$ T(h) = cases(
  300 - 6.5 times 10^(-3) h & quad quad h <= 1.282 times 10^4,
  216.65 & quad quad h > 1.282 times 10^4,
) $
$ rho(h) = cases(
  1.18 (T(h) slash 300)^(9.733) & quad quad h <= 1.282 times 10^4,
  0.0497 exp(-(h - 1.282 times 10^4) slash 3.11 times 10^3) & quad quad h > 1.282 times 10^4,
) $

*极点*

$ T(h) = cases(
  240 - 6.5 times 10^(-3) h & quad quad h <= 3.592 times 10^3,
  216.65 & quad quad h > 3.592 times 10^3,
) $
$ rho(h) = cases(
  1.47 (T(h) slash 240)^(9.733) & quad quad h <= 3.592 times 10^3,
  0.543 exp(-(h - 3.592 times 10^3) slash 3.11 times 10^3) & quad quad h > 3.592 times 10^3,
) $

其中对流层递减率 $6.5 times 10^(-3) "K/m"$,密度指数 $9.733 = g M slash (R L) - 1$,平流层标高 $3.11 times 10^3 "m" = R T_t slash (g M)$,$g = 20 "m/s"^2$,$M = 0.029 "kg/mol"$,$R = 8.314 "J/(mol K)"$,$T_t = 216.65 "K"$.

#表格("赤道大气温度与密度", columns: 3,
  table.header([*高度 m*], [*温度 K*], [*密度 $"kg/m"^3$*]),
  [0], [300.0], [1.18],
  [1000], [293.5], [0.953],
  [2000], [287.0], [0.767],
  [5000], [267.5], [0.387],
  [8500], [244.8], [0.163],
  [10000], [235.0], [0.110],
  [12000], [222.0], [0.0630],
  [15000], [216.7], [0.0247],
  [20000], [216.7], [0.00494],
  [25000], [216.7], [0.000990],
  [30000], [216.7], [0.000198],
)

#表格("极点大气温度与密度", columns: 3,
  table.header([*高度 m*], [*温度 K*], [*密度 $"kg/m"^3$*]),
  [0], [240.0], [1.47],
  [1000], [233.5], [1.13],
  [2000], [227.0], [0.855],
  [5000], [216.7], [0.345],
  [8500], [216.7], [0.112],
  [10000], [216.7], [0.0692],
  [12000], [216.7], [0.0364],
  [15000], [216.7], [0.0139],
  [20000], [216.7], [0.00278],
  [25000], [216.7], [0.000556],
  [30000], [216.7], [0.000111],
)

// 大气解析式:温度 K / 密度 $"kg/m"^3$ 随高度 h(m) 变化
// / Analytic profiles; 温/密 为海平面值,顶为对流层顶高度
#let 赤道色 = rgb("#C62828")
#let 极点色 = rgb("#1565C0")
#let 赤道大气 = (温: 300, 密: 1.18, 顶: 1.2823e4)
#let 极点大气 = (温: 240, 密: 1.47, 顶: 3.5923e3)

#let 大气温度(h, a) = if h <= a.顶 { a.温 - 6.5e-3 * h } else { 216.65 }

#let 大气密度(h, a) = {
  let 顶密度 = a.密 * calc.pow(216.65 / a.温, 9.733)
  if h <= a.顶 {
    a.密 * calc.pow(大气温度(h, a) / a.温, 9.733)
  } else {
    顶密度 * calc.exp(-(h - a.顶) / 3.11e3)
  }
}

// 曲线说明:替代图内图例,与曲线同色
#let 曲线图例 = text(size: .85em)[
  #text(fill: 赤道色)[━ 赤道]　#text(fill: 极点色)[━ 极点]
  #h(1em)#text(fill: rgb("#B0B0B0"))[┄ 对流层顶]
]

// 剖面图:按解析式绘制;超出栏宽时等比缩放
// / Profile plot drawn from the analytic profiles; scaled down to fit the column
#let 剖面图(取值, 轴参数) = layout(尺寸 => {
  let 图 = canvas({
    plot.plot(
      size: (7.5, 4.6),
      axis-style: "scientific",
      ..轴参数,
      y-min: 0, y-max: 30, y-tick-step: 5, y-label: [高度 (km)], y-grid: true,
      {
        plot.add(h => (取值(h * 1000, 赤道大气), h), domain: (0, 30), samples: 200,
          mark: none, style: (stroke: 赤道色 + 1.6pt))
        plot.add(h => (取值(h * 1000, 极点大气), h), domain: (0, 30), samples: 200,
          mark: none, style: (stroke: 极点色 + 1.6pt))
        let 对流层顶 = (paint: rgb("#B0B0B0"), thickness: .7pt, dash: "dashed")
        plot.add-hline(12.82, axes: ("x", "y"), style: (stroke: 对流层顶))
        plot.add-hline(3.59, axes: ("x", "y"), style: (stroke: 对流层顶))
      }
    )
  })
  let 限宽 = 尺寸.width
  let 实宽 = measure(图).width
  if 实宽 > 限宽 { scale(图, 限宽 / 实宽 * 100%) } else { 图 }
})

#block(breakable: false)[
  #align(center)[*#text(size: 1.3em)[温度剖面]*]
  #align(center)[#曲线图例]
  #剖面图(大气温度, (
    x-min: 200, x-max: 310, x-tick-step: 20,
    x-label: [温度 (K)],
  ))
]

#v(1em)

#block(breakable: false)[
  #align(center)[*#text(size: 1.3em)[密度剖面]*]
  #align(center)[#曲线图例]
  #剖面图(大气密度, (
    x-min: 0, x-max: 1.6, x-tick-step: 0.5,
    x-label: [密度 ($"kg/m"^3$)],
  ))
]
