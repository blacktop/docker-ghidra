<p align="center">
  <a href="https://github.com/blacktop/docker-ghidra"><img alt="Malice Logo" src="https://raw.githubusercontent.com/blacktop/docker-ghidra/master/ghidra.png" height="140" /></a>
  <a href="https://github.com/blacktop/docker-ghidra"><h3 align="center">docker-ghidra</h3></a>
  <p align="center">Ghidra Docker Image</p>
  <a href="https://hub.docker.com/r/blacktop/ghidra/" alt="Docker Stars">
        <img src="https://img.shields.io/docker/stars/blacktop/ghidra.svg" /></a>
  <a href="https://hub.docker.com/r/blacktop/ghidra/" alt="Docker Pulls">
        <img src="https://img.shields.io/docker/pulls/blacktop/ghidra.svg" /></a>
  <a href="https://hub.docker.com/r/blacktop/ghidra/" alt="Docker Image">
        <img src="https://img.shields.io/badge/docker%20image-1.28GB-blue.svg" /></a>
</p>

---

## Why?

Cuz Java is gross. :smirk:

## Dependencies

- [openjdk:jre-slim](https://hub.docker.com/_/openjdk)

## Image Tags

```bash
REPOSITORY               TAG                 SIZE
blacktop/ghidra          latest              1.28GB
blacktop/ghidra          9.0                 1.28GB
```

## Getting Started

### On macOS

1. Install XQuartz

```bash
$ brew cask install xquartz
```

2. Install socat

```bash
$ brew install socat
```

3. `open -a XQuartz` and make sure you **"Allow connections from network clients"**

4. Now add the IP using Xhost with: `xhost + 127.0.0.1` or `xhost + $(ipconfig getifaddr en0)`

5. Start socat

```bash
$ socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```

6. Start up Ghidra

```bash
$ docker run --init -it --rm --name ghidra \
             -e MAXMEM=2G \
             -e DISPLAY=host.docker.internal:0 \
             -v /path/to/samples:/samples \
             -v /path/to/projects:/root \
             blacktop/ghidra
```

## Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-ghidra/issues/new)

## Credits

- NSA [https://www.ghidra-sre.org/](https://www.ghidra-sre.org/)

### License

Apache License (Version 2.0)
