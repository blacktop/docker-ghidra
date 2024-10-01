FROM gradle:jdk21 as builder

ENV GITHUB_URL https://github.com/NationalSecurityAgency/ghidra.git

RUN apt-get update && apt-get install -y curl git bison flex build-essential unzip

RUN echo "[+] Cloning Ghidra..." \
    && git clone ${GITHUB_URL} /root/git/ghidra

WORKDIR /root/git/ghidra/support/gradle/

RUN echo "[+] Downloading dependencies..." \
    && gradle --init-script fetchDependencies.gradle init

RUN echo "[+] Building Ghidra..." \
    && gradle buildNatives_linux64 \
    && gradle sleighCompile \
    && gradle buildGhidra

WORKDIR /ghidra

RUN echo "[+] Unzip Ghidra..." \
    && unzip /root/git/ghidra/build/dist/ghidra*linux*.zip -d /tmp \
    && mv /tmp/ghidra*/* /ghidra \
    && chmod +x /ghidra/ghidraRun \
    && rm -rf /ghidra/docs /ghidra/Extensions/Eclipse /ghidra/licenses

##########################################################################################
FROM eclipse-temurin:21

LABEL maintainer "https://github.com/blacktop"

COPY --from=builder /ghidra /ghidra

RUN apt-get update && apt-get install -y fontconfig libxrender1 libxtst6 libxi6 --no-install-recommends \
    && echo "===> Clean up unnecessary files..." \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/*

WORKDIR /ghidra

COPY entrypoint.sh /entrypoint.sh
COPY server.conf /ghidra/server/server.conf

RUN mkdir /repos

EXPOSE 13100 13101 13102

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "client" ]