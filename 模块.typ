#import "@preview/fletcher:0.5.8": *
#import "../模板/lib.typ": *

// ============================================================
// 不对称生殖 / 世代交替循环图
// Asymmetric Reproduction / Generation-alternation cycle diagram
// ============================================================

#let 不对称生殖流程图 = {
  set text(size: 9pt, font: "LXGW WenKai Mono")

  let g = rgb("#2d6a4f")   // 植物(绿色)
  let b = rgb("#1b4965")   // 动物/死亡(蓝)
  let p = rgb("#6b2fa0")   // 仙子/受精(紫)
  let bg = rgb("#d4edda")  // 浅绿底

  diagram(
    spacing: (30pt, 22pt),
    node-stroke: 1.5pt,
    node-fill: bg,
    edge-stroke: 1.2pt,
    node-inset: 8pt,

    // ---- 世代交替主环 (顺时针) ----
    node((0, 1), [*植物世代*\ 雄花♂/雌花♀], fill: rgb("#d4edda")),
    node((1, 0), [*#元素("动植物果实")*], fill: bg),
    node((0, -1), [*动物世代*\ 携带种子], fill: rgb("#d4edda")),
    node((-1, 0), [*不对称结婚*\ ♂×#元素("嗜血仙子")], fill: rgb("#e8daef")),

    // 主环连线
    edge((0, 1), (1, 0), "->", label: text(fill: g)[花粉受精]),
    edge((1, 0), (0, -1), "->", label: text(fill: g)[萌发出生]),
    edge((0, -1), (-1, 0), "->", label: text(fill: b)[成长成年]),
    edge((-1, 0), (1, 0), "->", label: text(fill: p)[受精产生果实]),

    // ---- 植物世代延续支路 ----
    edge((0, -1), (0, -2.2), "->", label: text(fill: b)[死亡]),
    node((0, -2.2), [*种子发育*\ 在#元素("地狱")中], fill: rgb("#e8f5e9")),
    edge((0, -2.2), (0, -3), "->", label: text(fill: g)[新植物世代]),
    node((0, -3), [*新植物世代*], fill: rgb("#d4edda")),
    edge((0, -3), (0, 1), "->", label: text(fill: g)[循环]),
  )
}
