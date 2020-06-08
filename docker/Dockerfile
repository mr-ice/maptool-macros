FROM alpine

RUN apk add --update --no-cache make zip bash git python3 py3-lxml

COPY automagic /usr/local/bin
COPY xc /usr/local/bin

RUN dos2unix /usr/local/bin/automagic \
  && dos2unix /usr/local/bin/xc

WORKDIR "/MT"

ENTRYPOINT [ "automagic" ]
