FROM maker

RUN python3 -mpip install wheel pytest pytest-sugar

WORKDIR "/MT"

ENTRYPOINT [ "python3", "-m", "pytest" ]
