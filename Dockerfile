FROM --platform=linux/amd64 earnfm/fleetshare:latest AS source_amd64
FROM --platform=linux/amd64 earnfm/earnfm-beta-fleetshare:latest AS source_beta_amd64

FROM --platform=linux/arm64 earnfm/fleetshare:latest AS source_arm64
FROM --platform=linux/arm64 earnfm/earnfm-beta-fleetshare:latest AS source_beta_arm64

FROM alpine:latest AS final

WORKDIR /app

RUN apk update \
    && apk upgrade --no-cache \
    && apk add --no-cache ca-certificates ca-certificates-bundle unzip curl bash dos2unix iptables tzdata \
    && update-ca-certificates

COPY --from=source_amd64 /app/main /app/amd64/FleetShareCLI_stable
COPY --from=source_arm64 /app/main /app/arm64/FleetShareCLI_stable

COPY --from=source_beta_amd64 /app/main /app/amd64/FleetShareCLI_beta
COPY --from=source_beta_arm64 /app/main /app/arm64/FleetShareCLI_beta

COPY entrypoint.sh /app/entrypoint.sh

RUN dos2unix /app/entrypoint.sh \
    && chmod +x /app/entrypoint.sh \
             /app/amd64/FleetShareCLI_stable \
             /app/arm64/FleetShareCLI_stable \
             /app/amd64/FleetShareCLI_beta \
             /app/arm64/FleetShareCLI_beta

ENV BETA_MODE=0

ENTRYPOINT ["/app/entrypoint.sh"]
