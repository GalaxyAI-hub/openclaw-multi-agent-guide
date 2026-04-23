# Claude Code 搭建指南

> 把这些指令复制给Claude Code，让它帮你完成所有配置

---

## 📌 使用说明

1. 打开Claude Code
2. **逐条复制下面的指令**发送给Claude Code
3. Claude Code会自动执行所有配置操作
4. 如果遇到问题，Claude Code会告诉你如何解决

---

## 第一部分：系统初始化

```
帮我检查一下我的OpenClaw环境，如果没安装就帮我安装。

具体要求：
1. 检查是否安装了openclaw（运行 openclaw --version）
2. 如果没有，执行 npm install -g openclaw
3. 检查openclaw初始化状态
4. 如果没有初始化，运行 openclaw init
5. 最后运行 openclaw doctor 检查环境是否健康
```

---

## 第二部分：配置模型提供商

```
我需要配置一个模型提供商。请帮我：

1. 读取 ~/.openclaw/openclaw.json 文件
2. 如果不存在models配置，帮我创建基础结构
3. 配置智谱AI（GLM）作为示例提供商：
   - baseUrl: https://open.bigmodel.cn/api/coding/paas/v4
   - 我稍后会提供apiKey，先留空或使用占位符 "YOUR_API_KEY_HERE"
   - 添加 glm-4 模型，contextWindow: 128000, maxTokens: 8192
4. 保存文件并确保JSON格式正确

注意：告诉我我会被要求在哪里填写真实的API Key。
```

---

## 第三部分：创建CEO（总控Agent）

```
帮我创建CEOAgent，这是我的多Agent系统的总控管家。请按以下步骤执行：

1. 创建目录结构：
   - ~/.openclaw/agents/ceo/agent/
   - ~/.openclaw/workspace-ceo/

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

3. 创建 ~/.openclaw/agents/ceo/agent/CEO.md（内容如下）：
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
| 写文章/创作 | → wechat-manager |
| 日常聊天 | → secretary (小秘) |

## 通信机制
- 派发任务: sessions_spawn → 目标Agent
- 接收汇报: Agent通过 sessions_send 回传简报

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

4. 创建 ~/.openclaw/workspace-ceo/SOUL.md，引用CEO的身份：
```markdown
# CEO

我是CEO，Multi-Agent系统的总控管家。

核心职责：智能路由、任务编排、Agent协调、Fallback机制。

更多详情请参考 ~/.openclaw/agents/ceo/agent/CEO.md
```

5. 创建 ~/.openclaw/workspace-ceo/USER.md：
```markdown
# USER.md

- **Name:** 用户
- **Timezone:** Asia/Shanghai
- **交互风格:** 简洁直接，汇总汇报
```

6. 创建 ~/.openclaw/workspace-ceo/AGENTS.md：
```markdown
# AGENTS.md

CEO可调用的专业Agent：
- intel-director (情报总监) - 热点采集、选题推荐
- wechat-manager (公众号主管) - 公众号创作
- redbook-manager (小红书主管) - 小红书笔记
- ops-director (运营总监) - 增长策略
- product-manager (产品经理) - 需求分析
- tech-lead (技术总监) - 代码开发
- finance-buddy (财务管家) - 收支管理
- investor (投资专家) - 投资分析
- biz-advisor (商业顾问) - 商业模式
- knowledge-lib (知识管家) - 知识归档
```

完成后告诉我CEOAgent已经创建完成。
```

---

## 第四部分：创建情报总监Agent

```
帮我创建情报总监Agent（intel-director），这是我的情报采集专家。请按以下步骤执行：

1. 创建目录结构：
   - ~/.openclaw/agents/intel-director/agent/
   - ~/.openclaw/workspace-intel-director/

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

4. 创建 ~/.openclaw/workspace-intel-director/SOUL.md：
```markdown
# 情报总监

我是情报总监，负责信息采集和热点追踪。

更多详情请参考 ~/.openclaw/agents/intel-director/agent/情报总监.md
```

5. 创建 ~/.openclaw/workspace-intel-director/USER.md（与CEO相同内容）

6. 创建 ~/.openclaw/workspace-intel-director/AGENTS.md：
```markdown
# AGENTS.md

情报总监可向以下Agent汇报：
- ceo (CEO) - 总控管家
```

完成后告诉我情报总监Agent已经创建完成。
```

---

## 第五部分：注册Agent到全局配置

```
现在我需要把CEO和情报总监注册到OpenClaw的全局配置中。

请执行以下操作：

1. 读取 ~/.openclaw/openclaw.json
2. 在 agents.list 数组中添加两个Agent：

CEO（ceo）：
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

情报总监（intel-director）：
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

3. 确保JSON格式正确，无重复ID

完成后确认两个Agent已注册。
```

---

## 第六部分：启用Agent间通信

```
启用Agent间通信配置，这是多Agent系统能协同工作的关键。

请执行：

1. 读取 ~/.openclaw/openclaw.json
2. 确保或添加以下配置：
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

3. 保存文件

配置说明：
- sessions.visibility = "all" 允许Agent间互相发现
- agentToAgent.enabled = true 启用Agent间通信
- agentToAgent.allow 列出可通信的Agent ID

完成后确认配置已保存。
```

---

## 第七部分：创建Telegram Bot

```
我需要创建三个Telegram Bot，分别对应CEO、情报总监和小秘。

请指导我以下步骤（我会手动在Telegram中执行）：

1. 在Telegram中搜索 @BotFather
2. 向BotFather发送 /newbot
3. 按提示创建第一个Bot（CEO）：
   - Bot名称: 例如 "AICEO"
   - Bot用户名: 例如 "ceo_ai_bot"（必须以bot结尾）
   - 保存返回的Bot Token（格式如：1234567890:ABC...）

4. 重复步骤2-3，创建第二个Bot（情报总监）：
   - Bot名称: 例如 "AI情报总监"
   - Bot用户名: 例如 "intel_director_ai_bot"
   - 保存Token

5. 重复步骤2-3，创建第三个Bot（小秘）：
   - Bot名称: 例如 "AI小秘"
   - Bot用户名: 例如 "secretary_ai_bot"
   - 保存Token

完成后，我会告诉你这三个Bot的Token，请继续下一步配置。

重要提醒：
- 妥善保存Token，不要分享给他人
- 用户名必须以 "bot" 结尾
- 记录哪个Token对应哪个Agent
```

---

## 第八部分：配置Telegram Token

```
我已经创建了三个Telegram Bot，Token如下（请让我在下面填写）：

CEO Token: [请在此处粘贴]
情报总监 Token: [请在此处粘贴]
小秘 Token: [请在此处粘贴]

请执行：

1. 读取 ~/.openclaw/openclaw.json
2. 在 channels.telegram.accounts 中配置三个Bot：

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "accounts": {
        "ceo": {
          "botToken": "CEOToken"
        },
        "intel-director": {
          "botToken": "情报总监Token"
        },
        "secretary": {
          "botToken": "小秘token"
        }
      }
    }
  }
}
```

3. 确保channels.telegram.enabled = true

注意：accounts的键名（ceo, intel-director, secretary）必须与agents.list中的id完全一致。

完成后确认配置已保存。
```

---

## 第九部分：重启并测试

```
现在所有配置都已完成，请帮我：

1. 重启OpenClaw Gateway使配置生效：
   - 运行 openclaw gateway restart
   - 等待启动完成
   - 运行 openclaw gateway status 检查状态

2. 查看日志确认无错误：
   - 运行 tail -20 ~/.openclaw/gateway.log

3. 如果有错误，告诉我错误信息并帮我解决

4. 确认无误后，告诉我在Telegram中测试：
   - 向CEOBot发送"你好"，应该收到CEO的回复
   - 向情报总监Bot发送"你好"，应该收到情报总监的回复
   - 向小秘 Bot发送"你好"，应该收到日常问候
```

---

## 第十部分：测试Agent联动

```
现在测试Agent间的联动功能。

请指导我：

1. 在Telegram中向CEOBot发送：
   "帮我抓一下今天的热点"

2. CEO应该识别这是一个情报采集任务，将其派发给情报总监

3. 情报总监执行任务，生成热点报告

4. 情报总监完成后，应该向CEO发送简报：
```
【极简简报】
✅ 任务: 每日热点抓取
📄 产出: [报告路径]
📊 统计: 10条热点
💡 亮点: [核心发现]
```

5. CEO收到简报后，汇总并向我报告

如果出现问题，请告诉我如何排查（比如查看日志、检查配置等）。
```

---

## 第十一部分：故障排查

```
如果出现问题，请帮我排查：

1. Gateway启动失败：
   - 检查端口占用: lsof -i :18790
   - 检查JSON语法: python3 -m json.tool ~/.openclaw/openclaw.json
   - 查看日志: tail -50 ~/.openclaw/gateway.log

2. Bot不回复：
   - 检查Token是否正确
   - 检查channels.telegram.accounts配置
   - 检查Gateway状态
   - 查看Telegram相关日志: grep -i telegram ~/.openclaw/gateway.log

3. Agent无法通信：
   - 确认tools.sessions.visibility = "all"
   - 确认tools.agentToAgent.enabled = true
   - 确认Agent ID在agentToAgent.allow列表中

4. 模型调用失败：
   - 检查API Key是否正确
   - 检查网络能否访问API地址
   - 检查模型ID格式（应该是 provider/model）

请告诉我具体遇到什么错误，我会帮你解决。
```

---

## 第十二部分：验证完整流程

```
最后，帮我验证整个系统是否正常工作：

1. 检查所有Agent是否正确注册：
   - 运行 cat ~/.openclaw/openclaw.json | grep -E '"id":"ceo"|"id":"intel-director"|"id":"secretary"'

2. 检查Telegram配置：
   - 运行 cat ~/.openclaw/openclaw.json | grep -A 2 "telegram"

3. 检查Agent间通信配置：
   - 运行 cat ~/.openclaw/openclaw.json | grep -A 5 "agentToAgent"

4. 检查Gateway状态：
   - 运行 openclaw gateway status

5. 如果以上都正常，恭喜！多Agent系统搭建完成。

接下来我可以：
- 直接向CEOBot发送任务，它会分派给对应Agent
- 直接向情报总监Bot发送任务，它直接执行
- 在Telegram中与各个Agent对话，就像有不同的团队成员

系统架构回顾：
- CEO（总控）：任务路由和编排
- 情报总监（intel-director）：信息采集
- 小秘（secretary）：日常聊天
```

---

## ✅ 完成！

现在你拥有了一个完整的双Agent+总控的多AI团队！

**下一步可以**：
- 添加更多专业Agent（研究主管、创作者、开发者等）
- 配置定时任务（自动抓热点、生成日报）
- 绑定Telegram频道（自动推送报告到频道）

---

## 📝 常用命令速查

```bash
# 查看Gateway状态
openclaw gateway status

# 重启Gateway
openclaw gateway restart

# 查看实时日志
tail -f ~/.openclaw/gateway.log

# 检查JSON配置
python3 -m json.tool ~/.openclaw/openclaw.json

# 停止Gateway
openclaw gateway stop
```

---

_通过Claude Code搭建，零基础也能快速拥有自己的AI团队！🚀_
