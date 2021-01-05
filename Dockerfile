FROM openjdk:11-jdk-slim

ENV VERSION 9.2.1_PUBLIC
ENV GHIDRA_SHA cfaeb2b5938dec90388e936f63600ad345d41b509ffed4727142ba9ed44cb5e8
RUN apt-get update && apt-get install -y fontconfig libxrender1 libxtst6 libxi6 wget unzip python-requests --no-install-recommends \
    && wget --progress=bar:force -O /tmp/ghidra.zip https://ghidra-sre.org/ghidra_9.2.1_PUBLIC_20201215.zip \
    && echo "$GHIDRA_SHA /tmp/ghidra.zip" | sha256sum -c - \
    && unzip /tmp/ghidra.zip \
    && mv ghidra_${VERSION} /ghidra \
    && chmod +x /ghidra/ghidraRun \
    && echo "===> Clean up unnecessary files..." \
    && apt-get purge -y --auto-remove wget unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/* /ghidra/docs /ghidra/Extensions/Eclipse /ghidra/licenses

WORKDIR /ghidra

COPY entrypoint.sh /entrypoint.sh
COPY server.conf /ghidra/server/server.conf

EXPOSE 13100 13101 13102
RUN mkdir /repos
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "client" ]