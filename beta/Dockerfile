FROM gradle:jdk11 as builder

ENV GITHUB_URL https://github.com/NationalSecurityAgency/ghidra.git

RUN apt-get update && apt-get install -y curl git bison flex build-essential

RUN echo "[+] Cloning Ghidra..." \
    && git clone ${GITHUB_URL} /root/git/ghidra

WORKDIR /root/git/ghidra

RUN echo "[+] Downloading dependencies..." \
    && gradle --init-script gradle/support/fetchDependencies.gradle init

# RUN gradle buildNatives_linux64
RUN echo "[+] Building Ghidra..." \
    && gradle buildGhidra

##########################################################################################
FROM openjdk:11-jdk-slim

LABEL maintainer "https://github.com/blacktop"

COPY --from=builder /root/git/ghidra/build/dist /ghidra

RUN apt-get update && apt-get install -y fontconfig libxrender1 libxtst6 libxi6 unzip --no-install-recommends \
    && unzip /ghidra/*.zip -d /tmp \
    && rm /ghidra/*.zip \
    && mv /tmp/ghidra_*/* /ghidra \
    && chmod +x /ghidra/ghidraRun \
    && echo "===> Clean up unnecessary files..." \
    && apt-get purge -y --auto-remove unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/* /ghidra/docs /ghidra/Extensions/Eclipse /ghidra/licenses

WORKDIR /ghidra

COPY entrypoint.sh /entrypoint.sh
COPY server.conf /ghidra/server/server.conf

RUN mkdir /repos

EXPOSE 13100 13101 13102

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "client" ]