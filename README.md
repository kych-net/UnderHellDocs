# 地狱之下 - 文档

完整PDF在[发行版](https://gitcode.com/CrossDark/UnderHellDocs/releases/)

[地狱之下](https://gitcode.com/CrossDark/UnderHell) 项目的 Typst 文档源码,使用架空世界模板渲染。

## 文件

| 文件 | 说明 |
|------|------|
| `地狱之下.typ` | 正文主文件 |
| `地狱之下附录.typ` | 附录(由正文 `#include` 引入) |
| `名词系统.csv` | 名词系统数据(宽表:首行=系统名,首列=元素 id) |
| `Makefile` | 编译脚本(普通/打印/小屏/名词系统版) |

## 编译

```bash
# 普通版
make all

# 打印版 / 小屏版
make print
make screen

# 指定名词系统
make nomen NOMEN=academic
```

## 名词系统

名词系统通过 `#元素("ID")` 在文档中引用核心概念。**普通系统直接返回 ID 本身**,其他系统(别名、academic)从 `名词系统.csv` 宽表中查找。

CSV 格式:首行为各名词系统名(不含普通),首列是元素 id,单元格为对应名词(空则回退到普通)。

```csv
id,别名,academic
怪物,,
怪动物,白色怪物,
怪动植物,黑白怪物,
超级系统,,生物能量超级系统
嗜血仙子,黑白仙女,
水仙子,水仙女,
```

**只要文档中使用了 `#元素("xxx")`,就必须将 `xxx` 写入 CSV id 列。** 元素文本在渲染时自动标红(深红)并使用标题字体。

## 字体

通过 `lang: "zh"` 加载中文配置(`模板/languages/zh.toml`)。字体配置:

- `header`:段宁毛笔小楷(标题 + 元素默认)
- `body`:霞鹜文楷等宽(正文)
- `italic`:等距更纱黑体 SC(斜体)
