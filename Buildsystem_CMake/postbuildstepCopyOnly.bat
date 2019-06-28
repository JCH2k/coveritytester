@echo off
setlocal EnableDelayedExpansion
echo(
echo --- %~nx0 -----------------------
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: postbuildstep.bat
:: parameters %1 BuildArtifactFileName e.g. "UserArea.exe" (${BuildArtifactFileName})
::            %2 BuildArtifactFileBaseName e.g. "UserArea" (${BuildArtifactFileBaseName}) NOT USED
::            %3 ProjRootPath e.g. "." (${CMAKE_SOURCE_DIR})
::            %4 BuildType e.g. Debug, Release, RelWithDebInfo or MinSizeRel (optional)
::            %5 to activate UnitTest handling set this parameter to 1 (optional)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set BuildArtifactFileName=%1
set BuildArtifactFileBaseName=%2
set ProjRootPath=%3
set BuildType=%4
set UnitTest=%5

:: check if too many arguments passed
if "%6" NEQ "" (
    echo Too many arguments passed
    call :help
    exit /B 1
)

:: check that mandatory arguments are passed
if "%BuildArtifactFileName%"=="" (
     echo Wrong arguments passed
     call :help
     exit /B 1
)
REM if "%BuildArtifactFileBaseName%"=="" (
REM      echo Wrong arguments passed
REM      call :help
REM      exit /B 1
REM )
if "%ProjRootPath%"=="" (
     echo Wrong arguments passed
     call :help
     exit /B 1
)

:: set default parameters if none are given
if "%BuildType%"=="" set BuildType="Release"

if "%UnitTest%"=="1" (
    call :unittest
) else (
    call :firmware
)

if !ERRORLEVEL! NEQ 0 (
    echo Error executing postbuildsteps
    echo -----------------------------------------------------
    echo(
    exit /B 1
) else (
    echo -----------------------------------------------------
    echo(
    exit /B 0
)

:: function section
:help
    echo Syntax: postbuildstepCopyOnly.bat BuildArtifactFileName("UserArea.exe") BuildArtifactFileBaseName("UserArea") ProjRootPath BuildType
    echo -----------------------------------------------------
    echo(
    exit /B 1

:createOutputDirectory
    if not exist "%OutputDirectory%/" (
        mkdir "%OutputDirectory%/"
        if !ERRORLEVEL! NEQ 0 (
            echo Could not create directory '%OutputDirectory%'
            exit /B 1
        )
    )
    exit /B 0

:copyFileToOutputDirectory
    :: argument is filename
    copy "%~1" "%OutputDirectory%/" /Y >nul
    if !ERRORLEVEL! NEQ 0 (
        exit /B 1
    )
    echo # "%~1" copied to "%OutputDirectory%"
    exit /B 0

:unittest
    :: output folder is UnitTest folder in the build type subfolder in the Distribution folder
    set OutputDirectory=%ProjRootPath%\Distribution\%BuildType%\UnitTest
    set OutputDirectory=%OutputDirectory:\=/%
    call :createOutputDirectory
    if !ERRORLEVEL! NEQ 0 (
        echo Error creating output directory
        exit /B 1
    )

    call :copyFileToOutputDirectory "%BuildArtifactFileName%"
    if !ERRORLEVEL! NEQ 0 (
        echo Error copy file to output directory
        exit /B 1
    )
    exit /B 0

:firmware
    :: output folder is the build type subfolder in the Distribution folder
    set OutputDirectory=%ProjRootPath%\Distribution\%BuildType%
    set OutputDirectory=%OutputDirectory:\=/%
    call :createOutputDirectory
    if !ERRORLEVEL! NEQ 0 (
        echo Error creating output directory
        exit /B 1
    )

    :: special handling for MainApp...
    if exist "%ProjRootPath%/App" copy "%BuildArtifactFileName%" "%ProjRootPath%/App/" /Y >nul

    call :copyFileToOutputDirectory "%BuildArtifactFileName%"
    if !ERRORLEVEL! NEQ 0 (
        echo Error copy encrypted binary file to output directory
        exit /B 1
    )
    exit /B 0