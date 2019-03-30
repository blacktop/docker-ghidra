FROM openjdk:11-jdk-slim

ENV VERSION 9.0.1
ENV GHIDRA_SHA 58ffa488e6dc57e2c023670c1dfac0469bdb6f4e7da98f70610d9f561b65c774

RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget --progress=bar:force -O /tmp/ghidra.zip  https://www.ghidra-sre.org/ghidra_9.0.1_PUBLIC_20190325.zip \
    &&  echo "$GHIDRA_SHA /tmp/ghidra.zip" | sha256sum -c - \
    && unzip /tmp/ghidra.zip \
    && mv ghidra_${VERSION} /ghidra \
    && chmod +x /ghidra/ghidraRun \
    && echo "===> Clean up unnecessary files..." \
    && apt-get purge -y --auto-remove wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/* /ghidra/docs /ghidra/Extensions/Eclipse /ghidra/licenses

WORKDIR /ghidra

COPY entrypoint.sh /entrypoint.sh
COPY server.conf /ghidra/server/server.conf

EXPOSE 13100 13101 13102
RUN mkdir /repos
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "client" ]