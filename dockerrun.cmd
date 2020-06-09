@echo off
rem generic docker run with our "mount" stuff, but command/args passed in as if
rem you know what you're doing.
rem
rem for example dockerrun automagic Lib-DNDBeyond
rem or dockerrun bash
rem or dockerrun macro-assemble macro/Single --verbose
setlocal

rem Build docker args
set args=

set entrypoint=%1
shift
rem CMD shift not exactly like bash shift, sad
:continue
if [%1] neq [] (
    if not defined args (set args=%1) else (set args=%args% %1)
    shift
    goto :continue
)

call docker image inspect maker > nul
if ERRORLEVEL 1 call dockerbuild

docker run --rm -it --mount type=bind,source="%CD%",target=/MT --entrypoint %entrypoint% maker %args%
endlocal
