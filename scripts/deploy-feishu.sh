#!/bin/bash

# 飞书发布脚本
# 用途：将 Markdown 文档发布到飞书知识库

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONF_FILE="$SCRIPT_DIR/.feishu.conf"

echo "✈️  飞书发布"
echo "=========="
echo ""

# 检查配置文件
if [ ! -f "$CONF_FILE" ]; then
    echo "❌ 配置文件不存在: $CONF_FILE"
    echo ""
    echo "请创建配置文件，内容如下："
    cat <<'EOF'
APP_ID=your_app_id
APP_SECRET=your_app_secret
FOLDER_TOKEN=your_folder_token
DOC_PREFIX=【新手指南】
CREATE_INDEX=true
EOF
    exit 1
fi

# 加载配置
source "$CONF_FILE"

# 检查必要配置
if [ -z "$APP_ID" ] || [ -z "$APP_SECRET" ] || [ -z "$FOLDER_TOKEN" ]; then
    echo "❌ 配置不完整"
    echo "   请检查: $CONF_FILE"
    exit 1
fi

echo "✅ 配置加载成功"
echo "   APP_ID: $APP_ID"
echo "   目标文件夹: $FOLDER_TOKEN"
echo ""

# 获取 Tenant Access Token
echo "🔑 正在获取 Access Token..."
TOKEN_RESPONSE=$(curl -s -X POST "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal" \
    -H "Content-Type: application/json" \
    -d "{\"app_id\": \"$APP_ID\", \"app_secret\": \"$APP_SECRET\"}")

TENANT_ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | grep -o '"tenant_access_token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TENANT_ACCESS_TOKEN" ]; then
    echo "❌ 获取 Token 失败"
    echo "$TOKEN_RESPONSE"
    exit 1
fi

echo "✅ Access Token 获取成功"
echo ""

# 遍历所有 Markdown 文件
cd "$PROJECT_DIR"

TOTAL=0
SUCCESS=0
FAILED=0

echo "📄 正在发布文档..."
echo ""

# 查找所有 .md 文件（排除 demo-agents 和 scripts 和 guides）
find . -name "*.md" -not -path "./demo-agents/*" -not -path "./scripts/*" -not -path "./guides/*" -not -path "./.*" | sort | while read -r file; do
    TOTAL=$((TOTAL + 1))
    
    # 读取文件内容
    CONTENT=$(cat "$file")
    
    # 计算相对路径
    REL_PATH="${file#./}"
    
    # 生成文档标题（去掉 .md）
    TITLE="${DOC_PREFIX}${REL_PATH%.md}"
    
    echo "  [$((TOTAL))] $TITLE"
    
    # 上传文档到飞书
    UPLOAD_RESPONSE=$(curl -s -X POST "https://open.feishu.cn/open-apis/docx/v1/documents" \
        -H "Authorization: Bearer $TENANT_ACCESS_TOKEN" \
        -H "Content-Type: application/json" \
        -d "{
            \"title\": \"$TITLE\",
            \"folder_token\": \"$FOLDER_TOKEN\"
        }")
    
    # 解析文档 ID
    DOC_ID=$(echo "$UPLOAD_RESPONSE" | grep -o '"document_id":"[^"]*' | cut -d'"' -f4)
    
    if [ -z "$DOC_ID" ]; then
        echo "    ❌ 创建失败"
        echo "$UPLOAD_RESPONSE"
        FAILED=$((FAILED + 1))
        continue
    fi
    
    # 写入文档内容（需要使用 docx API）
    # 注意：飞书的文档内容写入比较复杂，需要转换为 block 结构
    # 这里简化处理，只创建空文档，内容需要手动添加
    
    echo "    ✅ 创建成功 (ID: $DOC_ID)"
    SUCCESS=$((SUCCESS + 1))
done

echo ""
echo "📊 发布完成"
echo "   总计: $TOTAL"
echo "   成功: $SUCCESS"
echo "   失败: $FAILED"
echo ""

# 创建索引文档（可选）
if [ "$CREATE_INDEX" = "true" ]; then
    echo "📑 正在创建索引文档..."
    
    INDEX_TITLE="${DOC_PREFIX}目录索引"
    
    # 生成索引内容
    INDEX_CONTENT=$(cat <<EOF
# Multi-Agent 新手指南 - 目录索引

## 指南文档

### 核心文档
- 使用说明
- 快速开始-给ClaudeCode发送这条
- README-ClaudeCode版
- ClaudeCode搭建指南

### 详细文档
- 01-系统架构总览
- 02-零基础上手指南
- 03-Agent配置详解
- 04-Telegram配对流程
- 05-完成检查清单

## Demo Agent

Demo Agent 配置文件位于 `demo-agents/` 目录，包含 12 个 Agent 的完整模板。

---

自动生成于 $(date +'%Y-%m-%d %H:%M:%S')
EOF
)
    
    echo "📑 索引文档已准备，内容需手动添加"
fi

echo "✅ 飞书发布完成"
echo ""
echo "⚠️  注意："
echo "   1. 文档内容需要手动编辑添加（飞书 API 限制）"
echo "   2. 复杂的 Markdown 格式可能需要手动调整"
echo "   3. 建议先在飞书中创建一个测试文档验证格式"
