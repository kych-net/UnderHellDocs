#import "@preview/fletcher:0.5.8": *
#import "../模板/lib.typ": *

// ============================================================
// 世代交替与不对称生殖循环图
// Generation-alternation & Asymmetric Reproduction Cycle
// ============================================================

#let 不对称生殖流程图 = {
  set text(size: 8pt, font: "LXGW WenKai Mono")

  let g = rgb("#2d6a4f")   // 植物世代(绿)
  let b = rgb("#1b4965")   // 动物世代/死亡(蓝)
  let p = rgb("#6b2fa0")   // 嗜血仙子/受精(紫)
  let fg = rgb("#b23b2b")  // 果实(红)
  let m  = rgb("#8a6d1a")  // 记忆传承(褐)
  let bg = rgb("#f0f5ee")  // 底

  diagram(
    spacing: (26pt, 16pt),
    node-stroke: 1.2pt,
    node-fill: bg,
    edge-stroke: 1.0pt,
    node-inset: 5pt,

    // ===== 上排: 世代交替主链 =====
    node((0, 0), [*植物世代*#linebreak() 雄花♂/雌花♀], fill: rgb("#d4edda")),
    edge((0, 0), (1, 0), "->", label: text(fill: g)[♂♀花粉受精]),
    node((1, 0), [*花粉受精*], fill: bg),
    edge((1, 0), (2, 0), "->", label: text(fill: fg)[产生果实]),
    node((2, 0), [*#元素[动植物果实]*#linebreak() 预装记忆], fill: rgb("#fde2e4")),
    edge((2, 0), (3, 0), "->", label: text(fill: g)[萌发出生]),
    node((3, 0), [*动物世代*#linebreak() 携带种子], fill: rgb("#dce6f0")),
    edge((3, 0), (4, 0), "->", label: text(fill: b)[成长]),
    node((4, 0), [*成长成年*], fill: bg),

    // ===== 世代交替闭环(动物死亡→种子→新植物世代) =====
    edge((3, 0), (3, -1), "->", label: text(fill: b)[动物死亡]),
    node((3, -1), [*种子发育*#linebreak() 在#元素[地狱]等区域], fill: rgb("#e8f5e9")),
    edge((3, -1), (2, -1), "->", label: text(fill: g)[不是转生]),
    node((2, -1), [*新植物世代*], fill: rgb("#d4edda")),
    edge((2, -1), (0, 0), "->", label: text(fill: g)[世代交替循环]),

    // ===== 不对称生殖分支(成年→结婚→受精→果实) =====
    edge((4, 0), (4, -1), "->", label: text(fill: p)[唯一成年途径]),
    node((4, -1), [*#元素[不对称结婚]*#linebreak() ♂×#元素[嗜血仙子]], fill: rgb("#e8daef")),
    edge((4, -1), (5, -1), "->", label: text(fill: p)[卵细胞+极体]),
    node((5, -1), [*#元素[嗜血仙子]*#linebreak() 三倍体], fill: rgb("#e8daef")),
    edge((4, -1), (5, -2), "->", label: text(fill: b)[精子(单倍体)]),
    node((5, -2), [*精子*#linebreak() 雄性#元素[怪动植物]], fill: rgb("#dce6f0")),
    edge((5, -2), (5, -3), "->", label: text(fill: p)[单倍体]),
    node((5, -3), [*配子形成*#linebreak() 卵巢内降解怪物染色体], fill: rgb("#e8daef")),
    edge((5, -1), (6, -1), "->", label: text(fill: p)[卵+极体+精子]),
    node((6, -1), [*受精卵*#linebreak() 三倍体], fill: rgb("#fde2e4")),
    edge((6, -1), (6, 0), "->", label: text(fill: fg)[受精成功]),
    node((6, 0), [*产生果实*], fill: rgb("#fde2e4")),
    edge((6, 0), (2, 0), "->", label: text(fill: fg)[并入动植物果实]),

    // ===== 记忆传承分支(果实→抽象→综合→预装新个体) =====
    edge((2, 0), (7, 0), "->", label: text(fill: m)[记忆进入]),
    node((7, 0), [*记忆抽象*#linebreak() 经#元素[地狱的真菌]接入网络], fill: rgb("#fff3cd")),
    edge((7, 0), (7, 1), "->", label: text(fill: m)[抽象化+综合]),
    node((7, 1), [*保留关键记忆*], fill: rgb("#fff3cd")),
    edge((7, 1), (7, 2), "->", label: text(fill: m)[预装]),
    node((7, 2), [*新生个体*#linebreak() 继承记忆], fill: rgb("#fff3cd")),
    edge((7, 2), (0, 0), "->", label: text(fill: m)[出生→幼体]),
  )
}
