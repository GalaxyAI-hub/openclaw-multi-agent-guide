# 快速开始 - 安装推荐Skills

> 最少配置，最快上手

---

## ⚡ 5分钟核心安装

### 步骤1：安装基础搜索和记忆（必装）

```bash
# 高质量网络搜索
openclaw skill install tavily-search

# 向量知识库（长期记忆）
openclaw skill install memory-lancedb-pro
```

**作用**:
- 让Agent能上网搜索实时信息
- 让Agent能记住你说过的话

---

### 步骤2：安装内容创作（选装）

如果你运营**公众号**：
```bash
openclaw skill install wechat-article-pro
openclaw skill install humanizer
```

如果你运营**小红书**：
```bash
openclaw skill install redbook-maker
openclaw skill install humanizer
```

**作用**:
- 让Agent能写公众号/小红书内容
- 让AI写的文字更自然、不像AI

---

### 步骤3：安装Agent协作（推荐）

```bash
# Agent任务编排
openclaw skill install multi-agent-pipeline

# Agent自主决策
openclaw skill install agent-autonomy-kit
```

**作用**:
- 让多个Agent配合完成复杂任务
- 让Agent更智能、少问你

---

## ✅ 安装完成后的检查

```bash
# 查看已安装的Skills
openclaw skill list
```

你应该看到类似输出：
```
Installed Skills:
- tavily-search ✓
- memory-lancedb-pro ✓
- wechat-article-pro ✓
- humanizer ✓
- multi-agent-pipeline ✓
- agent-autonomy-kit ✓
```

---

## 🔧 简单配置

### 1. 配置Tavily搜索

```bash
# 获取API Key（免费）
# 访问: https://tavily.com/

# 配置
openclaw config set skills.tavily-search.apiKey "your_api_key_here"
```

### 2. 启用Skills

```bash
# 启用所有安装的Skills
openclaw skill enable --all

# 重启Gateway
openclaw gateway restart
```

---

## 🎯 测试Skills

### 测试1：搜索功能

向CEO Bot发送：
```
搜索今天AI领域的热点
```

### 测试2：内容创作

向公众号主管Bot发送：
```
写一篇关于"AI工具提升效率"的公众号文章
```

### 测试3：Agent协作

向CEO Bot发送：
```
让情报总监抓热点，然后让公众号主管根据热点写一篇文章
```

---

## 📖 完整Skill清单

查看所有推荐的Skills：

- [RECOMMENDED-SKILLS.md](./RECOMMENDED-SKILLS.md) - 完整清单和详细说明

---

## 🆘 常见问题

### Q: 技能安装失败？

```bash
# 检查网络
ping clawhub.ai

# 查看详细错误
openclaw skill install tavily-search --verbose
```

### Q: 技能不生效？

```bash
# 检查是否启用
openclaw skill list

# 查看日志
tail -f ~/.openclaw/gateway.log
```

---

_快速上手 v1.0_
