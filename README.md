# FleetShare Docker Image

A minimal Alpine based Docker image for running the **FleetShare**.

## ✨ Features
- 🪶 Lightweight Alpine Linux base image.
- 🔑 Configurable environment variable (`TOKEN`).
- 🖥️ Multi‑arch support: `amd64` and `arm64`.
- 🔄 Auto‑update support with `--pull=always`.

## ⚡ Usage
- Access to **Fleetshare**: Ensure you have requested and been granted access to Fleetshare. You can request access <a href="https://earn.fm/en/fleetshare">**here**⁠</a>
- Before running the container, increase socket buffer sizes (required for high‑throughput streaming).
- To make these settings persistent across reboots, add them to /etc/sysctl.conf or a drop‑in file under /etc/sysctl.d/.
```bash
sudo sysctl -w net.core.rmem_max=8000000
sudo sysctl -w net.core.wmem_max=8000000
```

## 🧩 Environment variables
| Variable | Requirement | Description |
|----------|-------------|-------------|
| `-e TOKEN=abcdef12-3456-7890-abcd-ef1234567890`  | Required    | EarnFM API key. Container exits if not provided. |
| `-v ./proxy.txt:/app/proxy.txt`  | Required    | 1 proxy per line. Container exits if not provided.<br> Can be a mixed of proxies with or without auth |
| | Required    | `username:password@ip:port`<br>`ip:port`<br>`username:password@ip:port`<br>`ip:port`<br> |

## ⏱️ Run the container:
```bash
docker run -d \
  --name=FleetShare \
  --pull=always \
  --restart=always \
  --privileged \
  --log-driver=json-file \
  --log-opt max-size=5m \
  --log-opt max-file=3 \
  -e TOKEN=abcdef12-3456-7890-abcd-ef1234567890 \
  -v ./proxy.txt:/app/proxy.txt \
  techroy23/docker-fleetshare:latest
```

# Invite Link
### https://earn.fm/ref/LERO0EVX