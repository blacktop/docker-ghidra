<p align="center">
  <a href="https://github.com/blacktop/docker-ghidra"><img alt="Malice Logo" src="https://raw.githubusercontent.com/blacktop/docker-ghidra/master/ghidra.png" height="140" /></a>
  <a href="https://github.com/blacktop/docker-ghidra"><h3 align="center">docker-ghidra</h3></a>
  <p align="center">Ghidra Client/Server Docker Image</p>
  <p align="center">
    <a href="https://hub.docker.com/r/blacktop/ghidra/" alt="Docker Stars">
          <img src="https://img.shields.io/docker/stars/blacktop/ghidra.svg" /></a>
    <a href="https://hub.docker.com/r/blacktop/ghidra/" alt="Docker Pulls">
          <img src="https://img.shields.io/docker/pulls/blacktop/ghidra.svg" /></a>
    <a href="https://hub.docker.com/r/blacktop/ghidra/" alt="Docker Image">
          <img src="https://img.shields.io/badge/docker%20image-1.45GB-blue.svg" /></a>
    <a href="https://github.com/blacktop/docker-ghidra/actions/workflows/docker-image.yml" alt="Docker CI">
          <img src="https://github.com/blacktop/docker-ghidra/actions/workflows/docker-image.yml/badge.svg" /></a>
</p>

## Why?

Cuz installing Java on your Mac is gross. :smirk:

## Dependencies

- [eclipse-temurin](https://hub.docker.com/_/eclipse-temurin)

## Image Tags

```bash
REPOSITORY               TAG                 SIZE
blacktop/ghidra          latest              1.45GB
blacktop/ghidra          10                  1.45GB
blacktop/ghidra          10-beta             1.4GB
blacktop/ghidra          9.2                 1.33GB
blacktop/ghidra          9.1                 1.18GB
blacktop/ghidra          9.0                 1.18GB
```

> **NOTE:** tag `beta` is built from `master`

## Getting Started

### Client

#### On macOS

1. Install XQuartz `brew install xquartz`
2. Install socat `brew install socat`
3. `open -a XQuartz` and make sure you **"Allow connections from network clients"** (in XQuartz > Preferences... > Security)
4. Now add the IP using Xhost with: `xhost + 127.0.0.1` or `xhost + $(ipconfig getifaddr en0)`
5. Start socat `socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`
6. Start up Ghidra

```bash
$ docker run --init -it --rm \
             --name ghidra \
             --cpus 2 \
             --memory 4g \
             -e MAXMEM=4G \
             -e DISPLAY=host.docker.internal:0 \
             -v /path/to/samples:/samples \
             -v /path/to/projects:/root \
             blacktop/ghidra
```

### Server

```bash
$ docker run --init -it --rm \
             --name ghidra-server \
             --cpus 2 \
             --memory 500m \
             -e MAXMEM=500M \           
             -e GHIDRA_USERS="root blacktop" \
             -v /path/to/repos:/repos \
             blacktop/ghidra server
```

### Headless

```bash
$ docker run --init -it --rm \
             --name ghidra-headless \
             --cpus 2 \
             --memory 4g \
             -e MAXMEM=4G \
             -v `pwd`:/samples \
             --link ghidra-server \
             blacktop/ghidra:beta support/analyzeHeadless ghidra://ghidra-server:13100/Apple/12.4.1/ -import /samples/dyld_shared_cache -connect blacktop -p -commit "Loading Dyld."
```

> **Note**
> To run just the server _(and connect from other GUI clients etc)_ you must expose the ports

```bash
$ docker run --init -it --rm \
             --name ghidra-server \
             --cpus 2 \
             --memory 500m \
             -p 13100:13100 \
             -p 13101:13101 \
             -p 13102:13102 \
             -e MAXMEM=500M \
             -e GHIDRA_USERS="root blacktop" \
             -v /path/to/repos:/repos \
             blacktop/ghidra server
```

## TODO

- [ ] Figure out how to add `--network none` :wink:
- [ ] Figure out how to add `--read-only`

## Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-ghidra/issues/new)

### Black Background Issue

If the Ghidra opens in XQuartz with a black background, try closing XQuartz, executing `defaults write org.xquartz.X11 enable_render_extension 0` in terminal. See [issue #31](https://github.com/XQuartz/XQuartz/issues/31) on XQuartz GitHub repo for more information.

## Credits

- NSA Research Directorate [https://github.com/NationalSecurityAgency/ghidra](https://github.com/NationalSecurityAgency/ghidra)

### License

Apache License (Version 2.0)
