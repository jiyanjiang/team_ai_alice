# TAA 1.0.1-rc34 · 公测

- 产品版本：`1.0.1-rc34`
- runtime：`/version` 的 runtime 字段恒为 `2.2.53`（冻结排障值，不代表当前版本）
- 包：`releases/taa-1.0.1-rc34.tar.gz`
- 大小：4,096,296 bytes
- SHA256：`016531a0b0328a96f405ee9dc445830efc359047aa8d2179f75baf1f5b391c2e`

> 上一版：`1.0.1-rc33`
> 中心：无需变更
> A 端 soak：本版含升级链路改动，按 §3「高」风险口径执行（跨机 10 轮 + 端到端用例）

## 修复

- **升级 SWAP 必失败（P0，B-001）**：`taa_upgrade.stop()` 原来只做 launcher stop + 按端口杀监听者，
  不清 `app` 目录内的 agent 运行时（`runtime/supervisor|loop|dispatcher|chatroom_agent.py`）
  与 cwd 落在 `app` 的 cmd 外壳。Windows 上只要还有进程的 cwd/句柄在目录内，
  `os.replace(app, prev)` 必然 `WinError 32`，自动更新 100% 卡在 SWAP。
  现在端口杀完后统一调用 `kill_app_processes()`：跨平台列出命令行指向 `<home>/app` 的进程并结束；
  两次仍杀不掉则明确报错，不硬闯 SWAP。
- **升级器自杀（P0，B-002）**：Windows 上 venv python 会派生一个同命令行的解释器进程，
  `os.getpid()` 只排除其中一个，另一个被当成"占用者"后被 `taskkill /T` 连整棵树（含升级器）清掉
  ——表现为停在 `phase=STOP`、失败日志 0 字节、服务一起断。
  新增 `_self_tree()`，排除自己 + 全部祖先 pid。
- **`restart_agent` 在 Windows 上无法收敛（P1，B-003/B-004）**：原来无条件 `check_output(["ps", ...])`，
  Windows 报 `WinError 2` → `found 0` → 停不掉旧套，同机出现两套 supervisor。
  改为 Windows 走 `Get-CimInstance Win32_Process`；`AGENT_RE` 同时接受 `\` 与 `/`。

## 新增

- `scripts/xmachine_soak.py`：跨机 soak 工具。每轮 7 个判据（A→B 文字 + 幂等 1 行 / B→A 文字 /
  双向图片 + peer-blob 字节 md5），前置硬门要求两端 `runtime_version` 相等，退出码可直接进门禁。
- `docs/NODES.md`：项目节点库（当前节点 + 退出判据 + 明确不含项）。
- `docs/BUGS.md`：bug 库（P0–P3 分级、计划版本、状态）。
- 测试：`test_restart_agent_procs.py`（10 项）；`test_upgrade_stop_fallback.py` 扩 ⑥⑦⑧（13 项），
  两者均已纳入 `release_check`。

## 兼容性

- 协议 `1.0`，无 schema 迁移、无配置新增、无依赖变化。
- 升级路径本身修复，旧版本（含 rc31/rc32/rc33）可直接升到本版。
- 注意：升级会整体替换 `app/`，手工放进 `app/` 的改动会被下次升级覆盖；修复需进发布包。

## 旧功能汇总（回归）

- `release_check`：见下「自检结果」。
- 见 `docs/23_功能检查清单.md`。

## 已知问题（本版不修，已排 N35）

- B-005：lock 文件写死 pid，进程被杀后 lock 仍是死 pid，`group_ingress` 会重复拉起 dispatcher。
- B-006：`restart_agent._stop()` 在 Windows 的"停旧套"未做真机收敛验证（仅验证了识别层）。
- B-007：朋友圈纯图帖发图偶发不稳定（判据：同一操作 10 次须 10/10）。

## 验证方法

```bash
TEAMAI_URL=http://127.0.0.1:6080 ../venv/bin/python scripts/release_check.py
../venv/bin/python scripts/xmachine_std_test.py
../venv/bin/python scripts/xmachine_soak.py --rounds 10
```

## 自检结果

- release_check：**151 / 151 通过**
- 跨机标准测试：39 项，**PASS 38 / FAIL 0 / INFO 1**（凭证 `reports/taa_v1/gate_xmachine.json`，version=1.0.1-rc34）
- 跨机 soak：**10 / 10 轮**，70 个检查点全 PASS，6.5 分钟（`reports/taa_v1/soak_xmachine_rc34_20261114.json`）
- 真机升级：A/B 两机均 `COMMITTED`，装后 `health.runtime_version=1.0.1-rc34`
- 包：4,096,296 B，sha256 `016531a0b0328a96f405ee9dc445830efc359047aa8d2179f75baf1f5b391c2e`

## 回滚点

- git tag：`v1.0.1-rc34`（前一稳定点：`v1.0.1-rc33`）
