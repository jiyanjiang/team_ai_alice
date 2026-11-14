# TAA 1.0.1-rc35 · 公测

- 产品版本：`1.0.1-rc35`
- runtime：`/version` 的 runtime 字段恒为 `2.2.53`（冻结排障值，不代表当前版本）
- 包：`releases/taa-1.0.1-rc35.tar.gz`
- 大小：4,101,053 bytes
- SHA256：`87138d78febc683c08aea5049df71f5484eb3d65431a89ab9d364c068f079eae`

> 上一版：`1.0.1-rc34`
> 中心：无需变更
> A 端 soak：本版动 CLI 与安装链，按 `docs/25 §3` 风险分级执行（跨机 ≥10 轮 + Win10 实机首装）

## 修复

- **Windows 上 `python bin\taa` 永远自举不到 venv（P0）**：`cli/teamai.py` 的自举段与 `doctor`
  两处都写死 `venv/bin/python`，Windows 实际是 `venv/Scripts/python.exe`。后果是 CLI 静默回落
  系统 python（缺 PyYAML 时直接 `ModuleNotFoundError`），`doctor` 则恒报「venv 解释器 WARN」。
  现在统一走 `_venv_python(home)`（判据与 `scripts/install_report.py:73-79` 一致）。
  `doctor` 的「是否绑定」也从 `realpath` 比较改为 `sys.prefix != sys.base_prefix` —— 与自举段
  同一判据，避免把 venv 的 python 软链误判成"未绑定"。

- **受限令牌下穿越 junction 崩三处（P1）**：Windows 安装形态的 `app\agents` / `app\bootstrap`
  是指向 `$TAA_HOME` 的 junction。在 IDE 代理沙箱这类受限令牌上下文里穿越会报
  `WinError 448 不受信任装入点`（Win10 报告 `p-4b60b13e`）：
  - `scripts/install_report.py`：人设模板检查改为「`$TAA_HOME/agents/_templates` 优先、
    `app/agents/_templates` 回退」，`OSError` 跳过 —— 原实现会在自检第一步中断；
  - `core/security.py`：`BOOTSTRAP_DIR.mkdir` 失败不再阻断启动，改从
    `$TAA_HOME/bootstrap/master.key` 读**同一物理文件**（只换访问路径，**绝不另生成密钥**，
    否则库里既有密文全部解不开）；
  - `cli/teamai.py`：`_key` / `_root_token` 改为「包根优先、`$TAA_HOME` 兜底」，穿越失败
    自动换下一个候选 —— 源码树语义不变，不会误读另一实例的 key。

- **`doctor` 的 `config.toml` 提示**改为「模型功能可选，本机服务与身份不受影响（需要模型时跑
  /setup/）」。等级仍是 WARN，不为凑"全绿"而降级。

## 重构（无行为变化）

- **install 类逻辑收敛为单一模块 `scripts/taa_install_ops.py`**：解释器探测（含 uv 兜底）、
  pip 源测速、运行时复制与数据目录/模板种子、venv 检测/备份/重建、依赖安装（core + 可选 image）、
  launcher 启动、装完自检、`install-timings.json`。后续的首装 / 重装 / 修复 / 迁移等动作共用
  这一套底座，不再各写一份而漂移。
- `scripts/taa_bootstrap.py` 从 408 行降到 179 行，只保留「命令行 → 环境打印 → 包完整性 →
  分派首装 / 升级」；升级的原子替换与回滚仍归 `taa_upgrade.py`。
- 兼容：`Timer` / `pick_index` / `python_hint` / `write_timings` 等旧名保留 re-export。
- 打包：`build_taa_v1.py` 把 `taa_install_ops.py` 列入必含件 —— 缺件会响亮失败，
  不会静默产出半个包。

## 新增

- `scripts/taa_install_ops.py`：安装底座模块（职责见上「重构」），后续安装类动作共用。
- `cli/teamai.py` 新增 `_venv_python(home)` 与 `_local_roots()`：前者统一 venv 解释器路径，
  后者统一「包根 → `$TAA_HOME`」候选根，读 agent key / root token 都走它。
- 无新路由、无新 CLI 子命令、无新依赖。

## 兼容性

- 协议 `1.0`，无 schema 迁移、无配置新增、无依赖变化。
- 升级路径不变，旧版本（含 rc34 及更早）可直接升到本版。
- `bin/taa-core`（bash）与 `taa.cmd`（Windows 主入口）未改。

## 已知问题（本版不修）

- B-005 / B-006 / B-007 沿用 rc34 的结论与计划版本。
- 受限令牌（IDE 代理沙箱）仍有场景需要正常会话才能跑通安装/自检 —— 本版只把已验证的三处崩点
  改为"降级可读"，不承诺沙箱内全通。

## 验证方法

```bash
TEAMAI_URL=http://127.0.0.1:6080 ../venv/bin/python scripts/release_check.py
../venv/bin/python scripts/test_fresh_install_ux.py
../venv/bin/python scripts/test_bootstrap_local_keys.py
```

## 自检结果

- release_check：**152 / 152 通过**
- `test_fresh_install_ux`：6 / 6；`test_bootstrap_local_keys`：ALL PASS
- 本机安装形态：`install_report.py` 连续两次 **10 ok / 0 warn / 0 fail**；`taa doctor` 无 WARN 1
- Win10 报告（`p-4b60b13e`）暴露的 2 个 WARN 与 3 个 junction 崩点已按上述处置；
  **rc35 的 Win10 实机首装验证待执行**
- 包：4,101,053 B，sha256 `87138d78febc683c08aea5049df71f5484eb3d65431a89ab9d364c068f079eae`

## 回滚点

- git tag：`v1.0.1-rc35`（前一稳定点：`v1.0.1-rc34`）
