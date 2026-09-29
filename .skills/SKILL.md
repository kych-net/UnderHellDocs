---
name: "underhell-docs"
description: "地狱之下(UnderHell)正文文档(文档/ 子模块)的写作与编译规范。涵盖 Typst 编译命令(make all/print/screen/元素系统、--root ..)、内容章节结构、元素系统(元素系统.csv)、模板函数调用、交叉引用标签、白描直陈的中文语法规范与常见编译坑。在编写或修改 文档/ 下的 .typ、元素系统.csv 或编译正文时调用。"
---

# UnderHell 正文文档写作规范

本技能面向 `文档/`(UnderHellDocs 子模块)。模板函数实现见
`模板/.skills/underhell-template`;元素系统的深度说明另见仓库内技能
`文档/.opencode/skills/元素系统/SKILL.md`。

## 硬性约束

**`文档/` 的改动必须经用户明确同意**,不能自行修改。`素材/` 可随意改。

## 文件结构

| 路径 | 说明 |
|------|------|
| `地狱之下.typ` | 正文主文件(初始化 `地狱之下模板`,引入各章节) |
| `地狱之下附录.typ` | 语法规范参考;附录由正文 `#附录[...]` 引入 |
| `内容/世界纲要.typ` | 世界纲要 |
| `内容/主行星.typ` | 主行星 |
| `内容/嗜血仙子.typ` | 嗜血仙子 |
| `内容/怪动植物.typ` | 怪动植物 |
| `内容/特殊能力/仙术.typ`、`灵力.typ`、`魔法.typ` | 特殊能力三篇 |
| `内容/附录.typ` | 附录内容 |
| `元素系统.csv` | 元素系统宽表(首行=系统名,首列=元素 id) |
| `Makefile` | 编译脚本 |
| `web_post.py` | 网页版后处理(注入 CSS/脚本) |

## 编译

在 `文档/` 目录下:

```bash
make all        # 普通版(默认)
make print      # 省墨双栏
make screen     # A5 单栏(手机/平板)
make 元素系统 元素系统名=academic
make web        # HTML 版(实验特性)
make png / svg  # 逐页图片
make clean
```

直接 typst(关键:`--root ..` 使相对路径回到仓库根,`--font-path fonts`):

```bash
typst compile --root .. --font-path fonts 地狱之下.typ out.pdf
```

注意:`make` 的 FLAGS 含 `--input 纲要=false`,**默认隐藏"世界纲要"页**;直接 typst 编译
不传则显示。逐页导出图片可用 `--pages N`。

## 元素系统

- 核心概念用 `#元素[正式名]` 引用;普通系统直接读 ID 值本身。
- 正文中直接写 `#元素(...)`,**不要在正文用 `[ ]` 包裹**(会渲染字面方括号);
  仅在函数参数位置(如 `#表格(...)`、`name:`)用 `[...]` 包成 content。
- 章节标题用 `#设定元素(level: n)[名]`(标题+锚点),`@名` 可交叉引用。
- 只要文档用了 `#元素("xxx")`,就必须把 `xxx` 写入 `元素系统.csv` 的 id 列。
- 交叉引用标签用中文名或名词元素(ID),`@标签` 需与 `<标签>` 一致;无对应元素的小节
  直接用中文名(`<教育>`、`@教育`)。

## 模板函数(调用中文名)

`表格`、`提示框`、`属性框`、`人物框`、`法术`、`附录`、`顶部图`、`底部图`、`品牌`、
`评论`、`元素`、`设定元素`、`设置元素系统`。参数细节见模板技能。

## 语法规范

参考 `文档/地狱之下附录.typ`。**字数能省就省,不要说废话。**

中文:以直陈、白描为基本写法。少用状语、补语和副词,只保留有实际信息的修饰。
优先保留原本自然的语言习惯,不为深刻、优美、完整而润色。保持自然的长短句变化,
拒绝套用总分总结构,不强行总结或升华。

反例:「这个方法值得继续研究」不要写成「这个方法还有值得深入挖掘的空间」。

English: Use direct statements and plain prose. Minimize adverbials, complements,
and adverbs; use them only when they add concrete information. Preserve the
writer's natural voice. Do not polish simple language to sound deeper, more
elegant, or more complete. Keep natural variation in sentence length. Avoid rigid
summary structures and forced conclusions.

## 已知坑(文档)

1. 正文顶层不能出现裸 `#p`——`#` 后必须是已定义符号,否则编译失败。
2. `#include` 相对路径以被 include 文件所在位置解析(非调用处)。
3. 子模块处于 detached HEAD 时,推送前先 `git checkout main && git merge --ff-only <commit>`。
4. 编码一律用 Unicode。