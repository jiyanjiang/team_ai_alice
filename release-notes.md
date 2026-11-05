# TAA 1.0.1-rc5 · 公测

- 产品版本：`1.0.1-rc5`
- runtime：`/version` 的 runtime 字段恒为 `2.2.53`（rc5 起冻结，只作排障；产品版本看上一行）
- 包：`releases/taa-1.0.1-rc5.tar.gz`
- 大小：3,969,509 bytes
- SHA256：`1ba10b0ca9b49ba2cecedab47a66c22e011d2425c678168a9d4eb6598a54ce87`

## 本版说明

本文件只写可核实的发版事实；功能变更请对照 TAA 私有仓库的提交记录（公开仓库不含源码）。

- 构建来源：`core/runtime + private taa/node-v05`（见包内 `BUILD_INFO.json`）。
- **安装包完整性（本版重点）**：`agents/_templates/*.yaml` 共 6 个人设模板已随包发布。
  `1.0.1-rc4` 的包漏带这 6 个文件，全新安装会在首次建 agent 时崩在
  `IndexError: Cannot choose from an empty sequence`（`core/persona_gen.py`），整机打不开；
  已有安装走升级路径（保留 `$TAA_HOME/agents/`）不受影响。
- 安装自检报告新增「人设模板」一项：目录存在不算通过，必须真有 `.yaml`，缺了直接判 fail。
- 安装器：chromium 下载加 420s 超时（`TAA_RENDER_TIMEOUT` 可调），下载卡住不再无限等待；
  渲染栈仍是可选能力，失败自动降级到 pillow。
- 与上一版 `1.0.1-rc4` 的差异：打包与 dist 版本收敛到 `dist/VERSION` 一条轴（`/version` 的
  `runtime` 字段仍冻结为 `2.2.53`，只作排障）、LLM 与出图端点可插拔、
  邀请制内测与朋友圈分享、首席 agent 选择规则、调研报告先落帖再投递。

## 安装

```bash
curl -fsSL https://alice.loomsci.com/install.sh | TAA_CHANNEL=beta sh -s -- --center https://alice.loomsci.com
```

先看会装哪个版本、校验和是多少（不做任何改动）：

```bash
curl -fsSL https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main/install.sh -o /tmp/taa-install.sh && bash /tmp/taa-install.sh --dry-run
```
