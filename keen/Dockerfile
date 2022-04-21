FROM openjdk:11-jdk-slim

ENV VERSION 10.1.2_PUBLIC
ENV GHIDRA_SHA ac96fbdde7f754e0eb9ed51db020e77208cdb12cf58c08657a2ab87cb2694940
ENV GHIDRA_URL https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.1.2_build/ghidra_10.1.2_PUBLIC_20220125.zip
ENV BINABS_URL https://github.com/KeenSecurityLab/BinAbsInspector/releases/download/v0.1/ghidra_10.1.2_PUBLIC_20220420_BinAbsInspector.zip

RUN apt-get update && apt-get install -y fontconfig libxrender1 libxtst6 libxi6 wget unzip git build-essential python3-requests --no-install-recommends \
    && wget --progress=bar:force -O /tmp/ghidra.zip ${GHIDRA_URL} \
    && echo "$GHIDRA_SHA /tmp/ghidra.zip" | sha256sum -c - \
    && unzip /tmp/ghidra.zip \
    && mv ghidra_${VERSION} /ghidra \
    && chmod +x /ghidra/ghidraRun \
    && echo "===> Install Z3..." \
    && git clone https://github.com/Z3Prover/z3.git /tmp/z3 \
    && cd /tmp/z3 \
    && python3 scripts/mk_make.py \
    && cd build \
    && make \
    && make install \
    && echo "===> Install BinAbsInspector..." \
    && wget --progress=bar:force -O /tmp/BinAbsInspector.zip ${BINABS_URL} \
    && unzip /tmp/BinAbsInspector.zip \
    && mv BinAbsInspector /ghidra/Ghidra/Extensions/ \
    && echo "===> Clean up unnecessary files..." \
    && apt-get purge -y --auto-remove wget unzip git build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/* /ghidra/docs /ghidra/Extensions/Eclipse /ghidra/licenses

WORKDIR /ghidra

COPY entrypoint.sh /entrypoint.sh
COPY server.conf /ghidra/server/server.conf

EXPOSE 13100 13101 13102
RUN mkdir /repos
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "client" ]
