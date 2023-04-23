FROM golang:alpine

WORKDIR /src

RUN apk update && apk add --no-cache git gcc make musl-dev scdoc && \
    git clone --branch v0.6 https://git.sr.ht/~emersion/soju && cd soju && \
    go build -ldflags "-linkmode external -extldflags -static" ./cmd/soju && \
    go build -ldflags "-linkmode external -extldflags -static" ./cmd/sojuctl

FROM alpine:latest

VOLUME /data

COPY --from=0 /src/soju/soju /usr/local/bin/
COPY --from=0 /src/soju/sojuctl /usr/local/bin/

WORKDIR /data

CMD ["soju", "-config", "/data/soju.cfg"]
