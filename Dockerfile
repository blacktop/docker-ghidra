FROM openjdk:jre-slim

ENV VERSION 9.0
ENV GHIDRA_SHA 3b65d29024b9decdbb1148b12fe87bcb7f3a6a56ff38475f5dc9dd1cfc7fd6b2

RUN apt-get update && apt-get install -y wget \
    && wget --progress=bar:force -O /tmp/ghidra.zip  https://www.ghidra-sre.org/ghidra_9.0_PUBLIC_20190228.zip \
    && cd /tmp \
    && unzip ghidra.zip \
    && mv ghidra_${VERSION} /ghidra \
    && echo "===> Clean up unnecessary files..." \
    && apt-get purge -y --auto-remove wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/*

WORKDIR /ghidra

ENTRYPOINT ["ghidraRun"]