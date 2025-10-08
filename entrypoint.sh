#!/bin/bash
set -Eeuo pipefail

BIN_SDK_AMD64="/app/amd64/FleetShareCLI"
BIN_SDK_ARM64="/app/arm64/FleetShareCLI"
CONFIG_FILE="/app/config.json"
PROXY_FILE="/app/proxy.txt"

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') $*"; }

if [ -z "${TOKEN:-}" ]; then
  log " >>> An2Kin >>> ERROR: TOKEN environment variable is not set"
  exit 1
fi

if [ ! -f "$PROXY_FILE" ]; then
  log " >>> An2Kin >>> ERROR: proxy.txt not found at $PROXY_FILE"
  exit 1
fi

detect_arch() {
  local arch
  arch=$(uname -m)
  case "$arch" in
    x86_64)
      BIN_SDK="$BIN_SDK_AMD64"
      log " >>> An2Kin >>> Detected architecture: $arch, using $BIN_SDK"
      ;;
    aarch64|arm64)
      BIN_SDK="$BIN_SDK_ARM64"
      log " >>> An2Kin >>> Detected architecture: $arch, using $BIN_SDK"
      ;;
    *)
      log " >>> An2Kin >>> ERROR: Unsupported architecture: $arch"
      exit 1
      ;;
  esac
}

generate_config() {
  log " >>> An2Kin >>> Generating $CONFIG_FILE from $PROXY_FILE"
  proxies=$(awk 'NF {gsub(/"/,"\\\""); gsub(/^[ \t]+|[ \t]+$/,""); printf "\"%s\",", $0}' "$PROXY_FILE" | sed 's/,$//')
  if [ -z "$proxies" ]; then
    proxies=""
  fi

  cat > "$CONFIG_FILE" <<EOF
{
  "apiKey": "${TOKEN}",
  "devices": {
    "subnets": [],
    "socksProxies": [${proxies}]
  },
  "debug": false
}
EOF

  cat "$CONFIG_FILE"
  log " >>> An2Kin >>> Generated config.json:"
}

main() {
  detect_arch
  generate_config
  while true; do
    log " >>> An2Kin >>> Starting binary..."
    "$BIN_SDK" &
    PID=$!
    log " >>> An2Kin >>> $BIN_SDK PID is $PID"
    wait $PID
    log " >>> An2Kin >>> Process exited, restarting..."
    sleep 5
  done
}

main