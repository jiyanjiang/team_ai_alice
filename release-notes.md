# TAA 1.0.1-rc9 · 公测

- 产品版本：`1.0.1-rc9`
- runtime：`/version` 的 runtime 字段恒为 `2.2.53`（rc5 起冻结，只作排障；产品版本看上一行）
- 包：`releases/taa-1.0.1-rc9.tar.gz`
- 大小：3,959,162 bytes
- SHA256：`4fc78507458007e70198ca514ba44549cff210a2aad1c8589e156ebfe86ec8aa`

## 本版说明

本文件只写可核实的发版事实；功能变更请对照 TAA 私有仓库的提交记录（公开仓库不含源码）。

- 构建来源：`core/runtime + private taa/node-v05`（见包内 `BUILD_INFO.json`）。
- **升级准入放宽（本版重点）**：判断「这台机器装过没有」不再只看 `identity.json`，
  改为 `identity.json` / `owner.json` / `data.db` 里的 Owner 三选一。
  此前只有跑完设置向导的机器才认得上，其余机器升级会被直接拒绝且没有提示。
- 升级后的校验同步使用新判据；「装完身份丢了」这种情况仍会被抓住并回滚。
- 与上一版 `1.0.1-rc8` 的差异：仅升级准入判定，安装、协议、数据格式均无变化；
  `min_upgrade_from` 仍为 `1.0.0-beta.1`，rc5–rc8 均可直升。

**已知问题**：升级脚本取自「当前已安装的版本」，所以**已经被旧判据卡住的机器不会自动恢复**，
需要用新包里的脚本手动跑一次，之后自动链路即恢复正常：

```bash
python <解包目录>/taa_agent/taa_upgrade.py \
    --source <解包目录>/taa_agent --home ~/.taa --port 6080 --no-open
```

## 安装

```bash
curl -fsSL https://alice.loomsci.com/install.sh | TAA_CHANNEL=beta sh -s -- --center https://alice.loomsci.com
```

先看会装哪个版本、校验和是多少（不做任何改动）：

```bash
curl -fsSL https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main/install.sh -o /tmp/taa-install.sh && bash /tmp/taa-install.sh --dry-run
```
