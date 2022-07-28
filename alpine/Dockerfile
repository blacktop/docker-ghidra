FROM alpine:3.14

ENV VERSION 10.1.5_PUBLIC
ENV GHIDRA_SHA 17db4ba7d411d11b00d1638f163ab5d61ef38712cd68e462eb8c855ec5cfb5ed
ENV GHIDRA_URL https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.1.5_build/ghidra_10.1.5_PUBLIC_20220726.zip

RUN apk add --no-cache openjdk11-jre bash

RUN apk add --no-cache -t .build-deps wget ca-certificates unzip \
    && wget --progress=bar:force -O /tmp/ghidra.zip ${GHIDRA_URL} \
    && echo "${GHIDRA_SHA}  /tmp/ghidra.zip" | sha256sum -c - \
    && unzip /tmp/ghidra.zip \
    && mv ghidra_${VERSION} /ghidra \
    && chmod +x /ghidra/ghidraRun \
    && echo "===> Clean up unnecessary files..." \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/* \
    && rm -rf /ghidra/docs \
    && rm -rf /ghidra/licenses \
    && rm -rf /ghidra/Extensions/Ghidra \
    && rm -rf /ghidra/Extensions/Eclipse \
    && find /ghidra -type f -name "*src*.zip" -exec rm -f {} \; \
    && apk del --purge .build-deps

WORKDIR /ghidra

COPY entrypoint.sh /entrypoint.sh
COPY server.conf /ghidra/server/server.conf

EXPOSE 13100 13101 13102
RUN mkdir /repos
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "client" ]