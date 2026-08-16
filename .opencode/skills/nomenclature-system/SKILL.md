---
name: nomenclature-system
description: Use when writing or editing the 地狱之下 world-building documents (文档/地狱之下.typ, 地狱之下附录.typ) and their 名词系统 (nomenclature system). Explains the 元素 function, the CSV format (名词系统.csv), how to reference core concepts, cross-reference labels/IDs, and how to add a new concept or nomenclature system.
---

# 名词系统 (Nomenclature System)

The 地狱之下 documents use a **nomenclature system**: one core concept (e.g. the
black-white monster 黑白怪物) is identified by an **元素** (element), and
different 名词系统 (nomenclature systems) render different names for the same
element at compile time.

## Core idea

- **元素 (element) = 普通系统名词本身**。The element's ID is its plain/common
  name. E.g. `怪动植物` is the element for the black-white monster.
- **普通系统直接读取 ID 的值**。The "普通" (common) system needs no CSV rows:
  `#元素("怪动植物")` under 普通 simply returns `怪动植物`.
- **其他系统在 CSV 中为同一元素提供不同名词**。Other systems (e.g. `别名`,
  `academic`) map an element to an alternative term in `名词系统.csv`.
- **缺失自动回退**。If the current system lacks an element, it falls back to
  the common name (the ID itself).

## Files

| Path | Purpose |
| ---- | ------- |
| `文档/名词系统.csv` | The single CSV holding all systems. Columns: `id, system, term`. |
| `文档/地狱之下.typ` | Main world document (compiled with `--root ..`). |
| `文档/地狱之下附录.typ` | Appendix, included by the main document. |
| `模板/lib.typ` | Template; defines `#元素()`, `#set-nomen()`, `#set-nomen-data()`. |

## CSV format

```csv
id,system,term
怪动植物,别名,黑白怪物
超级系统,academic,生物能量超级系统
```

- `id`: the element (must equal the common-system name).
- `system`: the nomenclature system name (`别名`, `academic`, or any custom name).
- `term`: the rendered name under that system.
- **Do NOT add rows for the `普通` system** — it reads the ID directly.
- The `别名` system is the conventional place for alternative/common names
  (e.g. `怪动植物` → `黑白怪物`).

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

- Compile-time: `typst compile --input nomen=academic 地狱之下.typ out.pdf`
  (or `make nomen NOMEN=academic` in 文档/). Default is `普通`.
- In-document: `#set-nomen("别名")` switches for the rest of the document.

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
2. If the concept has an alternative name in another system, add a row to
   `名词系统.csv`:
   `概念名,系统名,替代名词`
3. Under 普通 it automatically renders the concept name itself.

## Gotchas

1. **Do not put `[#元素(...)]` in body text** — literal `[ ]` will render.
   Body text uses bare `#元素(...)`.
2. **普通系统不写 CSV 行** — it reads the ID value directly.
3. **ID must equal the common name** so fallback works (`if t == none { id }`).
4. **Editor is CSv-literal**: keep quotes/commas exact; a stray comma shifts
   the columns.
