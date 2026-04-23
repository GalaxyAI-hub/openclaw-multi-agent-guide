#!/bin/bash

# GitHub 发布脚本
# 用途：提交更改、生成版本号、推送到 GitHub

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🐙 GitHub 发布"
echo "=============="
echo ""

# 检查 Git 仓库
if [ ! -d "$PROJECT_DIR/.git" ]; then
    echo "❌ Git 仓库未初始化"
    echo "   请先运行: ./scripts/setup-github.sh"
    exit 1
fi

# 检查 gh CLI
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) 未安装"
    exit 1
fi

cd "$PROJECT_DIR"

# 生成版本号
if [ -z "$VERSION" ]; then
    VERSION="v$(date +'%Y.%m.%d-%H%M')"
fi

echo "📦 版本号: $VERSION"
echo ""

# 检查是否有更改
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ 没有需要提交的更改"
else
    echo "📝 正在提交更改..."
    git add .
    
    # 生成提交信息
    COMMIT_MSG="Release $VERSION"
    if [ -n "$CUSTOM_MSG" ]; then
        COMMIT_MSG="$CUSTOM_MSG ($VERSION)"
    fi
    
    git commit -m "$COMMIT_MSG"
    echo "✅ 提交成功"
fi

# 推送到 GitHub
echo ""
echo "📤 正在推送到 GitHub..."
git push origin main
echo "✅ 推送成功"

# 创建 Git Tag
echo ""
echo "🏷️  正在创建 Git Tag..."
git tag -a "$VERSION" -m "Release $VERSION"
git push origin "$VERSION"
echo "✅ Tag 创建成功"

# 创建 GitHub Release
echo ""
echo "📢 正在创建 GitHub Release..."

# 生成 Release Notes
RELEASE_NOTES=$(cat <<EOF
# OpenClaw Multi-Agent 新手指南 $VERSION

## 更新内容
- 完整的搭建指南（10个文档）
- 12个Agent Demo配置（73个文件）
- 面向自媒体博主/一人公司

## 快速开始
参考 [README.md](README.md) 开始使用。

## 完整文档
- 使用说明
- 快速开始
- 系统架构
- Agent配置
- Telegram配对

---

自动发布于 $(date +'%Y-%m-%d %H:%M:%S')
EOF
)

gh release create "$VERSION" \
    --title "Multi-Agent新手指南 $VERSION" \
    --notes "$RELEASE_NOTES" \
    --latest

echo "✅ Release 创建成功"
echo ""

# 输出链接
REPO_URL=$(gh repo view --json url -q .url)
echo "📍 GitHub 仓库: $REPO_URL"
echo "📍 Release 页面: $REPO_URL/releases/tag/$VERSION"
echo ""
echo "✅ 发布完成！"
