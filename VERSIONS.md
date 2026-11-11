# TAA 版本与包边界

> 权威来源是 `release-manifest.json`（安装器只读它）。本页是给人看的索引，
> 版本若与本页不一致，以清单为准。

## 当前公测

| 制品 | 版本 | 包含 |
|---|---|---|
| `taa-1.0.1-rc24.tar.gz` | 1.0.1-rc24（`/version` 的 runtime 恒为 2.2.53，冻结排障值） | 见 release-notes：**朋友圈 = 多打一个 `#lobby` 标签**；可见性判据收口；发帖必发事件全覆盖；门禁 143/143、双机 38 项 0 失败 |

**公库 main = 1.0.1-rc24**：installer、包、manifest、SHA256SUMS、IDE prompt、文档。

包指纹（与 `release-manifest.json` 一致）：

```text
taa-1.0.1-rc24.tar.gz
4,064,777 bytes
3d5322a0809f6732df9dd806abd8a27d9d791d6facb360867f3b3f89d4088f02
```

## 同一条公测线上的近期包

| 制品 | 版本 | 说明 |
|---|---|---|
| `taa-1.0.1-rc24.tar.gz` | 1.0.1-rc24 | 朋友圈标签即可见；出网判据单一函数；事件全覆盖 |
| `taa-1.0.1-rc23.tar.gz` | 1.0.1-rc23 | 跨机群聊双向打通 |
| `taa-1.0.1-rc22.tar.gz` | 1.0.1-rc22 | 装完就能用：本机模式建 agent + 可用性自检 |
| `taa-1.0.1-rc21.tar.gz` | 1.0.1-rc21 | Windows 可装可起可升 |
| `taa-1.0.1-rc9.1.tar.gz` | 1.0.1-rc9.1 | 预发布号比较修复（rc10 起可正常升级） |
| `taa-1.0.1-rc8.tar.gz` | 1.0.1-rc8 | 自动更新可安全失败（装失败熔断、错过补检） |

## 不要再用

| 制品 | 版本 | 原因 |
|---|---|---|
| `taa-1.0.1-rc4.tar.gz` | 1.0.1-rc4 | **漏带 `agents/_templates/*.yaml`，全新安装打不开**，仅可用于升级 |
| `taa-1.0.0-beta.*` | beta | 已被 1.0.1 线取代，不再维护 |

## 历史包

| 制品 | 版本 | 说明 |
|---|---|---|
| `taa-1.0.0-beta.34.tar.gz` | 1.0.0-beta.34 | devlog、重复发送锁、自动刷新 |
| `taa-1.0.0-beta.33.tar.gz` | 1.0.0-beta.33 | devlog flex 修复 |
| `taa-1.0.0-beta.32.tar.gz` | 1.0.0-beta.32 | 图片压缩、二进制附件、7 天保留 |
