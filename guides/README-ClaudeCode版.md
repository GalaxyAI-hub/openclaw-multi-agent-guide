# Multi-Agent — 新手指南（Claude Code版）

> 零基础用Claude Code搭建你的AI团队
> 版本: v2.0 | 2026-04-23

---

## 🎯 这个版本适合谁？

✅ 你的电脑上已安装Claude Code
✅ 你不想手动编辑JSON配置文件
✅ 你想快速搭建多Agent系统

---

## 📚 文档说明

| 文档 | 用途 |
|------|------|
| **快速开始-给ClaudeCode发送这条.md** | ⭐ 直接复制发给Claude Code的一条完整指令 |
| **ClaudeCode搭建指南.md** | 分步骤的详细指令，可逐步执行 |
| 01-系统架构总览.md | 了解设计理念和架构（可选） |
| 02-零基础上手指南.md | 手动配置参考（可选） |
| 03-Agent配置详解.md | Agent详细配置说明（可选） |
| 04-Telegram配对流程.md | Telegram Bot详解（可选） |

---

## ⚡ 3分钟上手

### 步骤1：打开Claude Code
启动你电脑上的Claude Code

### 步骤2：复制指令
打开 `快速开始-给ClaudeCode发送这条.md`，复制里面的完整指令

### 步骤3：粘贴发送
把指令粘贴到Claude Code对话窗口，发送

### 步骤4：等待完成
Claude Code会自动执行所有配置，完成后会告诉你

### 步骤5：创建Telegram Bot
按提示在Telegram中创建三个Bot（CEO、情报总监、小秘）

### 步骤6：配置Token
把三个Bot的Token发给Claude Code

### 步骤7：测试
在Telegram中分别向三个Bot发送"你好"测试

---

## 🏗️ 你会得到什么？

完成配置后，你将拥有：

```
┌─────────────────────────────────────┐
│       你的AI团队                     │
├─────────────────────────────────────┤
│  CEO (@ceo_ai_bot)          │
│  → 总控管家，派发任务                │
│                                     │
│  情报总监 (@intel_director_ai_bot)           │
│  → 热点采集、信息追踪               │
│                                     │
│  小秘 (@secretary_ai_bot)            │
│  → 日常聊天、陪伴交流               │
└─────────────────────────────────────┘
```

**使用方式**：
- 向CEO说"抓一下今天的热点" → CEO派给情报总监 → 情报总监执行 → CEO汇总
- 直接向情报总监说"追踪AI行业动态" → 情报总监直接执行
- 向小秘说任何话 → 日常聊天

---

## 🎓 进阶学习

完成基础搭建后，你可以：

1. **添加更多专业Agent**
   - 公众号主管（wechat-manager）- 公众号长文
   - 小红书主管（redbook-manager）- 小红书笔记
   - 运营总监（ops-director）- 增长策略
   - 产品经理（product-manager）- 需求分析
   - 技术总监（tech-lead）- 代码开发
   - 财务管家（finance-buddy）- 收支管理
   - 投资专家（investor）- 投资分析
   - 商业顾问（biz-advisor）- 商业模式
   - 知识管家（knowledge-lib）- 知识归档

2. **配置定时任务**
   - 每天自动抓热点
   - 每周自动生成报告
   - 定时提醒和日程管理

3. **绑定Telegram频道**
   - 自动推送日报到频道
   - 团队协作和通知

4. **阅读架构文档**
   - 了解系统设计理念
   - 学习Agent通信机制
   - 掌握高级配置

---

## 🆘 遇到问题？

### 问题1：Claude Code执行失败
- 检查Claude Code是否有终端访问权限
- 尝试手动执行 `npm install -g openclaw`
- 查看错误信息，发给Claude Code询问

### 问题2：Bot不回复
- 检查Gateway是否运行：`openclaw gateway status`
- 查看日志：`tail -f ~/.openclaw/gateway.log`
- 确认Token是否正确配置

### 问题3：Agent无法通信
- 确认 `tools.sessions.visibility = "all"`
- 确认 `tools.agentToAgent.enabled = true`
- 重启Gateway：`openclaw gateway restart`

---

## 📖 其他版本

如果你**不使用Claude Code**，可以参考手动配置版本：
- `02-零基础上手指南.md` - 手动安装和配置
- `03-Agent配置详解.md` - 手动创建Agent
- `04-Telegram配对流程.md` - 手动配置Telegram

---

## 🚀 开始搭建

打开 `快速开始-给ClaudeCode发送这条.md`，复制指令，开始吧！

---

_基于Multi-Agent V2.5架构实践_
_使用Claude Code，零基础也能快速拥有AI团队！_
