# OpenClaw Multi-Agent 新手指南

> 零基础从0搭建你的AI团队
> 面向自媒体博主 / 一人公司

---

## 🚀 快速开始

如果你有 **Claude Code**（推荐）：

```bash
# 1. 复制快速开始指令
# 打开 "guides/快速开始-给ClaudeCode发送这条.md"
# 复制全部内容

# 2. 粘贴到 Claude Code
# Claude Code 会自动完成所有配置

# 3. 创建 Telegram Bot
# 按 Claude Code 的指引创建 3 个 Bot（CEO、情报总监、小秘）

# 4. 测试
# 向三个 Bot 分别发送 "你好"
```

**5 分钟上手，10 分钟完成搭建！**

---

## 📚 文档导航

### 核心文档

| 文档 | 说明 |
|------|------|
| [DEPLOY.md](./DEPLOY.md) | GitHub & 飞书自动发布指南 |

### 新手指南（完整版）

| 文档 | 适合人群 |
|------|----------|
| [guides/使用说明.md](./guides/使用说明.md) | 所有用户 |
| [guides/快速开始-给ClaudeCode发送这条.md](./guides/快速开始-给ClaudeCode发送这条.md) | Claude Code用户 |
| [guides/ClaudeCode搭建指南.md](./guides/ClaudeCode搭建指南.md) | Claude Code用户（详细版） |
| [guides/01-系统架构总览.md](./guides/01-系统架构总览.md) | 想了解架构的用户 |
| [guides/02-零基础上手指南.md](./guides/02-零基础上手指南.md) | 想手动配置的用户 |
| [guides/03-Agent配置详解.md](./guides/03-Agent配置详解.md) | Agent 配置详解 |
| [guides/04-Telegram配对流程.md](./guides/04-Telegram配对流程.md) | Telegram Bot 配置 |
| [guides/05-完成检查清单.md](./guides/05-完成检查清单.md) | 验证配置是否正确 |

### Skill文档

| 文档 | 说明 |
|------|------|
| [RECOMMENDED-SKILLS.md](./RECOMMENDED-SKILLS.md) | 精选16个核心Skill（内容创作、多Agent协作等）|
| [QUICKSTART-SKILLS.md](./QUICKSTART-SKILLS.md) | 5分钟快速安装核心Skills |

---

## 🏗️ 系统架构

```
┌─────────────────────────────────────┐
│       你的AI团队                     │
├─────────────────────────────────────┤
│  CEO (@ceo_ai_bot)                 │
│  → 统领全局，智能路由                │
│                                     │
│  小秘 (@secretary_ai_bot)           │
│  → 日程管理，聊天陪伴               │
│                                     │
│  情报总监 (@intel_director_ai_bot) │
│  → 热点情报，选题推荐               │
│                                     │
│  公众号主管 (@wechat_manager_ai_bot)│
│  → 公众号创作                       │
│                                     │
│  小红书主管 (@redbook_manager_ai_bot)│
│  → 小红书运营                       │
└─────────────────────────────────────┘
```

### 完整的12个Agent

| # | ID | 名称 | 角色 |
|---|---|---|---|
| 1 | `ceo` | CEO | 统领全局、智能路由 |
| 2 | `secretary` | 小秘 | 日程管理+聊天陪伴 |
| 3 | `intel-director` | 情报总监 | 热点情报、选题推荐 |
| 4 | `wechat-manager` | 公众号主管 | 公众号创作 |
| 5 | `redbook-manager` | 小红书主管 | 小红书运营 |
| 6 | `ops-director` | 运营总监 | 增长策略 |
| 7 | `product-manager` | 产品经理 | 需求分析 |
| 8 | `tech-lead` | 技术总监 | 技术开发 |
| 9 | `finance-buddy` | 财务管家 | 收支管理 |
| 10 | `investor` | 投资专家 | 投资分析 |
| 11 | `biz-advisor` | 商业顾问 | 战略智囊 |
| 12 | `knowledge-lib` | 知识管家 | 知识管理 |

---

## 📁 目录结构

```
星河Multi-agents新手guide-demo/
├── guides/                  # 完整的搭建指南
│   ├── 使用说明.md
│   ├── 快速开始-给ClaudeCode发送这条.md
│   ├── ClaudeCode搭建指南.md
│   ├── README-ClaudeCode版.md
│   ├── 01-系统架构总览.md
│   ├── 02-零基础上手指南.md
│   ├── 03-Agent配置详解.md
│   ├── 04-Telegram配对流程.md
│   └── 05-完成检查清单.md
│
├── demo-agents/              # 12个Agent的完整Demo配置
│   ├── README.md
│   ├── ceo/
│   ├── secretary/
│   ├── intel-director/
│   ├── wechat-manager/
│   ├── redbook-manager/
│   ├── ops-director/
│   ├── product-manager/
│   ├── tech-lead/
│   ├── finance-buddy/
│   ├── investor/
│   ├── biz-advisor/
│   └── knowledge-lib/
│
├── scripts/                  # 自动化脚本
│   ├── setup-github.sh      # GitHub 初始化
│   ├── deploy-github.sh     # GitHub 发布
│   ├── deploy-feishu.sh     # 飞书发布
│   ├── deploy.sh            # 一键发布
│   ├── test-feishu.sh       # 飞书连接测试
│   └── .feishu.conf.example # 飞书配置模板
│
├── DEPLOY.md                # 发布指南
├── QUICKSTART-DEPLOY.md     # 快速发布指南
├── RECOMMENDED-SKILLS.md    # 精选Skill清单
├── QUICKSTART-SKILLS.md     # Skill快速安装
└── README.md               # 本文件
```

---

## 🔧 发布到 GitHub & 飞书

### 方式1：一键发布

```bash
cd 星河Multi-agents新手guide-demo

# 一键发布（GitHub + 飞书）
./scripts/deploy.sh
```

### 方式2：分别发布

```bash
# 只发布到 GitHub
./scripts/deploy-github.sh

# 只发布到飞书
./scripts/deploy-feishu.sh
```

详细说明请参考 [QUICKSTART-DEPLOY.md](./QUICKSTART-DEPLOY.md)

---

## 🛠️ 安装推荐Skills

### 快速安装（5分钟）

```bash
# 核心基础（必装）
openclaw skill install tavily-search
openclaw skill install memory-lancedb-pro

# 内容创作（选装）
openclaw skill install wechat-article-pro
openclaw skill install redbook-maker
openclaw skill install humanizer

# Agent协作（推荐）
openclaw skill install multi-agent-pipeline
openclaw skill install agent-autonomy-kit
```

详细说明请参考 [QUICKSTART-SKILLS.md](./QUICKSTART-SKILLS.md)

---

## 🎯 你将得到什么

完成搭建后，你将拥有：

### AI 团队

- **CEO**: 智能路由所有任务
- **小秘**: 日程管理+聊天陪伴
- **情报总监**: 每日热点+选题推荐
- **公众号主管**: 公众号内容创作
- **小红书主管**: 小红书运营
- **运营总监**: 数据分析+增长策略
- **产品经理**: 需求分析+竞品研究
- **技术总监**: 技术开发
- **财务管家**: 收支管理
- **投资专家**: 投资分析
- **商业顾问**: 战略咨询
- **知识管家**: 知识管理

### Telegram Bot

- 3个独立的 Bot（CEO、情报总监、小秘）
- 随时随地访问
- 自动任务派发
- 极简简报机制

### 增强Skills

- 网络搜索和实时信息
- 长期记忆和知识库
- 自动化工作流
- 多Agent协作

---

## 📖 学习路径

### 路径1：快速上手（10分钟）

1. 阅读 [guides/使用说明.md](./guides/使用说明.md)
2. 复制 [guides/快速开始-给ClaudeCode发送这条.md](./guides/快速开始-给ClaudeCode发送这条.md) 给 Claude Code
3. 等待完成
4. 测试 Bot

### 路径2：深入学习（1-2小时）

1. 阅读 [guides/01-系统架构总览.md](./guides/01-系统架构总览.md)
2. 阅读 [guides/03-Agent配置详解.md](./guides/03-Agent配置详解.md)
3. 阅读 [guides/04-Telegram配对流程.md](./guides/04-Telegram配对流程.md)
4. 使用 [guides/05-完成检查清单.md](./guides/05-完成检查清单.md) 验证

### 路径3：安装Skills（5分钟）

1. 阅读 [QUICKSTART-SKILLS.md](./QUICKSTART-SKILLS.md)
2. 按顺序安装核心Skills
3. 测试Skill功能

---

## 🆘 遇到问题？

### 版本选择
- 不知道用哪个版本？看 [guides/使用说明.md](./guides/使用说明.md)

### 配置问题
- Claude Code 执行失败？查看错误信息并重试
- Bot 不回复？检查 Gateway 状态：`openclaw gateway status`
- 配置不生效？重启 Gateway：`openclaw gateway restart`

### 技术支持
- 使用 [guides/05-完成检查清单.md](./guides/05-完成检查清单.md) 逐项检查
- 查看日志：`tail -f ~/.openclaw/gateway.log`
- OpenClaw 官方文档：运行 `openclaw help`

### Skill问题
- Skill 安装失败？运行 `openclaw skill install --verbose`
- Skill 不生效？运行 `openclaw skill enable --all`
- 查看 [RECOMMENDED-SKILLS.md](./RECOMMENDED-SKILLS.md) 常见问题

---

## 📝 更新日志

### v1.0.0 (2026-04-23)

- ✅ 完整的搭建指南（10个文档）
- ✅ 12个Agent Demo配置（73个文件）
- ✅ 面向自媒体博主/一人公司
- ✅ GitHub & 飞书自动化发布
- ✅ 双总Agent体系（CEO + 小秘）
- ✅ 精选Skill清单（16个核心Skill）

---

## 📄 许可证

MIT License

---

## 🙏 致谢

基于 [OpenClaw](https://github.com/openclaw/openclaw) 构建

---

_打造你的 AI 团队，从这里开始！🚀_
