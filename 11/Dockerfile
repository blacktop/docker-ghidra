# Compile binaries for arm support:
FROM gradle:jdk17 as builder

RUN apt-get update && apt-get install -y curl git bison flex build-essential unzip

ENV VERSION 11.0.2_PUBLIC
ENV GHIDRA_SHA 4f16ae3f288f8c01fd1872e8e55b25c79744e7b1e8a9383c5e576668ca7d1906
ENV GHIDRA_URL https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.0.2_build/ghidra_11.0.2_PUBLIC_20240326.zip

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

RUN /ghidra/support/buildNatives

##########################################################################################
FROM eclipse-temurin:17

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
