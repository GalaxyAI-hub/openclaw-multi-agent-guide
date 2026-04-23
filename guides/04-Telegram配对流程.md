# 04 - Telegram配对流程

> 创建Bot、配置Token、绑定Agent

---

## 一、创建Telegram Bot

### 1.1 打开BotFather

在Telegram中搜索 `@BotFather`，这是Telegram官方的Bot管理工具。

### 1.2 创建新Bot

1. 向 @BotFather 发送 `/newbot`
2. 按提示输入Bot名称（用户可见）
   - 示例：`AICEO` 或 `Polaris Bot`
3. 按提示输入Bot用户名（必须以 `bot` 结尾）
   - 示例：`ceo_ai_bot` 或 `my_team_bot`
4. BotFather会返回一个 **Bot Token**

**重要**：请妥善保存Token，格式如：`1234567890:ABCdefGHIjklMNOpqrsTUVwxyz`

### 1.3 记录关键信息

| 信息 | 说明 | 示例 |
|------|------|------|
| **Bot用户名** | 用于搜索Bot | `@ceo_ai_bot` |
| **Bot Token** | 用于OpenClaw配置 | `1234567890:ABC...` |
| **Bot名称** | 显示在聊天窗口 | `AICEO` |

---

## 二、配置每个Agent的Bot

为每个Agent（总控、情报总监、小秘等）创建独立的Bot。

### 2.1 多Bot示例

| Agent | Bot用户名 | Token | 用途 |
|-------|-----------|-------|------|
| `ceo` | `@ceo_ai_bot` | `token1` | 总控任务派发 |
| `intel-director` | `@intel_director_ai_bot` | `token2` | 情报任务执行 |
| `secretary` | `@secretary_ai_bot` | `token3` | 日常聊天 |

### 2.2 配置到 openclaw.json

编辑 `~/.openclaw/openclaw.json`，在 `channels.telegram.accounts` 下为每个Agent配置Token：

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "accounts": {
        "ceo": {
          "botToken": "1234567890:ABCdefGHIjklMNOpqrsTUVwxyz"
        },
        "intel-director": {
          "botToken": "0987654321:ZYXwvutsrqPONMLKjihgFEDcba"
        },
        "secretary": {
          "botToken": "1112223333:TOKEN_FOR_小秘_HERE"
        }
      }
    }
  }
}
```

**注意**：
- `accounts` 的键名必须与 `agents.list` 中的 `id` 完全一致
- 不要分享Token给任何人

---

## 三、启动并测试

### 3.1 重启Gateway使配置生效

```bash
openclaw gateway restart
```

### 3.2 测试每个Bot

在Telegram中分别向每个Bot发送 `你好`：

1. **CEOBot** (`@ceo_ai_bot`) → 应该回复总控问候
2. **情报总监Bot** (`@intel_director_ai_bot`) → 应该回复情报总监问候
3. **小秘 Bot** (`@secretary_ai_bot`) → 应该回复日常问候

### 3.3 查看日志排查问题

```bash
# 实时查看Gateway日志
tail -f ~/.openclaw/gateway.log

# 查找Telegram相关错误
grep -i "telegram" ~/.openclaw/gateway.log | tail -20
```

---

## 四、Bot高级配置

### 4.1 设置Bot头像和简介

向 @BotFather 发送 `/setuserpic` 或 `/setdescription`，按提示设置：

- **头像**: 上传Bot头像图片
- **简介**: "我是AI团队的Agent，帮你处理..."

### 4.2 设置命令菜单

向 @BotFather 发送 `/setcommands`，为Bot添加快捷命令：

```
help - 查看帮助
status - 查看系统状态
task - 查看待办事项
```

### 4.3 禁用内联模式（可选）

如果不希望Bot在群聊中被@触发，向 @BotFather 发送 `/setinline` 并关闭。

---

## 五、频道绑定（进阶）

如果需要Agent将报告推送到Telegram频道/群组：

### 5.1 创建频道或群组

在Telegram中创建一个频道（用于广播）或群组（用于讨论）。

### 5.2 将Bot添加为管理员

1. 打开频道/群组设置
2. 进入"管理员" → "添加管理员"
3. 搜索你的Bot用户名（如 `@ceo_ai_bot`）
4. 添加为管理员，权限选择"发送消息"

### 5.3 获取频道ID

方法1：通过BotFather
```
1. 向Bot发送任意消息
2. 访问 https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates
3. 找到 "chat":{"id":-1001234567890}
```

方法2：通过第三方Bot
```
1. 将第三方Bot（如 @GetMyIdBot）添加到频道
2. 在频道中向它发送消息
3. 它会返回频道ID
```

### 5.4 配置推送目标

在Agent的工作区创建 `CHANNELS.md`：

```markdown
# Telegram频道配置

| 用途 | 频道ID | 说明 |
|------|--------|------|
| 日报推送 | -1001234567890 | 每日AI日报 |
| 任务通知 | -1000987654321 | 任务完成提醒 |
```

### 5.5 在Agent中使用

Agent可以通过以下方式推送消息：

```javascript
// 使用 sessions_send 推送到指定频道
{
  "tool": "sessions_send",
  "parameters": {
    "message": "📋 今日热点报告已生成",
    "channelId": "-1001234567890"
  }
}
```

---

## 六、多用户访问（可选）

如果需要多个团队成员访问同一个Agent：

### 6.1 设置为群组Bot

向 @BotFather 发送 `/setjoingroups` 启用群组加入功能。

### 6.2 添加到工作群组

将Bot添加到团队Telegram群组，所有群成员都可以与Bot交互。

### 6.3 访问控制（进阶）

如果需要限制谁能访问，可以在Agent的SOUL.md中添加：

```markdown
## 访问控制

- 允许用户: @user1, @user2
- 拒绝用户: @spammer
- 群组限制: 仅限指定群组
```

---

## 七、故障排查

### 7.1 Bot不回复消息

**检查项**：
- [ ] Gateway是否运行 (`openclaw gateway status`)
- [ ] Token是否正确配置
- [ ] 日志中是否有错误 (`tail -f ~/.openclaw/gateway.log`)
- [ ] 网络是否能访问Telegram API

**常见错误**：
```
Error: 401 Unauthorized
→ Token错误，检查配置

Error: 409 Conflict
→ Bot名称已被占用，换个名字

Error: 429 Too Many Requests
→ 请求过快，等待几分钟
```

### 7.2 Bot无法加入群组

**检查项**：
- [ ] 是否启用了群组功能 (`/setjoingroups`)
- [ ] Bot是否被设置为管理员
- [ ] 群组隐私设置是否允许Bot

### 7.3 消息推送失败

**检查项**：
- [ ] Bot是否为频道/群组管理员
- [ ] 频道ID是否正确（负数）
- [ ] 日志中是否有推送错误

---

## 八、配置检查清单

```markdown
## Telegram配置检查清单

### Bot创建
- [ ] 已向 @BotFather 创建所有需要的Bot
- [ ] 已保存每个Bot的Token
- [ ] Bot用户名已记录

### 配置文件
- [ ] openclaw.json 中 channels.telegram.enabled = true
- [ ] channels.telegram.accounts 中已配置所有Agent的Token
- [ ] accounts 键名与 agents.list 中的 id 一致

### Gateway
- [ ] Gateway已重启使配置生效
- [ ] Gateway状态正常 (`openclaw gateway status`)
- [ ] 日志中无Telegram相关错误

### 测试
- [ ] 每个Bot都可以独立对话
- [ ] Bot回复符合Agent身份
- [ ] 消息推送到频道/群组正常（如已配置）
```

---

## 九、最佳实践

1. **每个Agent独立Bot** — 避免混淆，便于任务路由
2. **使用友好的Bot名称** — 让用户一眼能认出功能
3. **设置Bot头像** — 提升专业度
4. **配置帮助命令** — 帮助新用户快速上手
5. **定期检查日志** — 及时发现和解决问题
6. **保护Token安全** — 不要提交到公开仓库

---

## 十、参考链接

- [Telegram Bot文档](https://core.telegram.org/bots/api)
- [BotFather命令](https://core.telegram.org/bots#botfather)
- [OpenClaw文档](https://docs.openclaw.ai)

---

_至此，你的多Agent系统已完全搭建完成！🎉_
