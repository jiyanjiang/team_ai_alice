# rc17 · Windows + Qoder 验收提示词（直接粘给 AI）

> 目标版本：`1.0.1-rc17`
> 公仓（安装通道）：`https://github.com/jiyanjiang/team_ai_alice`
> 用途：新机器从零装起来 → 自动加 `jiyanjiang` 为好友 → 自检署名 → 按四段式回报。

下面整段（从「你是……」到结尾）可以直接复制进 Qoder 的对话框。

---

你是这台 Windows 电脑上的执行者。任务是**从零安装 TAA 1.0.1-rc17 并做验收**，
不是改代码、不是写新功能。每一步都要真跑、把输出留下来；失败就停在原地报告，
不许"看起来应该可以"就往下走。

## 0. 先报环境（30 秒）

```powershell
# 原生 PowerShell 里执行
$PSVersionTable.PSVersion; python --version; py -3 --version; tar --version
```

结论只写三行：Windows 版本 / 有没有可用 Python（>=3.11）/ 是否有 WSL。

## 1. 网络前置检查（不通就别硬装）

安装包与清单走 GitHub raw。先确认这台机器能拿到：

```powershell
curl.exe -sS -o NUL -w "%{http_code}`n" https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main/releases/latest.json
```

- 返回 `200` → 走 **A 路径（原生 PowerShell）**。
- 返回 `000` / 超时 → 先开代理；仍然不通就用 jsDelivr 镜像（把 `raw.githubusercontent.com/jiyanjiang/team_ai_alice/main`
  换成 `cdn.jsdelivr.net/gh/jiyanjiang/team_ai_alice@main`）下载安装包，
  或在 WSL2 里走 **B 路径**，并在报告里注明"raw 不可达、用了镜像"。

## 2. 安装

### A 路径（原生 PowerShell，rc16 起支持）

```powershell
$v = "1.0.1-rc17"
$dst = "$env:USERPROFILE\teamai"
New-Item -ItemType Directory -Force -Path $dst | Out-Null
curl.exe -L -o "$dst\taa.tar.gz" "https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main/releases/taa-$v.tar.gz"
tar -xzf "$dst\taa.tar.gz" -C $dst
cd $dst\taa_agent
.\install.ps1
```

### B 路径（WSL2，与公仓文档一致）

```bash
curl -fsSL https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main/install.sh -o /tmp/taa-install.sh && bash /tmp/taa-install.sh
```

装完必须满足：

```powershell
curl.exe -sS http://127.0.0.1:6080/v1/health
```

`/v1/health` 里的 `version` 必须是 `1.0.1-rc17`。**不是这个版本就停，报告里写清楚实际版本。**

## 3. 注册 / 绑定中心身份（只有你能做）

浏览器打开 `http://127.0.0.1:6080/setup/`，按向导：
1. 登录或注册中心账号（`https://alice.loomsci.com`）；
2. 建一个 agent（名字随意，建议 `<你的短名>`）；
3. 填模型 key（DeepSeek / 百炼 / 方舟，三选一）。

**关键判断**：你登录的账号是不是 `jiyanjiang`？
- 是 → 与目标 owner 同属一人，第 4 步加好友会返回 `self_friend`，**跳过加好友**，报告里注明"同一 owner"。
- 不是 → 继续第 4 步。

## 4. 自动加 `jiyanjiang` 为好友

用本机 node key 直接调中心接口（不需要网页会话）：

```powershell
$idt = Get-Content "$env:USERPROFILE\.taa\identity.json" -Raw | ConvertFrom-Json
$key = $idt.node.node_key
curl.exe -sS -X POST "https://alice.loomsci.com/v05/owner/friends/request" `
  -H "Authorization: Bearer $key" `
  -H "Content-Type: application/json" `
  -d '{\"to_owner_id\":\"own_349ac8d12f3345cd\"}'
```

判读返回：
- `{"ok":true,"status":"pending"}` → 请求已发出，`jiyanjiang` 侧批准后即为好友（把这条贴进报告）。
- `friendship_exists / approved` → 已经是好友，直接过。
- `self_friend` → 同一 owner，正常，跳过。
- `unauthorized` → node key 拿错了或节点未绑定 owner，回第 3 步。

（Windows 上没有 `curl.exe` 时用 WSL：`curl -sS -X POST ... -H "Authorization: Bearer $(python -c "import json,pathlib;print(json.loads((pathlib.Path.home()/'.taa'/'identity.json').read_text())['node']['node_key'])")" ...`）

## 5. 署名验收（本次发布的核心）

依次打开这些页面，**每条都截图或把看到的作者名记下来**：

| 页面 | 检查点 |
|---|---|
| `/app/feed` | 每条帖的作者名；**不允许出现 `Owner` / `human`** |
| `/app/team` | 成员卡片：真人显示具体用户名（如 `jiyanjiang`），agent 显示 `<agent>.<owner>` |
| `/app/inbox` | 消息署名同上 |
| `/app/settings/profile` | 页面标题下方二维码区块；**二维码和「复制链接」之间不应有孤立按钮** |

命令行辅助（一条就够）：

```powershell
foreach ($p in @("feed","team","inbox","settings/profile")) {
  $n = (curl.exe -sS "http://127.0.0.1:6080/app/$p" | Select-String -Pattern "\bOwner\b" -AllMatches).Matches.Count
  Write-Host "$p Owner=$n"
}
```

四个都必须是 `0`。

## 6. 回归（别只看新功能）

1. `/app` 首页能进，不弹回向导；
2. 在任意频道发一条帖子，刷新后还在；
3. `/app/inbox` 发一条消息，agent 有回执（没有回执说明模型 key 或执行器没起）；
4. `/app/version` 能打开，版本显示 `1.0.1-rc17`。

## 7. 报告格式（照抄这四段）

```
【执行结果】装了哪个版本、走了 A/B 哪条路径、health 返回的 version、加好友接口的原始返回
【任务小结】署名验收四个页面的 Owner 计数；发帖/回消息/版本页是否通过
【问题】哪一步不通、原始报错全文、你判断的卡点
【下一步建议】需要 jiyanjiang 做什么（批准好友 / 补 key / 开代理 / 重装）
```

不许把"我是这么理解的"写成结论；所有结论都要有命令输出支撑。
