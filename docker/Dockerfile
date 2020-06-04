FROM alpine

RUN apk add --update --no-cache make zip bash

COPY automagic /usr/local/bin

WORKDIR "/MT"

CMD ["automagic"]
