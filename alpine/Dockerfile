FROM alpine:3.14

ENV VERSION 10.2.1_PUBLIC
ENV GHIDRA_SHA f683cfbb583641d27f9dca3c1a59b4172ecd10155d8771bbb28a2e0eaa7c80bb
ENV GHIDRA_URL https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.2.1_build/ghidra_10.2.1_PUBLIC_20221110.zip

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