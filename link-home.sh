#!/usr/bin/env bash
# 将本仓库 spec/serverspec/ 映射到 ~/.serverspec（符号链接，文档与 sp 快捷命令统一入口）
set -euo pipefail
SPEC_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${HOME}/.serverspec"

if [[ -e "$TARGET" && ! -L "$TARGET" ]]; then
  echo "已存在且不是符号链接：$TARGET" >&2
  echo "请备份后删除该目录，再重新运行本脚本。" >&2
  exit 1
fi

ln -sfn "$SPEC_DIR" "$TARGET"
echo "已映射：$TARGET -> $SPEC_DIR"
echo "请在 ~/.bashrc 中加入："
echo '  [ -f "$HOME/.serverspec/sp.sh" ] && . "$HOME/.serverspec/sp.sh"'
