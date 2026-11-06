# TAA 版本与包边界

## 当前公测

| 制品 | 版本 | 包含 |
|---|---|---|
| `taa-1.0.1-rc9.1.tar.gz` | 1.0.1-rc9.1（`/version` 的 runtime 恒为 2.2.53，冻结排障值） | 见 release-notes：**升级准入放宽**——identity.json / owner.json / data.db 任一即可 |
| `taa-1.0.1-rc8.tar.gz` | 1.0.1-rc8（`/version` 的 runtime 恒为 2.2.53，冻结排障值） | 见 release-notes：**自动更新可安全失败**（装失败即熔断、错过窗口补检、自动安装默认 1 次/天） |
| `taa-1.0.1-rc5.tar.gz` | 1.0.1-rc5 / runtime 2.2.53 | 见 release-notes：补齐 6 个人设模板、安装自检增「人设模板」、chromium 下载超时 |
| `taa-1.0.1-rc4.tar.gz` | 1.0.1-rc4 / runtime 2.2.53 | 见 release-notes；**该包漏带 agents/_templates/*.yaml，全新安装打不开**，仅可用于升级 |
| `taa-1.0.1-rc3.tar.gz` | 1.0.1-rc3 / runtime 2.2.51 | 双 peer 端口 6090/6091、监听自检、并发去重、更新刷新 |
| 公库 main | 1.0.1-rc9.1 | installer、包、manifest、SHA256SUMS、IDE prompt、文档 |

## 历史包

| 制品 | 版本 | 说明 |
|---|---|---|
| `taa-1.0.1-rc3.tar.gz` | 1.0.1-rc3 | 双 peer 端口、并发去重、更新刷新 |
| `taa-1.0.0-beta.34.tar.gz` | 1.0.0-beta.34 | devlog、重复发送锁、自动刷新 |
| `taa-1.0.0-beta.33.tar.gz` | 1.0.0-beta.33 | devlog flex 修复 |
| `taa-1.0.0-beta.32.tar.gz` | 1.0.0-beta.32 | 图片压缩、二进制附件、7 天保留 |
