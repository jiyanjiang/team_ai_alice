# TAA 1.0.1-rc8 · 公测

- 产品版本：`1.0.1-rc8`
- runtime：`/version` 的 runtime 字段恒为 `2.2.53`（rc5 起冻结，只作排障；产品版本看上一行）
- 包：`releases/taa-1.0.1-rc8.tar.gz`
- 大小：3,958,556 bytes
- SHA256：`648de989da735b140e30eaf23396467320d0e929ae340f906fcdd73c40963875`

## 本版说明

本文件只写可核实的发版事实；功能变更请对照 TAA 私有仓库的提交记录（公开仓库不含源码）。

- 构建来源：`core/runtime + private taa/node-v05`（见包内 `BUILD_INFO.json`）。
- **自动更新的安全性（本版重点）**：升级失败的版本装一次即熔断，不再每天自动重试同一个坏包；
  手动重试仍然允许，成功一次自动解除。此前存在「回滚后第二天又被自动装一遍」的循环。
- **每天至少检查一次**：机器在检查时间点关机时，当天会补检一次（总上限仍是每天 2 次）。
  自动安装默认每天最多 1 次，可配置。
- 更新状态不再卡在「安装中」：安装成功显示已是最新，失败显示已回滚到原版本并给出原因。
- 与上一版 `1.0.1-rc7` 的差异：仅自动更新链路；安装、协议、数据格式均无变化，
  `min_upgrade_from` 仍为 `1.0.0-beta.1`，rc5/rc6/rc7 均可直升。

## 安装

```bash
curl -fsSL https://alice.loomsci.com/install.sh | TAA_CHANNEL=beta sh -s -- --center https://alice.loomsci.com
```

先看会装哪个版本、校验和是多少（不做任何改动）：

```bash
curl -fsSL https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main/install.sh -o /tmp/taa-install.sh && bash /tmp/taa-install.sh --dry-run
```
