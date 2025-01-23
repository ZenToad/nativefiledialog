@echo off
setlocal enableextensions enabledelayedexpansion

set target_include=-I..\include
set target_src=
set target_lib=..\lib\nfd_win.lib Ole32.lib shell32.lib /NODEFAULTLIB:libcmt
@REM set target_lib=..\lib\nfd_win.lib comctl32.lib /NODEFAULTLIB:libcmt
set target_flags=
set compiler=cl
set configuration=debug
REM  set verbose=/VERBOSE
set verbose=
REM Get the full path to the target source file

if "%1"=="" (
    echo No source file provided.
    goto end
)

set target_c=%1

rem Extract the filename without the path
for %%f in ("!target_c!") do set filename=%%~nf

rem Append .exe extension
set target_exe=!filename!.exe

set target_c=..\!target_c!
echo Target Source: ..\!target_c!
echo Target Executable: !target_exe!

if not exist bin mkdir bin

REM MT for statically linked CRT, MD for dynamically linked CRT
set win_runtime_lib=MDd
set common_c=!target_c! !target_src! /Fe:!target_exe! -nologo !target_flags! -FC -EHa- !target_include!
set common_l=!verbose! !target_lib!
echo !common_c!
echo !common_l!

echo.
echo Compiling...
pushd bin
    cl !common_c! -!win_runtime_lib! /Zi /link !common_l!
    if "%ERRORLEVEL%" EQU "0" (
        goto good
    )
    if "%ERRORLEVEL%" NEQ "0" (
        echo Compile or link error occurred.
        goto bad
    )
    :good
        echo.
        xcopy !target_exe! ..\build /i /y
        goto done
    :bad
        echo FAILED
        exit /b 1
        goto done
    :done

popd

:end

endlocal

