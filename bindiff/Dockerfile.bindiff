# FROM openjdk:11-jdk-slim
FROM openjdk:11-jre-slim

ENV VERSION 9.1.2_PUBLIC
ENV GHIDRA_SHA ebe3fa4e1afd7d97650990b27777bb78bd0427e8e70c1d0ee042aeb52decac61
ENV BINDIFF_SHA a3aa38579454e742189954e8e4006427684c08f8616fa754de8fa4d5be4adfbb

RUN apt-get update && apt-get install -y fontconfig libxrender1 libxtst6 libxi6 wget unzip --no-install-recommends \
    && wget --progress=bar:force -O /tmp/ghidra.zip https://www.ghidra-sre.org/ghidra_9.1.2_PUBLIC_20200212.zip \
    && echo "$GHIDRA_SHA /tmp/ghidra.zip" | sha256sum -c - \
    && unzip /tmp/ghidra.zip \
    && mv ghidra_${VERSION} /ghidra \
    && chmod +x /ghidra/ghidraRun \
    && echo "===> Install BinDiff 7..." \
    && wget --progress=bar:force -O /tmp/bindiff_7_amd64.deb https://storage.googleapis.com/bindiff-releases/updated-20210607/bindiff_7_amd64.deb \
    && echo "$BINDIFF_SHA /tmp/bindiff_7_amd64.deb" | sha256sum -c - \
    && apt-get install -y fonts-roboto xdg-utils debconf --no-install-recommends \
    && yes | apt install -y /tmp/bindiff_7_amd64.deb \
    # && apt --fix-broken install \
    # && yes no | apt-get install -f --no-install-recommends \
    # && DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/bindiff_6_amd64.deb \
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