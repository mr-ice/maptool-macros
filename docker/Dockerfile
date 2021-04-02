FROM azul/zulu-openjdk-alpine:14
#FROM alpine

RUN apk add --update --no-cache make zip bash git python3 py3-lxml py3-pip curl

RUN python3 -mpip install tabulate

COPY assemble /usr/local/bin
COPY extract /usr/local/bin
COPY zipfile_infolist.py /usr/local/bin
COPY MTAssetLibrary/* /usr/local/bin/MTAssetLibrary/

RUN dos2unix /usr/local/bin/assemble \
  && dos2unix /usr/local/bin/extract

RUN mkdir -p /tmp/fetch \
  && cd /tmp/fetch \
  && curl -s -LO https://github.com/RPTools/maptool/releases/download/1.8.4/MapTool-1.8.4.jar

ENV CLASSPATH /tmp/fetch/MapTool-1.8.4.jar:.

WORKDIR "/MT"

ENTRYPOINT [ "assemble" ]
