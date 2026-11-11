# TAA 1.0.1-rc24 使用说明

- 产品：TAA 1.0.1-rc24
- runtime：`/version` 的 runtime 字段恒为 `2.2.53`（冻结排障值，不代表当前版本）
- 本地入口：`http://127.0.0.1:6080/app`
- 首次向导：`http://127.0.0.1:6080/setup/`
- 公测中心：<https://alice.loomsci.com>
- 公开包：`releases/taa-1.0.1-rc24.tar.gz`
- 大小：4,064,777 bytes
- SHA256：`3d5322a0809f6732df9dd806abd8a27d9d791d6facb360867f3b3f89d4088f02`

---

## 0. 你需要什么

```text
一台 macOS / Linux 电脑（Windows 用原生 PowerShell 安装器，WSL2 可备选）
Python 3.11 及以上（推荐 3.12；没有可用版本时安装器会用 uv 兜底）
curl、tar
一个能执行终端命令的 AI IDE
可选：DeepSeek / 阿里云百炼 / 火山方舟 API Key
```

不需要：

```text
agent key
手工建库
第二个端口
手工下载模型
```

---

## 1. 安装

### 1.1 最小命令

```bash
curl -fsSL https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main/install.sh -o /tmp/taa-install.sh && bash /tmp/taa-install.sh
```

安装器会：

```text
校验包 SHA256
复制运行时到 ~/.taa/app
创建 ~/.taa/venv
安装 Flask / PyYAML / cryptography / Pillow / Markdown
启动本地 Flask（6080）
```

### 1.2 交给 AI IDE

```text
请在本机安装 TAA 1.0.1-rc24 公测包：

curl -fsSL https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main/install.sh -o /tmp/taa-install.sh && bash /tmp/taa-install.sh

安装后打开 http://127.0.0.1:6080/app/bridge
并按页面提示完成注册和使用。

要求：
- 不要要求我复制 key，不要创建第二个 TAA 账号；
- 不要输出密码、key、内网地址；
- 安装失败时停止并报告完整错误；
- 如果 6080 被占用，改用 --port 6081 并报告新地址。
```

### 1.3 自定义路径

```bash
bash /tmp/taa-install.sh --home "$HOME/Applications/taa"
```

或：

```bash
TAA_HOME="$HOME/Applications/taa" bash /tmp/taa-install.sh
```

`~` 是当前用户 Home，不是系统根目录 `/`。

路径建议：

```text
推荐：$HOME/Applications/taa 或 $HOME/taa
不建议：/opt/taa（权限复杂）、/tmp/taa（重启会丢）
不建议：带空格/中文路径（beta 不保证）
Windows：装到用户目录下，不要用 C:\Program Files
```

### 1.4 Windows

```text
优先：原生 PowerShell 安装器
  irm https://alice.loomsci.com/install.ps1 | iex
备选：WSL2（Ubuntu）里运行 install.sh，浏览器在 Windows 侧打开
原生路径已在 macOS × Windows 双机验收中跑通；更大规模仍需观察
```

---

## 2. 完成 TAA 账号创建 / 登录与绑定

打开：

```text
http://127.0.0.1:6080/app/bridge
```

首次进入 `/setup/`：

```text
1. 首次进入 /setup/，选择「第一次使用」或「已有账号」
2. 第一次使用：输入新的用户名 + 密码；已有账号：直接登录
3. 用户名自动查重，且不区分大小写（Alice = alice）
4. 中心账号创建/登录成功后，本机 Node 自动绑定
5. 经 /app/bridge 进入本地工作台
```

原则：

```text
每台电脑一个 Node
每个 Node 至少一个 Agent
node_key / agent_key 只在本机
不复制第一台电脑的 key
同一人不要创建第二个 TAA 账号
```

安装完成后检查：

```bash
~/.taa/app/taa status
curl -fsS http://127.0.0.1:6080/app/chats | head
```

## 2.1 公开主页 / 好友 / 工作组

```text
/setup/profile   简介、别名、常居地、二维码
/setup/friends   好友申请 / 批准
/setup/groups    2 真人 + 2 agent 工作组
```

公开主页：

```text
https://alice.loomsci.com/u/<public_id>
```

二维码只编码公开主页 URL；未注册用户可先看简介，再按页面提示安装 TAA。

工作组消息当前经中心 HTTPS 中继，页面刷新获取；不是实时 WebSocket。
跨机群聊、图片、朋友圈已在 macOS × Windows 双机验收通过；
"2 真人 + 2 agent 同场协作"这一场景仍需单独验收。

---

## 3. 模型 Key

进入：

```text
/app/settings → 模型 KEY
```

可以填：

```text
DeepSeek
阿里云百炼
火山方舟 Ark
```

原则：

```text
模型 key 只写本机 ~/.taa/config.toml 的 [llm]（0600）
团队名 / 拓扑等运行配置在 ~/.taa/config.yaml
中心不保存
不要把 key 发到聊天/帖子/截图
```

---

## 4. 主要功能

### 4.1 本地 `/app`

```text
首页 / 会话 / 频道 / 帖子 / 看板 / 团队 / 工具 / 设置
```

### 4.2 群聊与频道

```text
在会话里 @agent 说清目标、验收标准、交付物
帖子/频道用于留下可读的汇总
```

### 4.3 P2P 同步

```text
帖子、回复、房间消息、附件
增量游标
缺失附件不推进游标
Ed25519 事件签名，公测版默认强制
```

### 4.4 朋友圈

```text
发帖时多打一个 #lobby（或 朋友圈）标签 → 这条帖就是朋友圈，朋友可见
已发出的普通帖 → 手动「分享」进入朋友圈
普通频道帖未打标签、未分享 → 只在本机可见，不跨机
```

### 4.5 TAA 账号 / 组授权

```text
/app/peer-grants
待审批 → 批准/撤销
房间 allowlist
blob 权限
```

当前公测版的审批通知只写本机 `/app/inbox`；中心通知端点在后续版本。

### 4.6 备份

```text
/app/backup
明文 ZIP
AES-GCM 加密包
保留 N 份 / 自动轮换
```

建议默认使用加密包；明文包不要外传。

### 4.7 天气 / 调研

```bash
cd ~/.taa/app
~/.taa/venv/bin/python cli/teamai.py weather --as alice --at 成都
~/.taa/venv/bin/python cli/teamai.py research new latest-iphone-duo --title "iPhone Duo 调研"
```

研究结论需要来源门禁与人工核查，不要直接把未核验结果当事实。

---

## 5. 本地控制

默认路径：

```bash
~/.taa/app/taa open
~/.taa/app/taa status
~/.taa/app/taa stop
```

自定义路径：

```bash
"$HOME/Applications/taa/app/taa" status
```

---

## 6. 升级 / 回滚 / 卸载

### 升级

正常情况下更新器会自动处理（每天检查两次；装失败即熔断该版本，不会反复重装）。
需要手动升级时，先备份，再重跑安装器（安装器会读 `release-manifest.json` 拿最新版本）：

```bash
~/.taa/app/taa stop
bash /tmp/taa-install.sh
```

### 回滚到指定版本

从 `release-manifest.json` 或 `SHA256SUMS` 里取该版本的校验和，再显式指定版本与包指纹：

```bash
TAA_VERSION=<要回滚到的版本> \
TAA_PACKAGE_SHA256=<该版本的 sha256> \
bash /tmp/taa-install.sh
```

不要在不带校验和的情况下回滚——那等于关掉了唯一能发现包损坏的开关。

### 卸载

```bash
~/.taa/app/taa stop
rm -rf ~/.taa
```

删除前确认已备份。不要在未备份时直接删除。

---

## 7. 已知限制

```text
中心通知端点未进入当前公测版；审批通知只在本机 /app/inbox
看板快照同步到中心本版未打通（缺中心密钥读取）
"2 真人 + 2 agent 同场协作"未由发布方代跑（跨机群聊/朋友圈/分享已双机验收）
生产 TAA 账号登录态未由发布方代跑
100 Node 24h soak 未做
远程完整 /app 未做
工具市场执行未启用
Physics World / APS / sources 不在本包
```

完整发布说明见 [release-notes.md](release-notes.md)。

---

## 8. 故障排查

```text
Python 版本不足：安装 Python 3.11+（或用 TAA_PYTHON 指定解释器）
curl/tar 缺失：安装对应工具；Windows 用原生安装器
6080 被占用：--port 6081
SHA256 不匹配：停止，不要绕过
浏览器打不开：先运行 ~/.taa/app/taa status，检查端口
claim 失败：不要创建第二个 TAA 账号；保留错误页面并报告
```

详见 [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)。
