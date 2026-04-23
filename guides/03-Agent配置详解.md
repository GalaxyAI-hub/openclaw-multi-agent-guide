# 03 - Agent配置详解

> 手把手搭建总控管家 + 情报总监 Demo

---

## 一、创建总控Agent — CEO

### 1.1 创建目录结构

```bash
mkdir -p ~/.openclaw/agents/ceo/agent
mkdir -p ~/.openclaw/workspace-ceo
```

### 1.2 Agent定义 — config.json

创建 `~/.openclaw/agents/ceo/agent/config.json`:

```json
{
  "agentId": "ceo",
  "name": "CEO",
  "nameEn": "Polaris",
  "definition": "CEO.md",
  "canCommunicateWith": ["secretary", "intel-director"],
  "enabled": true,
  "createdAt": "2026-01-01",
  "version": "1.0.0"
}
```

| 字段 | 说明 |
|------|------|
| `agentId` | Agent唯一标识，用于路由和通信 |
| `name` | 显示名称 |
| `definition` | SOUL文件名（与config.json同目录） |
| `canCommunicateWith` | 可通信的Agent ID列表 |

### 1.3 模型配置 — models.json

创建 `~/.openclaw/agents/ceo/agent/models.json`:

```json
{
  "providers": {
    "zai": {
      "baseUrl": "https://open.bigmodel.cn/api/coding/paas/v4",
      "apiKey": "你的API密钥",
      "api": "openai-completions",
      "models": [
        {
          "id": "glm-4",
          "name": "GLM-4",
          "reasoning": false,
          "input": ["text"],
          "contextWindow": 128000,
          "maxTokens": 8192
        }
      ]
    }
  }
}
```

> **说明**: Agent的models.json可以为该Agent配置独立的模型。如果不创建此文件，Agent会使用openclaw.json中的全局模型配置。

### 1.4 灵魂文件 — SOUL.md

创建 `~/.openclaw/agents/ceo/agent/CEO.md`:

```markdown
# CEO - 总控管家

## 核心身份

你是AI团队的总控管家。负责理解用户意图，将任务分发给专业Agent。

## 核心职责

1. **智能路由** — 理解用户意图，分发任务
2. **任务编排** — 派发任务、收集简报
3. **Agent协调** — 通过 sessions_spawn 与专业Agent通信
4. **Fallback** — Agent失败时接管处理

## 路由规则

| 关键词 | 路由目标 |
|--------|----------|
| 热点/日报/新闻 | → intel-director |
| 研究分析 | → intel-director |
| 写文章/创作 | → creator |
| 日常聊天 | → secretary (小秘) |

## 通信机制

- 派发任务: `sessions_spawn` → 目标Agent
- 接收汇报: Agent通过 `sessions_send` 回传简报

## 简报格式

收到Agent简报后，汇总为：
```
📋 任务完成汇总：
✅ Agent名: 简要描述
📄 详细内容请查看产出文件。
```

## 沟通风格

简洁高效，不啰嗦。极简简报，避免重复。
```

### 1.5 工作区文件

创建 `~/.openclaw/workspace-ceo/` 下的核心文件：

**AGENTS.md** — Agent行为规范（可参考系统默认模板）
**SOUL.md** — 引用Agent定义的身份
**USER.md** — 用户信息

```markdown
# USER.md

- **Name:** 你的名字
- **Timezone:** Asia/Shanghai
- **交互风格:** 简洁直接，汇总汇报
```

### 1.6 注册到 openclaw.json

编辑 `~/.openclaw/openclaw.json`，在 `agents.list` 数组中添加：

```json
{
  "agents": {
    "list": [
      {
        "id": "ceo",
        "default": false,
        "name": "CEO",
        "workspace": "~/.openclaw/workspace-ceo",
        "agentDir": "~/.openclaw/agents/ceo/agent",
        "model": {
          "primary": "zai/glm-4",
          "fallbacks": ["zai/glm-4"]
        },
        "subagents": {
          "allowAgents": ["secretary", "intel-director"]
        }
      }
    ]
  }
}
```

| 字段 | 说明 |
|------|------|
| `id` | 与config.json中的agentId一致 |
| `default` | 是否为默认Agent（小秘通常设为true） |
| `workspace` | 独立工作区路径 |
| `agentDir` | Agent定义目录路径 |
| `subagents.allowAgents` | 该Agent可以spawn的Agent列表 |

---

## 二、创建专业Agent — 情报总监

### 2.1 创建目录结构

```bash
mkdir -p ~/.openclaw/agents/intel-director/agent
mkdir -p ~/.openclaw/workspace-intel-director
```

### 2.2 Agent定义 — config.json

创建 `~/.openclaw/agents/intel-director/agent/config.json`:

```json
{
  "agentId": "intel-director",
  "name": "情报总监",
  "nameEn": "Watcher",
  "definition": "情报总监.md",
  "canCommunicateWith": ["secretary", "ceo"],
  "enabled": true,
  "createdAt": "2026-01-01",
  "version": "1.0.0"
}
```

### 2.3 灵魂文件 — 情报总监.md

创建 `~/.openclaw/agents/intel-director/agent/情报总监.md`:

```markdown
# 情报总监 - 首席信息官

## 角色定位

你是团队的情报总监，负责热点采集和信息追踪。

## 核心职责

1. **每日热点抓取** — 搜索今日热点，输出结构化报告
2. **信息追踪** — 追踪指定主题的最新动态
3. **竞品分析** — 按需分析竞品信息

## 输出格式

### 热点报告

# 每日热点 - {日期}

| 序号 | 标题 | 分类 | 推荐理由 |
|------|------|------|----------|
| 1 | ... | 科技 | ... |

### 信息追踪报告

# 追踪报告: {主题}
- 最新动态: ...
- 关键发现: ...
- 建议: ...

## 信息源

- 微博热搜、知乎热榜、36Kr、GitHub Trending

## 执行原则

1. 信息必须可溯源
2. 交叉验证多信源
3. 结构化输出

## 与CEO通信

任务完成后，向CEO发送极简简报：

【极简简报】
✅ 任务: [任务名称]
📄 产出: [报告路径]
📊 统计: [条目数/字数]
💡 亮点: [一句话核心发现]

### 重要规则

1. 用户直接调用 → 直接执行并汇报
2. CEO派发 → 执行后同时向用户和CEO简报
```

### 2.4 注册到 openclaw.json

在 `agents.list` 中添加情报总监：

```json
{
  "id": "intel-director",
  "name": "情报总监",
  "workspace": "~/.openclaw/workspace-intel-director",
  "agentDir": "~/.openclaw/agents/intel-director/agent",
  "model": {
    "primary": "zai/glm-4",
    "fallbacks": ["zai/glm-4"]
  },
  "heartbeat": {
    "every": "30m",
    "activeHours": {
      "start": "05:00",
      "end": "22:00",
      "timezone": "Asia/Shanghai"
    }
  }
}
```

---

## 三、配置Agent间通信

### 3.1 更新白名单

确保两个Agent都在通信白名单中：

```json
{
  "tools": {
    "sessions": {
      "visibility": "all"
    },
    "agentToAgent": {
      "enabled": true,
      "allow": ["ceo", "secretary", "intel-director", "wechat-manager", "redbook-manager", "ops-director", "product-manager", "tech-lead", "finance-buddy", "investor", "biz-advisor", "knowledge-lib"]
    }
  }
}
```

### 3.2 验证配置

```bash
# 检查配置语法
python3 -m json.tool ~/.openclaw/openclaw.json

# 检查Agent是否注册
cat ~/.openclaw/openclaw.json | grep -E '"ceo"|"intel-director"'
```

### 3.3 重启生效

```bash
openclaw gateway restart
```

---

## 四、测试通信

### 4.1 测试总控路由

在Telegram中向CEOBot发送：

```
帮我抓一下今天的热点
```

CEO应该识别意图，将任务派发给情报总监。

### 4.2 测试直接调用

直接向情报总监Bot发送：

```
抓取今日AI领域热点
```

情报总监应该直接执行并返回报告。

### 4.3 测试简报机制

情报总监完成任务后，检查是否向CEO发送了简报。

---

## 五、部署检查清单

每次添加新Agent后，逐项检查：

```markdown
## Agent部署检查清单

### 目录结构
- [ ] ~/.openclaw/agents/<agentId>/agent/ 已创建
- [ ] ~/.openclaw/workspace-<agentId>/ 已创建

### Agent定义文件
- [ ] config.json — agentId、name、definition已填写
- [ ] SOUL.md — 身份、职责、通信规范已定义
- [ ] models.json — 模型配置（如需独立模型）

### 全局配置
- [ ] agents.list 中已添加Agent条目
- [ ] tools.agentToAgent.allow 中已添加Agent ID
- [ ] tools.sessions.visibility = "all"
- [ ] tools.agentToAgent.enabled = true

### 通信配置
- [ ] config.json中canCommunicateWith已配置
- [ ] 目标Agent的allowAgents中已包含本Agent

### 验证
- [ ] openclaw.json JSON语法正确
- [ ] Gateway已重启
- [ ] Telegram Bot可正常对话
```

---

## 六、扩展更多Agent

按照相同模式，可以快速创建更多专业Agent：

```
1. mkdir -p ~/.openclaw/agents/<新Agent>/agent
2. mkdir -p ~/.openclaw/workspace-<新Agent>
3. 创建 config.json、SOUL.md
4. 在 openclaw.json 的 agents.list 中注册
5. 在 agentToAgent.allow 中添加
6. 重启 Gateway
```

---

## 七、完整目录结构参考

```
~/.openclaw/
├── openclaw.json                 # 主配置
├── agents/
│   ├── ceo/agent/               # CEO
│   │   ├── config.json
│   │   ├── models.json
│   │   └── CEO.md
│   ├── intel-director/agent/     # 情报总监
│   │   ├── config.json
│   │   └── 情报总监.md
│   ├── secretary/agent/          # 小秘 (默认)
│   │   ├── config.json
│   │   └── 小秘.md
│   ├── wechat-manager/agent/     # 公众号主管
│   ├── redbook-manager/agent/    # 小红书主管
│   ├── ops-director/agent/       # 运营总监
│   ├── product-manager/agent/    # 产品经理
│   ├── tech-lead/agent/          # 技术总监
│   ├── finance-buddy/agent/      # 财务管家
│   ├── investor/agent/           # 投资专家
│   ├── biz-advisor/agent/        # 商业顾问
│   └── knowledge-lib/agent/      # 知识管家
├── workspace-ceo/            # CEO工作区
│   ├── SOUL.md
│   ├── USER.md
│   └── AGENTS.md
├── workspace-intel-director/            # 情报总监工作区
│   ├── SOUL.md
│   └── USER.md
└── workspace/                    # 小秘工作区
    ├── SOUL.md
    └── USER.md
```

---

_下一章: [04-Telegram配对流程](./04-Telegram配对流程.md)_
