#!/bin/bash
set -euo pipefail

WORKFLOW_SRC="$(cd "$(dirname "$0")" && pwd)/dist/NewFile.workflow"
SERVICES_DIR="$HOME/Library/Services"

if [[ ! -d "$WORKFLOW_SRC" ]]; then
    echo "错误：找不到 dist/NewFile.workflow，请确保你在项目根目录运行此脚本。"
    exit 1
fi

mkdir -p "$SERVICES_DIR"
cp -R "$WORKFLOW_SRC" "$SERVICES_DIR/"

# 刷新 Services 注册表
/System/Library/CoreServices/pbs -flush 2>/dev/null || true

echo "✅ 安装成功！"
echo ""
echo "接下来两步操作："
echo "1. 打开「系统设置」→「键盘」→「键盘快捷键」→「服务」"
echo "   找到「新建文件」，勾选启用"
echo "2. 打开 Finder，在任意目录右键 → 「服务」→「新建文件」"
echo ""
echo "如需卸载，运行：rm -rf ~/Library/Services/NewFile.workflow"
