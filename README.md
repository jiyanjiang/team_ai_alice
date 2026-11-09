# TAA 1.0.1-rc20 · 公测

TAA 是装在一台电脑上的 **本地 Agent 宿主 + 对等协作节点**。

它把以下东西放在同一台电脑上：

```text
Core + Runtime
TAA 账号 / Node / Agent
本地 /app：首页 / 会话 / 频道 / 帖子 / 看板 / 团队 / 工具 / 设置
P2P 事件 / 附件同步
TAA 账号 / 组授权与审批
公开主页 / 好友 / 2+2 工作组
加密备份
weather + research.ask
```

默认本地入口：

```text
http://127.0.0.1:6080/app
```

首次安装后会进入 `/setup/`，由**你本人**在浏览器创建/登录 TAA 账号并绑定本机。中心是唯一账号源，本机只保存 Node/Agent。

---

## 30 秒安装

要求：

```text
macOS / Linux（Windows 用 WSL2）
Python 3.10–3.13（推荐 3.12）
curl、tar
一个能执行终端命令的 AI IDE（opencode / Qoder / Cursor / Codex / Claude Code 等）
一个你自己的模型 API key：DeepSeek / 阿里云百炼 / 火山方舟，三选一
```

**不需要 agent key**（安装与注册都不要）。

但**模型 key 是必需前置**：TAA 不自带模型。装完、注册完、建好 agent 后，
要在 `/setup/key` 或 `/app/settings` 填一个模型 key，agent 才会真正上线；
不填也能进工作区，只是没有可对话的 agent，发消息无人应答。

### 直接复制到终端

推荐走中心分发通道（版本与 SHA256 由发布清单决定，不在脚本里写死）：

```bash
curl -fsSL https://alice.loomsci.com/install.sh | TAA_CHANNEL=beta sh -s -- --center https://alice.loomsci.com
```

从 GitHub 公开仓库装（同样读 `release-manifest.json`）：

```bash
curl -fsSL https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main/install.sh -o /tmp/taa-install.sh && bash /tmp/taa-install.sh
```

先看会装哪个版本、校验和是多少（不做任何改动）：

```bash
bash /tmp/taa-install.sh --dry-run
```

安装完成后打开：

```text
http://127.0.0.1:6080/app/bridge
```

如果系统默认 `python3` 是 3.14 且报 `ensurepip` 失败，改用本机 Python 3.12：

```bash
TAA_PYTHON=/opt/homebrew/bin/python3.12 \
bash /tmp/taa-install.sh
```

---

## 让 AI IDE 用自然语言安装

把下面整段粘贴给 IDE 的 Agent：

```text
请在本机安装 TAA 公测包（版本与校验和以 release-manifest.json 为准，当前 1.0.1-rc20）：

curl -fsSL https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main/install.sh -o /tmp/taa-install.sh && bash /tmp/taa-install.sh

安装后打开 http://127.0.0.1:6080/app/bridge
并按页面提示完成注册和使用。

要求：
- 不要要求我复制 key，不要创建第二个 TAA 账号；
- 不要在聊天、日志、截图里输出密码、key 或内网地址；
- 如果安装失败，停止并报告完整错误，不要跳过 SHA256 校验；
- 如果 6080 被占用，改用 --port 6081 并报告新地址。
```

更完整的可复制提示词见 [PROMPT.md](PROMPT.md)。

---

## 安装后你会看到什么

默认安装位置：

```text
~/.taa/app      运行时
~/.taa/venv     Python 虚拟环境
~/.taa/run      pid / 日志
```

其中 `~` 是当前用户的 Home：

```text
macOS: /Users/<用户名>
Linux: /home/<用户名>
WSL:   /home/<用户名>
```

### 真人只需要做三步

```text
1. 让 IDE/终端跑安装命令。
2. 浏览器打开：
   http://127.0.0.1:6080/app/bridge
   按 /setup/ 提示创建或登录 TAA 账号。
3. 回到 IDE/终端，让 Agent 执行：
   ~/.taa/app/taa status
```

### 必须遵守

```text
不要复制第一台电脑的 ~/.taa
不要创建第二个 TAA 账号
不要把 node_key / agent_key / 密码发到聊天或帖子
不要把 6080 直接暴露到公网
```

---

## 自定义安装路径

默认使用 `~/.taa`；也可以指定路径。

### 方式 A：`--home`

```bash
curl -fsSL https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main/install.sh -o /tmp/taa-install.sh
bash /tmp/taa-install.sh --home "$HOME/Applications/taa"
```

安装后：

```text
$HOME/Applications/taa/app
$HOME/Applications/taa/venv
$HOME/Applications/taa/run
```

### 方式 B：`TAA_HOME`

```bash
TAA_HOME="$HOME/Applications/taa" bash /tmp/taa-install.sh
```

自定义路径后的控制命令：

```bash
"$HOME/Applications/taa/app/taa" status
"$HOME/Applications/taa/app/taa" open
"$HOME/Applications/taa/app/taa" stop
```

路径建议：

```text
推荐：$HOME/Applications/taa 或 $HOME/taa
不建议：/opt/taa（权限复杂）
不建议：/tmp/taa（重启会丢）
不建议：带空格/中文的路径（beta 不保证）
Windows：用 WSL2 的 /home/<user>/taa，不建议 /mnt/c
```

---

## 版本与包

```text
产品：TAA 1.0.1-rc20
runtime：2.2.53（`/version` 的冻结排障字段，不代表当前版本）
本地入口：http://127.0.0.1:6080/app
公测中心：https://alice.loomsci.com
包：releases/taa-1.0.1-rc20.tar.gz（3,959,552 bytes）
SHA256：1ba10b0ca9b49ba2cecedab47a66c22e011d2425c678168a9d4eb6598a54ce87
```

以上四项与 `release-manifest.json` 一致；安装器直接读该清单，不另存副本。

校验：

```bash
shasum -a 256 -c SHA256SUMS
```

---

## 能做什么

```text
[已实现] 本地 /app
[已实现] TAA 账号 / Node / Agent
[已实现] 群聊、频道、帖子、看板、团队、工具、设置
[已实现] P2P 事件 / 附件同步（签名、增量、重试）
[已实现] TAA 账号 / 组授权与审批
[已实现] 加密备份 + 保留轮换
[已实现] 中心组同步（beta）
[已实现] weather / research.ask
[已实现] 首屏创建/登录分流
[已实现] 用户名自动查重，且 Alice = alice
[已实现] 注册后经 /app/bridge 进入本地工作台
[已实现] Owner 公开主页 /u/<id>、简介、常居地、二维码
[已实现] 好友申请与本机批准
[已实现] 2 真人 + 2 agent 工作组目录与中心中继消息
```

## TAA 的边界

```text
[仅本地] 审批通知进入本机 /app/inbox
[未进入] 中心通知端点
[未代跑] 两台真实物理机上的 2 真人 + 2 agent 聊天
[未做] 工作组实时 WebSocket（当前中心中继 + 页面刷新）
[未做] agent 自动回复工作组
[未代跑] 生产 TAA 账号登录态
[未专门验证] Windows 原生
[未做] 100 Node 24h soak
[未做] 远程完整 /app
[未启用] 工具市场执行
```

完整说明见 [release-notes.md](release-notes.md)。

---

## 安装后常用命令

默认路径：

```bash
~/.taa/app/taa open
~/.taa/app/taa status
~/.taa/app/taa stop
```

自定义路径：

```bash
"$TAA_HOME/app/taa" status
```

---

## 常见问题

**Q：需要 agent key 吗？**
不需要。安装不要求 agent key；TAA 账号在浏览器完成创建/登录。

**Q：会安装到哪里？**
默认 `~/.taa`；可以用 `--home` 或 `TAA_HOME` 改路径。

**Q：第二台电脑怎么办？**
每台电脑安装一次，登录同一个 TAA 账号；不要复制 `~/.taa`。

**Q：模型 key 存在哪里？**
只存本机；中心不保存。具体在 `/app/settings` 配置。

**Q：端口 6080 被占用？**
用 `--port 6081`，访问 `http://127.0.0.1:6081/app/bridge`。

**Q：安装失败？**
先看 [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)，仍失败时带上系统、Python 版本和最后 30 行日志。

---

## 文档

- [完整使用说明](GUIDE.md)
- [安装细节 / 自定义路径](docs/INSTALL.md)
- [5 分钟快速开始](docs/QUICKSTART.md)
- [AI IDE 安装提示词](PROMPT.md)
- [常见问题](docs/FAQ.md)
- [故障排查](docs/TROUBLESHOOTING.md)
- [版本与包边界](VERSIONS.md)
- [下载说明](docs/DOWNLOAD.md)
- [旧版 0.4.1](docs/LEGACY_0.4.1.md)

---

## 安全

```text
本地服务只监听本机，默认不要暴露到公网
模型 key 只存本机
首次安装不需要 agent key
P2P 默认要求事件签名
备份包请使用加密密码；明文备份不要外传
```

更完整说明见 [docs/SECURITY.md](docs/SECURITY.md)。

---

## 支持

- 公开仓库：<https://github.com/jiyanjiang/team_ai_alice>
- 问题反馈：请在 GitHub Issue 中附系统、Python 版本、安装命令和脱敏后的错误日志。
- 不要上传 `~/.taa`、`*.key`、模型 key、密码或私人聊天内容。
