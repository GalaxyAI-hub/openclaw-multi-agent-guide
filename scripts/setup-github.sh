#!/bin/bash

# GitHub 仓库初始化脚本
# 用途：创建 GitHub 仓库并初始化 Git

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🐙 GitHub 仓库初始化"
echo "===================="
echo ""

# 检查 gh CLI
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) 未安装"
    echo "   安装方式：brew install gh"
    exit 1
fi

# 检查登录状态
if ! gh auth status &> /dev/null; then
    echo "❌ 未登录 GitHub"
    echo "   请运行: gh auth login"
    exit 1
fi

echo "✅ GitHub CLI 已安装并登录"
echo ""

# 读取配置
REPO_NAME=${REPO_NAME:-"openclaw-multi-agent-guide"}
REPO_DESC=${REPO_DESC:-"OpenClaw多Agent系统新手指南 - 零基础从0搭建AI团队"}
PRIVATE=${REPO_PRIVATE:-"false"}
LICENSE=${LICENSE:-"MIT"}

# 检查是否已初始化 Git
if [ -d "$PROJECT_DIR/.git" ]; then
    echo "⚠️  Git 仓库已存在"
    read -p "是否重新初始化？(y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "跳过初始化"
        exit 0
    fi
    rm -rf "$PROJECT_DIR/.git"
fi

# 创建 .gitignore
cat > "$PROJECT_DIR/.gitignore" << 'EOF'
# 敏感信息
.feishu.conf
.github/config
.env
*.key

# 临时文件
.DS_Store
*.tmp
*.log

# Node modules（如果有）
node_modules/
package-lock.json

# IDE
.vscode/
.idea/
*.swp
*~

# 系统文件
Thumbs.db
EOF

echo "✅ 已创建 .gitignore"

# 初始化 Git
cd "$PROJECT_DIR"
git init
git add .
git commit -m "Initial commit: Multi-Agent新手指南"

echo "✅ Git 仓库已初始化"

# 创建远程仓库
echo ""
echo "📤 正在创建 GitHub 仓库..."
echo "   仓库名: $REPO_NAME"
echo "   描述: $REPO_DESC"
echo "   可见性: $([[ "$PRIVATE" == "true" ]] && echo "私有" || echo "公开")"

gh repo create "$REPO_NAME" \
    --description="$REPO_DESC" \
    --public \
    --source="$PROJECT_DIR" \
    --remote=origin \
    --push \
    --license="$LICENSE"

echo ""
echo "✅ GitHub 仓库创建成功！"
echo ""
echo "📍 仓库地址: https://github.com/$(gh auth status --show-username)/$REPO_NAME"
echo ""
echo "下一步："
echo "  运行 ./scripts/deploy-github.sh 进行发布"
