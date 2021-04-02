FROM azul/zulu-openjdk-alpine:14
#FROM alpine

RUN apk add --update --no-cache make zip bash git python3 py3-lxml py3-pip

RUN python3 -mpip install tabulate

COPY assemble /usr/local/bin
COPY extract /usr/local/bin
COPY zipfile_infolist.py /usr/local/bin
COPY MTAssetLibrary/* /usr/local/bin/MTAssetLibrary/

RUN dos2unix /usr/local/bin/assemble \
  && dos2unix /usr/local/bin/extract

WORKDIR "/MT"

ENTRYPOINT [ "automagic" ]
