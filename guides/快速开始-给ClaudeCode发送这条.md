# 一条指令搞定全部配置

> 直接复制这条消息发送给Claude Code，它会帮你完成所有配置

---

## 📋 完整搭建指令

```
我要搭建一个多Agent系统，包括CEO（总控）和情报总监两个Agent，并配置Telegram Bot。请帮我完成以下所有步骤：

## 第一部分：环境准备
1. 检查是否安装了openclaw（运行 openclaw --version），如果没有就执行 npm install -g openclaw
2. 检查openclaw初始化状态，如果没有就运行 openclaw init
3. 运行 openclaw doctor 检查环境健康

## 第二部分：配置模型
1. 读取 ~/.openclaw/openclaw.json
2. 配置智谱AI（GLM）作为模型提供商：
   - baseUrl: https://open.bigmodel.cn/api/coding/paas/v4
   - 先用占位符 "YOUR_API_KEY_HERE" 作为apiKey（我会稍后替换）
   - 添加 glm-4 模型，contextWindow: 128000, maxTokens: 8192

## 第三部分：创建CEOAgent
1. 创建目录：~/.openclaw/agents/ceo/agent/ 和 ~/.openclaw/workspace-ceo/
2. 创建 ~/.openclaw/agents/ceo/agent/config.json：
```json
{
  "agentId": "ceo",
  "name": "CEO",
  "nameEn": "Polaris",
  "definition": "CEO.md",
  "canCommunicateWith": ["secretary", "intel-director"],
  "enabled": true,
  "createdAt": "2026-04-23",
  "version": "1.0.0"
}
```
3. 创建 ~/.openclaw/agents/ceo/agent/CEO.md：
```markdown
# CEO - 总控管家

## 核心身份
你是AI团队的总控管家。负责理解用户意图，将任务分发给专业Agent。

## 核心职责
1. 智能路由 — 理解用户意图，分发任务
2. 任务编排 — 派发任务、收集简报
3. Agent协调 — 通过 sessions_spawn 与专业Agent通信
4. Fallback — Agent失败时接管处理

## 路由规则
| 关键词 | 路由目标 |
|--------|----------|
| 热点/日报/新闻 | → intel-director |
| 写文章/创作 | → wechat-manager |
| 日常聊天 | → secretary (小秘) |

## 通信机制
- 派发任务: sessions_spawn → 目标Agent
- 接收汇报: Agent通过 sessions_send 回传简报

## 简报格式
收到Agent简报后，汇总为：
📋 任务完成汇总：
✅ Agent名: 简要描述
📄 详细内容请查看产出文件。

## 沟通风格
简洁高效，不啰嗦。极简简报，避免重复。
```
4. 创建 ~/.openclaw/workspace-ceo/SOUL.md 和 USER.md（基础内容）

## 第四部分：创建情报总监Agent
1. 创建目录：~/.openclaw/agents/intel-director/agent/ 和 ~/.openclaw/workspace-intel-director/
2. 创建 ~/.openclaw/agents/intel-director/agent/config.json：
```json
{
  "agentId": "intel-director",
  "name": "情报总监",
  "nameEn": "Watcher",
  "definition": "情报总监.md",
  "canCommunicateWith": ["secretary", "ceo"],
  "enabled": true,
  "createdAt": "2026-04-23",
  "version": "1.0.0"
}
```
3. 创建 ~/.openclaw/agents/intel-director/agent/情报总监.md：
```markdown
# 情报总监 - 首席信息官

## 角色定位
你是团队的情报总监，负责热点采集和信息追踪。

## 核心职责
1. 每日热点抓取 — 搜索今日热点，输出结构化报告
2. 信息追踪 — 追踪指定主题的最新动态
3. 竞品分析 — 按需分析竞品信息

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
微博热搜、知乎热榜、36Kr、GitHub Trending

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
4. 创建 ~/.openclaw/workspace-intel-director/SOUL.md 和 USER.md

## 第五部分：注册Agent到全局配置
1. 读取 ~/.openclaw/openclaw.json
2. 在 agents.list 中添加CEO和情报总监的配置：
```json
{
  "id": "ceo",
  "default": false,
  "name": "CEO",
  "workspace": "~/.openclaw/workspace-ceo",
  "agentDir": "~/.openclaw/agents/ceo/agent",
  "model": {
    "primary": "zai/glm-4",
    "fallbacks": ["zai/glm-4"]
  }
}
```
```json
{
  "id": "intel-director",
  "default": false,
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

## 第六部分：启用Agent间通信
在 openclaw.json 中配置：
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

## 第七部分：重启Gateway
1. 运行 openclaw gateway restart
2. 检查状态: openclaw gateway status
3. 查看日志: tail -20 ~/.openclaw/gateway.log

完成后告诉我，我会继续配置Telegram Bot。
```

---

## 📝 然后配置Telegram Bot（在Claude Code执行完成后）

在Telegram中手动创建三个Bot：

1. 搜索 @BotFather
2. 发送 `/newbot`
3. 创建CEOBot：
   - 名称: "AICEO"
   - 用户名: "ceo_ai_bot"（必须以bot结尾）
   - 保存Token

4. 创建情报总监Bot：
   - 名称: "AI情报总监"
   - 用户名: "intel_director_ai_bot"
   - 保存Token

5. 创建小秘 Bot：
   - 名称: "AI小秘"
   - 用户名: "secretary_ai_bot"
   - 保存Token

---

## 🔗 最后把Token发给Claude Code

```
我已经创建了三个Telegram Bot，Token如下：

CEO Token: [粘贴Token]
情报总监 Token: [粘贴Token]
小秘 Token: [粘贴Token]

请帮我配置到 openclaw.json 的 channels.telegram.accounts 中。
```

---

**就这么简单！一条指令搞定！** 🚀
