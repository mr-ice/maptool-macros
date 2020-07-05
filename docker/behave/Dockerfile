FROM maker

RUN python3 -mpip install behave

ENV PYTHONPATH /MT/docker

WORKDIR "/MT"

ENTRYPOINT [ "behave" ]
