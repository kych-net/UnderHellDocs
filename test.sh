#!/bin/bash
# 测试脚本:基于附录排版规范的自动化检查
# Tests based on the appendix's typographic conventions
set -e

TYPST="${TYPST:-typst}"
FLAGS="--root .. --font-path fonts"
ERRORS=0

fail() { echo "FAIL: $1"; ERRORS=$((ERRORS+1)); }
pass() { echo "  OK: $1"; }

cd "$(dirname "$0")"  # 文档/

# ---------- 1. 编译测试(所有模式) ----------
echo "=== 1. 编译测试 ==="

for mode in "普通|  " "打印|--input print=true " "小屏|--input screen=true " \
            "academic|--input nomen=academic " "别名|--input nomen=别名 "; do
  name="${mode%%|*}"
  args="${mode##*|}"
  args="${args%  }"
  out="/tmp/underhell_test_$name.pdf"
  if $TYPST compile $FLAGS $args 地狱之下.typ "$out" 2>/dev/null; then
    pass "编译 $name"
    rm -f "$out"
  else
    fail "编译 $name"
  fi
done

# 附录也必须编译成功(通过 include)
if $TYPST compile $FLAGS 地狱之下.typ /tmp/underhell_test_full.pdf 2>/dev/null; then
  pass "附录编译"
  rm -f /tmp/underhell_test_full.pdf
else
  fail "附录编译"
fi

# ---------- 2. 名词系统 CSV 校验 ----------
echo ""
echo "=== 2. 名词系统 CSV 校验 ==="

CSV="名词系统.csv"
if [ ! -f "$CSV" ]; then
  fail "CSV 文件不存在: $CSV"
else
  # 检查表头
  header=$(head -1 "$CSV")
  if [ "$header" = "id,默认,别名,academic" ]; then
    pass "CSV 表头格式"
  else
    fail "CSV 表头不匹配: $header"
  fi

  # 检查所有文档中使用的元素是否都在 CSV 中
  # 提取文档中 #元素("xxx") 的 xxx
  used_elements=$(grep -rhoE '#元素\("[^"]+"\)' 地狱之下.typ 地狱之下附录.typ | \
    sed -E 's/#元素\("([^"]+)"\)/\1/' | sort -u)
  csv_ids=$(tail -n +2 "$CSV" | cut -d, -f1 | sort -u)

  missing=""
  for elem in $used_elements; do
    if ! echo "$csv_ids" | grep -qxF "$elem"; then
      missing="$missing $elem"
    fi
  done

  if [ -z "$missing" ]; then
    pass "所有文档元素在 CSV 中有 ID"
  else
    fail "CSV 缺失元素:$missing"
  fi
fi

# ---------- 3. 格式规范检查(附录规范) ----------
echo ""
echo "=== 3. 格式规范检查 ==="

# 3a. 中文字符间无空格(附录:"字之间别随便空格")
# 使用 python 跨平台检查,macOS grep 不支持 -P
cn_space=$(python3 -c "
import re, sys
count = 0
for f in ['地狱之下.typ', '地狱之下附录.typ']:
    try:
        src = open(f, encoding='utf-8').read()
        count += len(re.findall(r'[\u4e00-\u9fff] [\u4e00-\u9fff]', src))
    except: pass
print(count)
")
if [ "$cn_space" = "0" ]; then
  pass "中文字符间无空格"
else
  fail "中文字符间发现 $cn_space 处空格"
fi

# 3b. 交叉引用标签一致性:所有 @xxx 都有对应的 <xxx>
# 使用 python 跨平台检查
labels_check=$(python3 -c "
import re
defined = set()
used = set()
for f in ['地狱之下.typ', '地狱之下附录.typ']:
    try:
        src = open(f, encoding='utf-8').read()
        defined |= set(re.findall(r'<([^>]+)>', src))
        used |= set(m.lstrip('@') for m in re.findall(r'@[A-Za-z\u4e00-\u9fff]+', src))
    except: pass
orphan = used - defined
if orphan:
    print(' '.join(sorted(orphan)))
")
if [ -z "$labels_check" ]; then
  pass "所有交叉引用有对应标签"
else
  fail "孤立引用:$labels_check"
fi

# 3c. 大数用科学计数法(附录:"万级及以上数值改用科学计数法")
bad_numbers=$(python3 -c "
import re
found = []
for f in ['地狱之下.typ', '地狱之下附录.typ']:
    try:
        src = open(f, encoding='utf-8').read()
        found += re.findall(r'(?<![0-9])[1-9]\d{4,}(?![0-9])', src)
    except: pass
for n in sorted(set(found))[:5]:
    print(n)
")
if [ -z "$bad_numbers" ]; then
  pass "无非科学计数法的万级数值"
else
  echo "  注意:发现万级数值:$bad_numbers(请确认是否需要改为科学计数法)"
fi

# ---------- 结果 ----------
echo ""
echo "==============================="
if [ "$ERRORS" -eq 0 ]; then
  echo "全部测试通过"
  exit 0
else
  echo "测试失败: $ERRORS 项"
  exit 1
fi
