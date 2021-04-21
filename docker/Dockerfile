FROM azul/zulu-openjdk-alpine:14

RUN apk add --update --no-cache make zip bash git python3 py3-lxml py3-pip curl

RUN python3 -mpip install tabulate

RUN mkdir -p /usr/local/libexec

COPY assemble /usr/local/bin
COPY extract /usr/local/bin
COPY zipfile_infolist.py /usr/local/bin
COPY MTAssetLibrary/* /usr/local/bin/MTAssetLibrary/
COPY CampaignMerge /usr/local/bin
COPY CampaignMerge.java /usr/local/libexec

RUN dos2unix /usr/local/bin/assemble \
  && dos2unix /usr/local/bin/extract \
  && dos2unix /usr/local/bin/CampaignMerge \
  && chmod 755 /usr/local/bin/CampaignMerge \
    /usr/local/bin/assemble \
    /usr/local/bin/extract

ARG maptool_version=1.8.5
ADD https://github.com/RPTools/maptool/releases/download/$maptool_version/MapTool-$maptool_version.jar /usr/local/libexec/

ENV CLASSPATH /usr/local/libexec/MapTool-$maptool_version.jar:/usr/local/libexec
RUN javac /usr/local/libexec/CampaignMerge.java

WORKDIR "/MT"

ENTRYPOINT [ "assemble" ]
