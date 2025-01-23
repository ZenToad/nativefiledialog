@echo off
setlocal enableextensions enabledelayedexpansion

set target=nfd_win
set target_c=..\src\nfd_win.cpp ..\src\nfd_common.c
set target_include=-I..\src -I..\src\include

if not exist bin mkdir bin
if not exist lib mkdir lib
if not exist include mkdir include

set win_runtime_lib=MD
set common_c=!target_c! !target_src! -nologo -FC -EHa- !target_include!

echo.
echo Compiling...
pushd bin
    cl !common_c! !target_exp! -c
    lib nfd_win.obj nfd_common.obj
    if "%ERRORLEVEL%" EQU "0" (
        goto good
    )
    if "%ERRORLEVEL%" NEQ "0" (
        goto bad
    )
:good
    echo.
    xcopy !target!.lib ..\lib /i /y
    xcopy ..\src\include\nfd.h ..\include /i /y
    goto done
:bad
    echo FAILED
    goto done
:done

popd

:end

