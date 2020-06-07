FROM alpine

RUN apk add --update --no-cache make zip bash git python3 py3-lxml

COPY automagic /usr/local/bin
COPY xc /usr/local/bin

WORKDIR "/MT"

ENTRYPOINT [ "automagic" ]
