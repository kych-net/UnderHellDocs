---
name: 元素系统
description: Use when writing or editing the 地狱之下 world-building documents (文档/地狱之下.typ, 地狱之下附录.typ) and their 元素系统 (element system). Explains the 元素 function, the CSV format (元素系统.csv), how to reference core concepts, cross-reference labels/IDs, and how to add a new concept or element system.
---

# 元素系统 (Element System)

The 地狱之下 documents use a **element system**: one core concept (e.g. the
black-white monster 黑白怪物) is identified by an **元素** (element), and
different 元素系统 (element systems) render different names for the same
element at compile time.

## Core idea

- **元素 (element) = 普通系统名词本身**。The element's ID is its plain/common
  name. E.g. `怪动植物` is the element for the black-white monster.
- **普通系统直接读取 ID 的值**。The "普通" (common) system needs no CSV rows:
  `#元素("怪动植物")` under 普通 simply returns `怪动植物`.
- **其他系统在 CSV 中为同一元素提供不同名词**。Other systems (e.g. `别名`,
  `academic`) map an element to an alternative term in `元素系统.csv`.
- **缺失自动回退**。If the current system lacks an element, it falls back to
  the common name (the ID itself).

## Files

| Path | Purpose |
| ---- | ------- |
| `文档/元素系统.csv` | The single wide-format CSV: header = systems, first col = element ids, cells = terms. |
| `文档/地狱之下.typ` | Main world document (compiled with `--root ..`). |
| `文档/地狱之下附录.typ` | Appendix, included by the main document. |
| `模板/lib.typ` | Template; defines `#元素()`, `#设置元素系统()`, `#set-元素系统数据()`. |

## CSV format

Wide-format CSV: the **header row lists the system names**, the **first column
holds element ids**, and each **cell is that element's term under that system**
(empty if the element has no name there).

```csv
id,别名,academic
怪物,,
怪动物,白色怪物,
怪植物,黑色怪物,
怪动植物,黑白怪物,
超级系统,,生物能量超级系统
嗜血仙子,黑白仙女,
水仙子,水仙女,
蝶仙子,蝶仙女,
花仙子,花仙女,
```

- `id`: the element (must equal the common-system name).
- Each other column is a element system (`别名`, `academic`, or any custom
  name). The `普通` system is **not a column** — it reads the ID directly.
- A cell is empty when that system has no term for the element.
- An element may appear on its own row with all system cells empty (e.g.
  `怪物`), meaning it only has its common name.

## Using elements in text

Call `#元素("名称")` directly in markup. Do NOT wrap it in `[ ]` in body text —
literal brackets would render.

```typst
#元素("怪动植物")        // 普通: 怪动植物; 别名: 黑白怪物
#元素("地狱")           // 别名系统下仍为"地狱"(无别名,回退到 ID)
```

In function-argument positions (table/box titles, `name:`), wrap in `[ ]` to
make a content block:

```typst
#提示框([#元素("天堂卫星")的能力], [...])
#表格([#元素("热量循环系统")], [...])
#属性框((name: [#元素("怪动植物")], ...))
```

## Switching systems

- Compile-time: `typst compile --input 元素系统=academic 地狱之下.typ out.pdf`
  (or `make 元素系统 元素系统名=academic` in 文档/). Default is `普通`.
- In-document: `#设置元素系统("别名")` switches for the rest of the document.

## Cross references

Cross-reference labels and references use the element name (or a plain label)
as the ID — not random strings:

```typst
= 怪动植物 <怪动植物>      // heading + label
详见 @怪动植物            // reference
```

If a section has no corresponding element (e.g. 教育, 羽翼), use the plain
Chinese label directly (`<教育>`, `@教育`).

## Adding a new concept

1. Use `#元素("概念名")` in the document.
2. Add a row to `元素系统.csv` with the element as `id`, filling only the
   system columns that have an alternative name (leave the rest empty).
3. Under 普通 it automatically renders the concept name itself.

## 怪物 vs 怪物系统

- `怪物` 和 `怪物系统` 是**两个不同的元素**,不要混用:
  `怪物` 指个体/泛指(`#元素("怪物")`),`怪物系统` 指系统本身
  (`#元素("怪物系统")`)。
- `怪物` **不要别名**,不入 CSV;普通系统直接读 ID 返回"怪物"。
- 怪物三大类为 `怪动物`/`怪植物`/`怪动植物`,其别名为
  `白色怪物`/`黑色怪物`/`黑白怪物`。

## 元素化范围

- **仅核心概念用 `#元素(...)`**:地名、生物类别、专有系统名等。
- **描述性文本保持普通文本**:如"怪物侧"、"仙子侧"、"怪物爪钩"、
  "怪物分类"等部位/修饰词不用 `#元素()`。
- 别名为"侧/爪钩/分类"等的概念不要元素化。

## Gotchas

1. **Do not put `[#元素(...)]` in body text** — literal `[ ]` will render.
   Body text uses bare `#元素(...)`.
2. **普通系统不是 CSV 列** — it reads the ID value directly.
3. **ID must equal the common name** so fallback works (`if t == none { id }`).
4. **Editor is CSv-literal**: keep quotes/commas exact; a stray comma shifts
   the columns.
