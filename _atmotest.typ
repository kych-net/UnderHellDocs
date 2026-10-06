#import "附件/模块.typ": *
#set page(width: 90mm, height: auto, margin: 4mm)
#set text(size: 9pt)

#let 表高 = (0, 1, 2, 3, 5, 8.5, 10, 12, 15, 17, 20, 24, 30)
#let 有效(x) = {
  if x >= 1 { str(calc.round(x, digits: 2)) }
  else if x >= 0.1 { str(calc.round(x, digits: 3)) }
  else { str(calc.round(x, digits: 4)) }
}
#let 大气表(区, 顶, 位数) = 表高.map(hkm => {
  let h = hkm * 1000
  let 比 = 组分比(区, 顶, h)
  (
    [#hkm],
    [#calc.round(大气温度(区, 顶, h), digits: 1)],
    [#if 位数 == 3 { str(calc.round(大气密度(区, 顶, h), digits: 3)) } else { 有效(大气密度(区, 顶, h)) }],
    [#calc.round(大气声速(区, 顶, h))],
    [#calc.round(比.at(0) * 100, digits: 1)],
    [#calc.round(比.at(2) * 100, digits: 1)],
    [#calc.round(比.at(1) * 100, digits: 1)],
  )
}).flatten()

#let 表头 = table.header([*高度 km*], [*温度 K*], [*密度 $"kg/m"^3$*], [*声速 $"m/s"$*], [*He %*], [*Xe %*], [$"O"_2$ %])

= V1 等分7列 密度3位
#表格("赤道大气", columns: 7, 表头, ..大气表(赤道参数, 赤道顶, 3))

= V2 显式列宽 密度3位
#表格("赤道大气", columns: (0.7fr, 1fr, 1.35fr, 0.85fr, 0.8fr, 0.8fr, 0.8fr), 表头, ..大气表(赤道参数, 赤道顶, 3))

= V3 显式列宽 密度4位
#表格("赤道大气", columns: (0.7fr, 1fr, 1.35fr, 0.85fr, 0.8fr, 0.8fr, 0.8fr), 表头, ..大气表(赤道参数, 赤道顶, 4))

= V4 等分7列 8pt 密度4位
#text(size: 8pt)[#表格("赤道大气", columns: 7, 表头, ..大气表(赤道参数, 赤道顶, 4))]