# Compile binaries for arm support:
FROM gradle:jdk21 AS builder

RUN apt-get update && apt-get install -y curl git bison flex build-essential unzip

ENV VERSION=12.0.1_PUBLIC
ENV GHIDRA_SHA=85bd2990945f3a78df4d1e09f1bb1f40ab77be3bac62c6e7678900788c7f0f41
ENV GHIDRA_URL=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.0.1_build/ghidra_12.0.1_PUBLIC_20260114.zip

RUN apt-get update && apt-get install -y fontconfig libxrender1 libxtst6 libxi6 wget unzip python3-requests --no-install-recommends \
    && wget --progress=bar:force -O /tmp/ghidra.zip ${GHIDRA_URL} \
    && echo "$GHIDRA_SHA /tmp/ghidra.zip" | sha256sum -c - \
    && unzip /tmp/ghidra.zip \
    && mv ghidra_${VERSION} /ghidra \
    && chmod +x /ghidra/ghidraRun \
    && echo "===> Clean up unnecessary files..." \
    && apt-get purge -y --auto-remove wget unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/* /ghidra/docs /ghidra/Extensions/Eclipse /ghidra/licenses

WORKDIR /ghidra/support/gradle

RUN gradle buildNatives

##########################################################################################
FROM eclipse-temurin:21

RUN apt-get update && apt-get install -y fontconfig libxrender1 libxtst6 libxi6 --no-install-recommends \
    && echo "===> Clean up unnecessary files..." \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/*

COPY entrypoint.sh /entrypoint.sh
COPY --from=builder /ghidra /ghidra
COPY server.conf /ghidra/server/server.conf

WORKDIR /ghidra

EXPOSE 13100 13101 13102
RUN mkdir /repos
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "client" ]
