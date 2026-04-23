#!/bin/bash

# 一键发布脚本（GitHub + 飞书）
# 用途：同步发布到 GitHub 和飞书

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🚀 Multi-Agent 新手指南 - 一键发布"
echo "=================================="
echo ""
echo "将依次执行："
echo "  1. GitHub 发布"
echo "  2. 飞书发布"
echo ""

# 确认发布
read -p "确认开始发布？(y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "取消发布"
    exit 0
fi

# GitHub 发布
echo ""
echo "=================================="
echo "🐙 GitHub 发布"
echo "=================================="
bash "$SCRIPT_DIR/deploy-github.sh"

# 飞书发布
echo ""
echo "=================================="
echo "✈️  飞书发布"
echo "=================================="
bash "$SCRIPT_DIR/deploy-feishu.sh"

# 输出汇总
echo ""
echo "=================================="
echo "✅ 发布完成"
echo "=================================="
echo ""
echo "📍 GitHub: $(cd "$PROJECT_DIR" && gh repo view --json url -q .url)"
echo "📍 飞书: 请在飞书中查看发布的内容"
echo ""
echo "下一步："
echo "  1. 在飞书中编辑文档内容"
echo "  2. 调整格式和排版"
echo "  3. 设置分享权限"
echo ""
