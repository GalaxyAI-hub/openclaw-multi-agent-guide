#!/bin/bash

# 飞书连接测试脚本
# 用途：测试飞书 API 配置是否正确

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_FILE="$SCRIPT_DIR/.feishu.conf"

echo "✈️  飞书连接测试"
echo "================"
echo ""

# 检查配置文件
if [ ! -f "$CONF_FILE" ]; then
    echo "❌ 配置文件不存在: $CONF_FILE"
    echo ""
    echo "请复制示例配置文件："
    echo "  cp .feishu.conf.example .feishu.conf"
    echo ""
    echo "然后编辑 .feishu.conf 填入你的凭证"
    exit 1
fi

# 加载配置
source "$CONF_FILE"

# 检查配置
if [ -z "$APP_ID" ]; then
    echo "❌ APP_ID 未配置"
    exit 1
fi

if [ -z "$APP_SECRET" ]; then
    echo "❌ APP_SECRET 未配置"
    exit 1
fi

if [ -z "$FOLDER_TOKEN" ]; then
    echo "❌ FOLDER_TOKEN 未配置"
    exit 1
fi

echo "✅ 配置文件加载成功"
echo "   APP_ID: $APP_ID"
echo "   FOLDER_TOKEN: $FOLDER_TOKEN"
echo ""

# 测试获取 Tenant Access Token
echo "🔑 测试 1: 获取 Access Token..."
TOKEN_RESPONSE=$(curl -s -X POST "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal" \
    -H "Content-Type: application/json" \
    -d "{\"app_id\": \"$APP_ID\", \"app_secret\": \"$APP_SECRET\"}")

TENANT_ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | grep -o '"tenant_access_token":"[^"]*' | cut -d'"' -f4)
EXPIRES_IN=$(echo "$TOKEN_RESPONSE" | grep -o '"expire":[0-9]*' | cut -d':' -f2)

if [ -z "$TENANT_ACCESS_TOKEN" ]; then
    echo "❌ 获取 Token 失败"
    echo ""
    echo "响应内容:"
    echo "$TOKEN_RESPONSE"
    echo ""
    echo "可能的原因："
    echo "  1. APP_ID 或 APP_SECRET 错误"
    echo "  2. 应用未启用"
    echo "  3. 网络连接问题"
    exit 1
fi

echo "✅ Token 获取成功"
echo "   有效期: $EXPIRES_IN 秒"
echo ""

# 测试创建文档
echo "📄 测试 2: 创建测试文档..."

TEST_TITLE="【测试】飞书连接测试-$(date +%s)"

CREATE_RESPONSE=$(curl -s -X POST "https://open.feishu.cn/open-apis/docx/v1/documents" \
    -H "Authorization: Bearer $TENANT_ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"title\": \"$TEST_TITLE\", \"folder_token\": \"$FOLDER_TOKEN\"}")

DOC_ID=$(echo "$CREATE_RESPONSE" | grep -o '"document_id":"[^"]*' | cut -d'"' -f4)
CODE=$(echo "$CREATE_RESPONSE" | grep -o '"code":[0-9]*' | cut -d':' -f2)

if [ "$CODE" = "0" ] && [ -n "$DOC_ID" ]; then
    echo "✅ 测试文档创建成功"
    echo "   文档 ID: $DOC_ID"
    echo "   文档标题: $TEST_TITLE"
    echo ""
    echo "📍 请在飞书中查看测试文档（创建后可删除）"
else
    echo "❌ 文档创建失败"
    echo ""
    echo "响应内容:"
    echo "$CREATE_RESPONSE"
    echo ""
    echo "可能的原因："
    echo "  1. FOLDER_TOKEN 错误"
    echo "  2. 应用没有文档创建权限"
    echo "  3. 目标文件夹不存在"
    exit 1
fi

echo ""
echo "=================================="
echo "✅ 所有测试通过"
echo "=================================="
echo ""
echo "配置正确，可以开始发布："
echo "  ./scripts/deploy-feishu.sh"
echo ""
