FROM maker

RUN python3 -mpip install wheel behave

ENV PYTHONPATH /MT/docker

WORKDIR "/MT"

ENTRYPOINT [ "behave" ]
