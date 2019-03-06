![logo](https://raw.githubusercontent.com/blacktop/docker-ghidra/master/ghidra.png)

# docker-ghidra

[![License](https://img.shields.io/badge/licence-Apache%202.0-blue.svg)](LICENSE) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/ghidra.svg)](https://hub.docker.com/r/blacktop/ghidra/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/ghidra.svg)](https://hub.docker.com/r/blacktop/ghidra/) [![Docker Image](https://img.shields.io/badge/docker%20image-1.28GB-blue.svg)](https://hub.docker.com/r/blacktop/ghidra/)

# docker-ghidra

> Ghidra Docker Image

---

## Why?

Cuz Java is gross. :smirk:

## Dependencies

- [openjdk:jre-slim](https://hub.docker.com/_/openjdk)

## Image Tags

```bash
REPOSITORY               TAG                 SIZE
blacktop/ghidra          latest              1.08GB
blacktop/ghidra          9.0                 1.08GB
```

## Getting Started

### On macOS

1. Install XQuartz

```bash
$ brew cask install xquartz
```

2. `open -a XQuartz` and make sure you "Allow connections from network clients"

3. Now add the IP using Xhost with: `xhost + $(ipconfig getifaddr en0)`

4. Start up Ghidra

```bash
$ docker run --init --rm --name ghidra \
             -v /tmp/.X11-unix:/tmp/.X11-unix \
             -e DISPLAY=$(ipconfig getifaddr en0):0 \
             blacktop/ghidra
```

## Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-ghidra/issues/new)

## Credits

- NSA [https://www.ghidra-sre.org/](https://www.ghidra-sre.org/)

### License

Apache License (Version 2.0)
