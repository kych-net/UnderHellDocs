---
name: "underhell-docs"
description: "地狱之下(UnderHell)正文文档(文档/ 子模块)的写作与编译规范。涵盖 Typst 编译命令(make all/print/screen/元素系统、--root ..)、内容章节结构、元素系统(附件/元素系统.csv)、模板函数调用、交叉引用标签、白描直陈的中文语法规范与常见编译坑。在编写或修改 文档/ 下的 .typ、附件/元素系统.csv 或编译正文时调用。"
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
| `内容/index.typ` | 全量单页入口(初始化 `网页模板`,引入各章节;PDF 与网页 `/`),其 `#目录` 前有一份**仅网页**的站内导航(分页入口) |
| `配置.typ` | 站点配置(模板再导出、`网页模板`、`站内链接`、`导航` 卡片清单);`站内链接` = 右上角导航栏,只留首页与站外链接;`导航` 只管卡片顺序/名称,**不定义 URL** |
| `内容/<路径>.typ` | 该页正文,**自带 `#import "…/配置.typ": *`**(模板成员经它再导出);路径即 URL 段(如 `内容/生物/怪动植物.typ`) |
| `内容/<路径>/index.typ` | 目录页正文(如 `内容/特殊能力/index.typ` → `/特殊能力/`),同样自带 `#import` |
| `脚本/` | `页面.typ`(独立页统一入口)、`web_post.sh`(网页后处理)、`test.sh` |
| `附件/元素系统.csv` | 元素系统宽表(首行=系统名,首列=元素 id) |
| `Makefile` | 编译脚本 |

`内容/` 下的正文文件不再被 `内容/index.typ` 逐个 `#include`,而是:
全量入口用 `#导入` 引入(见 `#导入("内容/生物/怪动植物.typ", 偏移: 2)`),
独立页走统一入口 `脚本/页面.typ`(`make` 传 `--input 页=<路径> --input 源=<相对 文档/ 的正文路径>`,
目录页 `内容/<路径>/index.typ` 就靠 `源=` 指定)。两者都靠正文自带的 `#import`。

网页专属内容(如首页 `#目录` 前的站内导航段)用 `#if is_web() [ … ]` 包裹:PDF 编译时整段跳过,
站内链接不会出现在纸面上。`is_web()` 由模板导出(`lib.typ` 顶部,读 `--input web=true`)。

## 编译

在 `文档/` 目录下:

```bash
make all        # 普通版(默认)
make print      # 省墨双栏
make screen     # A5 单栏(手机/平板)
make 元素系统 元素系统名=academic
make web        # HTML 版:完整单页 + 各独立页(experimental)
make png / svg  # 逐页图片
make clean
```

直接 typst(关键:`--root ..` 使相对路径回到仓库根,`--font-path fonts`):

```bash
typst compile --root .. --font-path fonts 内容/index.typ out.pdf
```

注意:`make` 的 FLAGS 含 `--input 纲要=false`(历史遗留,纲要已移出全量文档,只作独立页);
逐页导出图片可用 `--pages N`。

## 元素系统

- 核心概念用 `#元素[正式名]` 引用;普通系统直接读 ID 值本身。
- 正文中直接写 `#元素(...)`,**不要在正文用 `[ ]` 包裹**(会渲染字面方括号);
  仅在函数参数位置(如 `#表格(...)`、`name:`)用 `[...]` 包成 content。
- 章节标题用 `#设定元素(level: n)[名]`(标题+锚点),`@名` 可交叉引用。
- 只要文档用了 `#元素("xxx")`,就必须把 `xxx` 写入 `附件/元素系统.csv` 的 id 列。
- 交叉引用标签用中文名或名词元素(ID),`@标签` 需与 `<标签>` 一致;无对应元素的小节
  直接用中文名(`<教育>`、`@教育`)。

## 模板函数(调用中文名)

`表格`、`提示框`、`属性框`、`人物框`、`法术`、`附录`、`顶部图`、`底部图`、`品牌`、
`评论`、`元素`、`设定元素`、`设置元素系统`。参数细节见模板技能。

## 语法规范

参考 `内容/附录.typ` 的"排版规范"。**字数能省就省,不要说废话。**

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
2. `#include` 相对路径以被 include 文件所在位置解析(非调用处);且**不继承父文件作用域**,
   故每个 `内容/<路径>.typ` 必须自带 `#import "…/配置.typ": *`。正文只引 `配置.typ`,
   不直接引 `模板/lib.typ`——模板成员由 `配置.typ` 再导出,站点配置也走同一出口。
3. `配置.typ` 里包装的 `#导入(路径, 偏移)` 以**本文件所在目录**(`文档/`)为基准,如
   `#导入("内容/生物/怪动植物.typ", 偏移: 2)`;独立页由 `脚本/页面.typ` 按 `--input 页` 动态 include。
4. 页面标题层级:`内容/<路径>.typ` 的 markup 标题是页面内的绝对层级;全量入口靠 `#导入` 的 `偏移`
   降级,独立页直接用,故正文的 `#设定元素(level:)` 无需改动。
5. 子模块处于 detached HEAD 时,推送前先 `git checkout main && git merge --ff-only <commit>`。
6. 编码一律用 Unicode。