# GitHub & 飞书自动发布指南

> 一键同步到 GitHub 和飞书文档

---

## 🚀 快速开始

```bash
# 切换到项目目录
cd "/Users/zhangyang/Nutstore Files/Jarvis 个人云/星河多智能体落地方案/星河Multi-agents新手guide-demo"

# 同步到 GitHub 和飞书
./scripts/deploy.sh
```

---

## 📋 发布流程

```
新手guide-demo/
├── 新手指南/           # 源内容
└── scripts/
    ├── setup-github.sh   # GitHub 初始化
    ├── deploy-github.sh  # GitHub 发布
    ├── deploy-feishu.sh  # 飞书发布
    └── deploy.sh         # 一键发布（GitHub + 飞书）
```

---

## 🐙 GitHub 发布

### 准备工作

1. 安装 `gh` CLI
```bash
brew install gh
# 或
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
```

2. 登录 GitHub
```bash
gh auth login
```

### 自动化配置

运行一次初始化：

```bash
./scripts/setup-github.sh
```

会自动：
- 创建 GitHub 仓库
- 配置 `.gitignore`
- 初始化 Git
- 设置主分支为 `main`

### 每次发布

```bash
./scripts/deploy-github.sh
```

会自动：
- 提交所有更改
- 生成版本号（基于时间戳）
- 推送到 GitHub
- 创建 Git Tag 和 Release

---

## ✈️ 飞书发布

### 准备工作

1. 获取飞书 API 凭证

#### 步骤 1：创建飞书应用
- 打开 [飞书开放平台](https://open.feishu.cn/)
- 创建"企业自建应用"
- 记录 `App ID` 和 `App Secret`

#### 步骤 2：配置权限
在应用管理中启用以下权限：
- `drive:drive` - 云盘读取权限
- `drive:file` - 文件读写权限
- `wiki:wiki:readonly` - 知识库读取权限（可选）

#### 步骤 3：获取 Tenant Key
在应用详情页获取 `Tenant Access Token`

### 配置文件

创建 `scripts/.feishu.conf`：

```bash
APP_ID=your_app_id
APP_SECRET=your_app_secret
FOLDER_TOKEN=your_folder_token  # 目标文件夹的 token
```

### 每次发布

```bash
./scripts/deploy-feishu.sh
```

会自动：
- 将所有 Markdown 文件转换为飞书文档
- 保持目录结构
- 上传到指定飞书文件夹
- 更新已有的文档

---

## 🔄 一键发布

```bash
./scripts/deploy.sh
```

依次执行：
1. GitHub 发布
2. 飞书发布

完成后输出：
- GitHub 仓库链接
- 飞书文档链接

---

## 📝 版本管理

### GitHub 版本号

自动生成格式：`vYYYY.MM.DD-HHMM`

示例：`v2026.04.23-1430`

### 手动指定版本

```bash
VERSION=v1.0.0 ./scripts/deploy-github.sh
```

---

## 🔧 高级配置

### GitHub

编辑 `.github/config`（可选）：
```bash
REPO_NAME=multi-agent-guide
REPO_DESC=OpenClaw多Agent系统新手指南
DEFAULT_BRANCH=main
LICENSE=MIT
```

### 飞书

编辑 `scripts/.feishu.conf`：
```bash
APP_ID=...
APP_SECRET=...
FOLDER_TOKEN=...          # 目标文件夹
DOC_PREFIX=【新手指南】     # 文档标题前缀
CREATE_INDEX=true          # 是否创建索引文档
```

---

## 🆘 常见问题

### Q: GitHub 推送失败？
```bash
# 检查登录状态
gh auth status

# 重新登录
gh auth login
```

### Q: 飞书 API 调用失败？
```bash
# 检查凭证配置
cat scripts/.feishu.conf

# 测试连接
./scripts/test-feishu.sh
```

### Q: 文档格式问题？
- 飞书对 Markdown 支持有限
- 复杂表格和公式可能需要手动调整
- 建议使用标准 Markdown 语法

---

## 📚 参考资料

- [GitHub CLI 文档](https://docs.github.com/en/cli)
- [飞书开放平台 API](https://open.feishu.cn/document/)
- [飞书知识库 API](https://open.feishu.cn/document/server-docs/docs/docs-api)

---

_自动化发布 v1.0_
