FROM --platform=linux/amd64 earnfm/fleetshare:latest AS source_amd64

FROM --platform=linux/arm64 earnfm/fleetshare:latest AS source_arm64

FROM alpine:latest AS final

WORKDIR /app

RUN apk update \
    && apk upgrade --no-cache \
    && apk add --no-cache ca-certificates ca-certificates-bundle unzip curl bash dos2unix iptables tzdata \
    && update-ca-certificates

COPY --from=source_amd64 /app/main /app/amd64/FleetShareCLI

COPY --from=source_arm64 /app/main /app/arm64/FleetShareCLI

COPY entrypoint.sh /app/entrypoint.sh

RUN dos2unix /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh \
             /app/amd64/FleetShareCLI \
             /app/arm64/FleetShareCLI

ENTRYPOINT ["/app/entrypoint.sh"]
