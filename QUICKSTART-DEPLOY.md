# 🚀 快速开始 - 自动发布到 GitHub & 飞书

## 项目位置

```
/Users/zhangyang/Nutstore Files/Jarvis 个人云/星河多智能体落地方案/星河Multi-agents新手guide-demo
```

## 📋 已完成的工作

✅ 12个Agent的完整Demo配置（73个文件）
✅ 新手指南文档（10个）
✅ GitHub自动发布脚本
✅ 飞书自动发布脚本
✅ 一键发布脚本

---

## 🐙 发布到 GitHub

### 第1步：首次配置（只需一次）

```bash
cd "/Users/zhangyang/Nutstore Files/Jarvis 个人云/星河多智能体落地方案/星河Multi-agents新手guide-demo"

# 1. 安装 GitHub CLI（如果未安装）
brew install gh

# 2. 登录 GitHub
gh auth login

# 3. 初始化仓库
./scripts/setup-github.sh
```

这会自动：
- 在 GitHub 创建公开仓库
- 初始化 Git
- 推送代码

### 第2步：每次发布

```bash
# 自动提交、生成版本号、创建Release
./scripts/deploy-github.sh
```

---

## ✈️ 发布到飞书

### 第1步：首次配置（只需一次）

```bash
# 1. 创建配置文件
cp scripts/.feishu.conf.example scripts/.feishu.conf

# 2. 编辑配置文件，填入凭证
vim scripts/.feishu.conf
```

你需要填写：
- `APP_ID` - 飞书应用的 App ID
- `APP_SECRET` - 飞书应用的 App Secret
- `FOLDER_TOKEN` - 飞书目标文件夹的 token

#### 如何获取这些凭证？

**1. 创建飞书应用**
- 访问 [飞书开放平台](https://open.feishu.cn/)
- 创建"企业自建应用"
- 记录 `App ID` 和 `App Secret`

**2. 配置权限**
在应用管理中启用：
- `drive:drive` - 云盘读取
- `drive:file` - 文件读写

**3. 获取 Folder Token**
- 在飞书中创建一个文件夹
- 复制浏览器 URL 中的 folder_token

### 第2步：测试连接

```bash
./scripts/test-feishu.sh
```

如果看到"✅ 所有测试通过"，说明配置正确。

### 第3步：每次发布

```bash
# 自动上传所有文档到飞书
./scripts/deploy-feishu.sh
```

---

## 🔄 一键发布（推荐）

```bash
cd "/Users/zhangyang/Nutstore Files/Jarvis 个人云/星河多智能体落地方案/星河Multi-agents新手guide-demo"

# 一键发布到 GitHub + 飞书
./scripts/deploy.sh
```

---

## 📖 详细文档

- [README.md](./README.md) - 项目完整说明
- [DEPLOY.md](./DEPLOY.md) - 详细发布指南

---

## ⚡ 使用建议

### 每次更新内容后

1. 修改指南或Demo文件
2. 运行 `./scripts/deploy.sh`
3. 自动同步到 GitHub 和飞书

### 版本管理

- GitHub 自动生成版本号：`vYYYY.MM.DD-HHMM`
- 可以手动指定：`VERSION=v1.0.0 ./scripts/deploy-github.sh`

---

_自动化发布 v1.0 - 2026-04-23_
