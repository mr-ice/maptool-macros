FROM alpine

RUN apk add --update --no-cache make zip bash git python3 py3-lxml py3-pip

RUN python3 -mpip install tabulate

COPY automagic /usr/local/bin
COPY macro-assemble /usr/local/bin
COPY macro-extract /usr/local/bin
COPY token-assemble /usr/local/bin
COPY token-extract /usr/local/bin
COPY zipfile_infolist.py /usr/local/bin
COPY project-assemble /usr/local/bin
COPY MTAssetLibrary.py /usr/local/bin

RUN dos2unix /usr/local/bin/automagic \
  && dos2unix /usr/local/bin/macro-assemble \
  && dos2unix /usr/local/bin/macro-extract \
  && dos2unix /usr/local/bin/token-assemble \
  && dos2unix /usr/local/bin/token-extract \
  && dos2unix /usr/local/bin/project-assemble

WORKDIR "/MT"

ENTRYPOINT [ "automagic" ]
