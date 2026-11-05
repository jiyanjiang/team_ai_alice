#!/usr/bin/env bash
# TAA 1.x public installer.
# No agent key is required; the Owner claim happens in the browser.
set -euo pipefail

command -v curl >/dev/null 2>&1 || { echo "x curl is required" >&2; exit 3; }
command -v tar >/dev/null 2>&1 || { echo "x tar is required" >&2; exit 3; }

BASE="${TAA_BASE:-https://raw.githubusercontent.com/jiyanjiang/team_ai_alice/main}"
# 版本与校验和只认 release-manifest.json：写死在脚本里必然随发版漂移
# （rc4 发版时本脚本仍指向 rc3 的包，且校验和取自另一个包，安装必然失败）。
MANIFEST_URL="${BASE%/}/release-manifest.json"
MANIFEST_JSON="$(curl -fsSL "$MANIFEST_URL" 2>/dev/null || true)"
field() {
  printf '%s' "$MANIFEST_JSON" | tr -d '\r' \
    | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" | head -1
}
VERSION="${TAA_VERSION:-$(field version)}"
EXPECTED_SHA256="${TAA_PACKAGE_SHA256:-$(field sha256)}"
if [ -z "$VERSION" ] || [ -z "$EXPECTED_SHA256" ]; then
  echo "x cannot read release manifest: $MANIFEST_URL" >&2
  echo "  pass TAA_VERSION and TAA_PACKAGE_SHA256 explicitly, or check network / TAA_BASE" >&2
  exit 3
fi
URL="${TAA_PACKAGE_URL:-${BASE%/}/releases/taa-${VERSION}.tar.gz}"

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    -h|--help)
      cat <<'EOF'
TAA public installer

Usage:
  ./install.sh [--home DIR] [--port N] [--no-browser] [--skip-deps]
  ./install.sh --dry-run     # 只打印版本 / 包地址 / 期望 SHA256

The package installs the local runtime into TAA_HOME/app and starts Flask
on port 6080. No agent key is required; the Owner claim is in the browser.
EOF
      exit 0
      ;;
    --dry-run) DRY_RUN=1 ;;
  esac
done

if [ "$DRY_RUN" = "1" ]; then
  echo "version: $VERSION"
  echo "url:     $URL"
  echo "sha256:  $EXPECTED_SHA256"
  exit 0
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "[1/3] downloading TAA ${VERSION}"
curl -fL --retry 3 --connect-timeout 10 --max-time 300 "$URL" -o "$TMP/pkg.tgz"
ACTUAL="$(shasum -a 256 "$TMP/pkg.tgz" | awk '{print $1}')"
if [ "$ACTUAL" != "$EXPECTED_SHA256" ]; then
  echo "x package SHA256 mismatch" >&2
  echo "  expected: $EXPECTED_SHA256" >&2
  echo "  actual:   $ACTUAL" >&2
  exit 4
fi

echo "[2/3] extracting"
tar xzf "$TMP/pkg.tgz" -C "$TMP"
[ -x "$TMP/taa_agent/install.sh" ] || { echo "x package layout is invalid" >&2; exit 4; }

echo "[3/3] installing runtime"
"$TMP/taa_agent/install.sh" "$@"
