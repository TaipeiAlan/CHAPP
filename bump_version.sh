#!/bin/bash
# bump_version.sh — 版本號管理
# 格式：v年月日_時分_次（次數每天從 1 重新計算）
#
# 使用方式：bash bump_version.sh
# 輸出範例：（初始） → v20260320_1540_1

VERSION_FILE="$(cd "$(dirname "$0")" && pwd)/VERSION"
TODAY=$(date +%Y%m%d)
NOW=$(date +%H%M)

if [ -f "$VERSION_FILE" ]; then
    OLD_DATE=$(awk 'NR==1{print}' "$VERSION_FILE")
    OLD_COUNT=$(awk 'NR==2{print}' "$VERSION_FILE")
    OLD_VER=$(awk 'NR==3{print}' "$VERSION_FILE")
else
    OLD_DATE=""
    OLD_COUNT=0
    OLD_VER="（初始）"
fi

if [ "$TODAY" = "$OLD_DATE" ]; then
    NEW_COUNT=$((OLD_COUNT + 1))
else
    NEW_COUNT=1
fi

NEW_VER="v${TODAY}_${NOW}_${NEW_COUNT}"
printf '%s\n%s\n%s\n' "$TODAY" "$NEW_COUNT" "$NEW_VER" > "$VERSION_FILE"

echo "${OLD_VER} → ${NEW_VER}"
