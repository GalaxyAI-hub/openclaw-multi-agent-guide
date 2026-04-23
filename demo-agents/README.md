# Demo Agent 配套文件

> ⚠️ 这是Demo示例文件，请根据实际情况修改
> 面向自媒体博主 / 一人公司场景

---

## 📋 Agent 清单（12个）

| # | ID | 名称 | 定位 | 场景 |
|---|---|---|---|---|
| 1 | `ceo` | CEO | 统领全局、智能路由 | 所有任务的入口 |
| 2 | `secretary` | 小秘 | 日程+聊天陪伴 | "今天有什么安排" |
| 3 | `intel-director` | 情报总监 | 热点情报 | "今天有什么热点" |
| 4 | `wechat-manager` | 公众号主管 | 公众号创作 | "写一篇公众号" |
| 5 | `redbook-manager` | 小红书主管 | 小红书运营 | "写小红书笔记" |
| 6 | `ops-director` | 运营总监 | 增长策略 | "怎么涨粉" |
| 7 | `product-manager` | 产品经理 | 需求分析 | "分析需求" |
| 8 | `tech-lead` | 技术总监 | 技术开发 | "写代码" |
| 9 | `finance-buddy` | 财务管家 | 收支管理 | "本月收支" |
| 10 | `investor` | 投资专家 | 投资分析 | "分析股票" |
| 11 | `biz-advisor` | 商业顾问 | 战略智囊 | "这个项目值不值" |
| 12 | `knowledge-lib` | 知识管家 | 知识管理 | "帮我整理笔记" |

---

## 🏗️ 双总Agent架构

```
CEO（总控） + 小秘（日程+陪伴） = 双总体系
```

- **CEO**：智能路由、任务编排、Fallback、定时任务
- **小秘**：日程管理、聊天陪伴、与所有Agent同步日程

---

## 📁 使用方式

### 方式1：用Claude Code部署

复制以下指令给Claude Code：

```
请帮我把demo-agents目录下的所有Agent文件部署到OpenClaw。

具体操作：
1. 为每个Agent创建目录：
   ~/.openclaw/agents/<agentId>/agent/
   ~/.openclaw/workspace-<agentId>/

2. 将 demo-agents/<agentId>/ 下的文件复制到对应目录

3. 在 ~/.openclaw/openclaw.json 的 agents.list 中注册所有Agent

4. 配置 agentToAgent.allow 包含全部12个Agent ID

5. 重启 Gateway
```

### 方式2：手动部署

1. 复制每个Agent目录到 `~/.openclaw/agents/<agentId>/agent/`
2. 创建工作区 `~/.openclaw/workspace-<agentId>/`
3. 复制 SOUL.md、USER.md 等到工作区
4. 在 openclaw.json 中注册
5. 重启 Gateway

---

## ⚠️ 注意事项

- 所有文件均为Demo示例，需要根据实际情况修改
- USER.md 中的个人信息请替换为你自己的
- API Key使用占位符，需要替换为真实Key
- Telegram Bot Token需要自行创建并配置

---

_Demo Agent模板 v1.0 | 2026-04-23_
