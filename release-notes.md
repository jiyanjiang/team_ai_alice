# TAA 1.0.1-rc4 · 公测

- 产品版本：`1.0.1-rc4`
- runtime：`2.2.53`（上一版 2.2.51）
- 包：`releases/taa-1.0.1-rc4.tar.gz`
- 大小：3,907,545 bytes
- SHA256：`bdf6b6863bbefca8ef99de4a973ab2265c73528bcc9bcbd423de0b253e7a617c`

## 本版说明

本文件只写可核实的发版事实；功能变更请对照 TAA 私有仓库的提交记录（公开仓库不含源码）。

- 构建来源：`core/runtime + private taa/node-v05`（见包内 `BUILD_INFO.json`）。
- 与上一版 `1.0.1-rc3` 的差异：runtime 2.2.51 → 2.2.53。

## 安装

```bash
curl -fsSL https://alice.loomsci.com/install.sh | TAA_CHANNEL=beta sh -s -- --center https://alice.loomsci.com
```
