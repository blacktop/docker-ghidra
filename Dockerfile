FROM openjdk:jdk-slim

ENV VERSION 9.0
ENV GHIDRA_SHA 3b65d29024b9decdbb1148b12fe87bcb7f3a6a56ff38475f5dc9dd1cfc7fd6b2

RUN apt-get update && apt-get install -y wget \
    && wget --progress=bar:force -O /tmp/ghidra.zip  https://www.ghidra-sre.org/ghidra_9.0_PUBLIC_20190228.zip; \
    if [ "$GHIDRA_SHA" ]; then \
    echo "$GHIDRA_SHA /tmp/ghidra.zip" | sha256sum -c -; \
    fi; \
    cd /tmp \
    && unzip ghidra.zip \
    && mv ghidra_${VERSION} /ghidra \
    && chmod +x /ghidra/ghidraRun \
    && echo "===> Clean up unnecessary files..." \
    && apt-get purge -y --auto-remove wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/*

WORKDIR /ghidra

ENV MAXMEM 2G

# Resolve symbolic link if present and get the directory this script lives in.
# NOTE: "readlink -f" is best but works on Linux only, "readlink" will only work if your PWD
# contains the link you are calling (which is the best we can do on macOS), and the "echo" is the
# fallback, which doesn't attempt to do anything with links.
ENV SCRIPT_FILE=/ghidra/ghidraRun
ENV SCRIPT_DIR=/ghidra

# Launch Ghidra
ENTRYPOINT ["/ghidra/support/launch.sh", "fg", "Ghidra", "768M", "", "ghidra.GhidraRun"]