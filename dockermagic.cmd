@echo off
setlocal
docker image inspect maker > nul
if ERRORLEVEL 1 call :build_it

docker run --rm -it --mount type=bind,source="%CD%",target=/MT maker %1
endlocal
goto eof

:build_it
call dockerbuild.cmd

:eof
rem teh end
