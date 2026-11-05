# DOWNLOAD · 下载

## 当前公测包

```text
产品：TAA 1.0.1-rc5
包：releases/taa-1.0.1-rc5.tar.gz
字节：3,969,509
SHA256：1ba10b0ca9b49ba2cecedab47a66c22e011d2425c678168a9d4eb6598a54ce87
```

公开地址：

```text
https://github.com/jiyanjiang/team_ai_alice
```

raw 包：

```text
https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main/releases/taa-1.0.1-rc5.tar.gz
```

**不需要 key，不需要登录。**

## 安装器下载

```bash
curl -fsSL https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main/install.sh -o /tmp/taa-install.sh
bash /tmp/taa-install.sh
```

安装器会自动下载上方包并校验 SHA256。

## 校验

```bash
shasum -a 256 -c SHA256SUMS
```

或：

```bash
shasum -a 256 releases/taa-1.0.1-rc5.tar.gz
```

必须等于：

```text
1ba10b0ca9b49ba2cecedab47a66c22e011d2425c678168a9d4eb6598a54ce87
```

## 历史包 / 回滚

```text
taa-1.0.0-beta.2.tar.gz
taa-1.0.0-beta.1.tar.gz
taa-node-v05-0.5.1.tar.gz
taa-node-v05-0.5.0.tar.gz
taa-complete-0.4.1.tar.gz
```

`taa-node-v05-*` 不是完整产品，只用于旧节点/回滚。

回滚命令见 [INSTALL](INSTALL.md)。

## 不要做

```text
不要从第三方网盘下载来路不明的 TAA 包
不要跳过 SHA256
不要把包上传到公开网盘后改 hash
不要在下载页放模型 key / 私钥
```
