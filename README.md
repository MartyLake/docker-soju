# soju docker image

[![Build](https://github.com/fourstepper/docker-soju/actions/workflows/build.yml/badge.svg)](https://github.com/fourstepper/docker-soju/actions/workflows/build.yml)

soju is an IRC bouncer - https://git.sr.ht/~emersion/soju

## Usage

Provide a configuration file in a folder that maps to `/data`. See https://git.sr.ht/~emersion/soju/tree/master/item/doc/soju.1.scd for instructions on how to create such configuration file.

such config file could like like this:

```
listen ircs://0.0.0.0:6697
listen irc+insecure://0.0.0.0:6667
#listen unix+admin:///run/soju_admin
db sqlite3 /data/soju.db
log fs /data/irc.log
tls /data/certs/cert.pem /data/certs/key.pem
hostname example.com
```

## Certificates with certbot

If you are using `certbot` to manage your tls certificates, you have to give these to files to `soju`:

```
mkdir soju-data/certs
cp -f certbot-data/live/example.com/privkey.pem   > soju-data/certs/key.pem
cp -f certbot-data/live/example.com/fullchain.pem > soju-data/certs/cert.pem
```

## Running the image

**Run as part of docker-compose**

```
version: "3.0"
services:
  soju:
    image: fourstepper/docker-soju:latest
    container_name: soju
    restart: unless-stopped
    volumes:
      - ./soju-data:/data
    ports:
      - "6667:6667"
```

`docker-compose up -d --build soju`

## Reloading certificates

If using ircss, when the certificate has changed, issue a SIGHUP to the image:

`docker  kill -s HUP soju`
