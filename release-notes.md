# TAA 1.0.1-rc36 · 公测

- 产品版本：`1.0.1-rc36`
- runtime：`/version` 的 runtime 字段恒为 `2.2.53`（冻结排障值，不代表当前版本）
- 包：`releases/taa-1.0.1-rc36.tar.gz`
- 大小：4,112,630 bytes
- SHA256：`fcaca765a25328f3195c362cfb4d70178ec9874742a302717041aacd7c047446`

> 上一版：`1.0.1-rc35`
> 中心：无需变更
> A 端 soak：本版动读路径与跨机授权，按 `docs/25 §3` 风险分级执行（跨机 ≥10 轮）

## 修复

- **页面卡顿的根因：请求线程同步出网（P0）**。`docs/561` 真机取证显示 `/app/chats` 首访
  15–25s、`/app/settings/profile` 0.85–1.47s，慢在请求线程里直接打中心拉好友/资料。
  改为 **内存缓存（60s）→ SQLite 快照（冷启动首屏）→ 后台线程刷新**，请求线程零出网；
  首屏无快照时由后台线程补齐，页面不再等中心。实测 `/app/chats` 冷首访 4ms、
  `/app/settings` warm 113ms / cold 257–389ms。

- **派生好友同步节流（P1）**。`friend_ids()` 在 DM 列表、朋友圈可见性等**读路径**被高频调用，
  原实现每次跑 project+team 全量 UPSERT 并 commit —— 读请求持有写锁，与后台写（风格学习、心跳）
  相撞即排队，表现为页面偶发十几秒卡顿与 `database is locked`。
  改为 60s 内不重算（`TAA_FRIEND_SYNC_TTL` 可调）；新增好友走显式写入点，不依赖被动派生。

- **SQLite 锁等待 30s → 5s（P1）**。30s 会把"锁冲突"变成"页面假死 30 秒"，
  用户感知就是卡顿。改为 5s 快速暴露（上层有重试/降级）；排障需要长等待时用
  `TAA_DB_BUSY_MS` 临时调大。

- **跨机唤醒 503 后静默退化（P1）**。`is_friend_node()` 当时判 False 就建了 pending 再没人管，
  于是唤醒持续 503、不发任何信号，链路静默退到 20s 轮询（实测落地延迟 12s/12s/42s）。
  本版补齐两端：**好友即授权**（启动补批 + 请求时兜底补批，只加不减可回滚）+
  **失败可见**（记录最近一次失败码与提示，界面上标出"跨机同步被拒绝：对方需要批准你的节点"）。
  `docs/561` 的 1–2 秒量级路径因此恢复。

- **朋友圈纯图帖发不出去（P0，B-007）**。去重 key 只有（标题,正文），纯图帖正文为空 → key 恒为
  `"\n"` → 命中历史空正文帖 → 302 回旧帖、新帖不落库。key 并入**附件指纹**：
  同文同图仍判重、同文不同图各成一条。判据 10/10（热进程）+ 10/10（冷进程）+ 2 轮冒烟 = 22/22。

## 新增

- `scripts/page_speed.py`：10 个用户可见页面的耗时自检（warm / cold 两口径），
  已作为 `release_check` 的硬判据「每页 ≤ 2s」。
  理由：`/app/chats` 那次事故**功能全绿、接口看着正常**，只有"按下一个页面要多久"能暴露。
- `scripts/cold_check.py` + `./gate.sh --cold`：冷启动口径自检（前置快照 → 重启 →
  每页只测第一枪 → 核对服务/版本/agent 树恢复 → 落凭证 `reports/taa_v1/cold_check.json`）。
- **发版硬闸从 L1+L2 扩到 L1+L2+L3**：`publish_release.py` 现在要求
  `gate_release_check.json`（L1）+ `gate_xmachine.json`（L2）+ `cold_check.json`（L3）
  三份「同版本、24h 内、passed」凭证，缺一项即拒绝发版。
- `scripts/test_moments_image_post.py`（B-007 判据，走真实上传/发帖链路，登记为外部用例）。
- `scripts/test_peer_grants_auto.py`（好友即授权：存量补批 / 授权兜底）。
- 新表 `ui_snapshot`（懒建，`create table if not exists`）：首屏快照与刷新时间，供冷启动兜底。

## 兼容性

- 协议 `1.0` 不变，无破坏性 schema 迁移（`ui_snapshot` 首次写入时自建）。
- 无新依赖、无新配置项；`TAA_FRIEND_SYNC_TTL` / `TAA_DB_BUSY_MS` 为可选环境变量，不设即用默认。
- 升级路径不变，rc35 及更早版本可直接升到本版。

## 已知问题

- B-007 的 10/10 判据是单机同链路重复，不含弱网/大图/并发上传的极端组合。
- 受限令牌（IDE 代理沙箱）场景仍需正常会话才能跑通安装/自检，本版未改变这一点。
- 冷口径在无 `pgrep` 的平台上无法探测 agent 进程，会显示"未知"并**不据此判红**（宁可少判，不误报）。

## 验证方法

```bash
./gate.sh                    # L1 门禁（含页面速度 ≤2s 硬判据）
./gate.sh --cold             # L3 冷口径（会重启服务）
python scripts/xmachine_std_test.py                # L2 双机
python scripts/test_moments_image_post.py --times 10 --url http://127.0.0.1:6080
```

## 自检结果

- `release_check`：**153 / 153 通过**（页面速度 10/10，warm）
- 冷口径（`./gate.sh --cold`）：**10 / 10 合格**，最慢 `/app/settings` 263ms，`/app/chats` 4ms，
  重启后服务 0.0s 即回、agent 树随即自愈；凭证 `reports/taa_v1/cold_check.json`（version=1.0.1-rc36）
- 本机安装实例已升至 rc36（`journal=COMMITTED`，health 200，agents=14）
- 双机 XM-STD（L2）：待 B 端升到 rc36 后复跑回填
- 包：`reports/taa_v1/taa-1.0.1-rc36.tar.gz`，**4,112,630 B**，
  sha256 `fcaca765a25328f3195c362cfb4d70178ec9874742a302717041aacd7c047446`

## 回滚点

- git tag：`v1.0.1-rc36`（前一稳定点：`v1.0.1-rc35`）
