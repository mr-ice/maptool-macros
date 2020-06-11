FROM alpine

RUN apk add --update --no-cache make zip bash git python3 py3-lxml py3-pip

RUN python3 -mpip install tabulate

COPY automagic /usr/local/bin
COPY xc /usr/local/bin
COPY macro-assemble /usr/local/bin
COPY zipfile_infolist.py /usr/local/bin

RUN dos2unix /usr/local/bin/automagic \
  && dos2unix /usr/local/bin/xc \
  && dos2unix /usr/local/bin/macro-assemble

WORKDIR "/MT"

ENTRYPOINT [ "automagic" ]