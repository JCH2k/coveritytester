@echo off
setlocal EnableDelayedExpansion
echo(
echo --- %~nx0 -------------------------------
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: postbuildstep.bat
:: parameters %1 BuildArtifactFileName e.g. "UserArea.elf" (${BuildArtifactFileName})
::            %2 BuildArtifactFileBaseName e.g. "UserArea" (${BuildArtifactFileBaseName})
::            %3 ProjRootPath e.g. "." (${CMAKE_SOURCE_DIR})
::            %4 BuildType e.g. Debug, Release, RelWithDebInfo or MinSizeRel (optional)
::            %5 to activate UnitTest handling set this parameter to 1 (optional)
::            %6 SW_IDNO (optional)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set BuildArtifactFileName=%1
set BuildArtifactFileBaseName=%2
set ProjRootPath=%3
set BuildType=%4
set UnitTest=%5
set SW_IDNO=%6

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: hidden parameters which can be predefined
:: FileAppendix
:: InfoblockPathAndFilename
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if "%InfoblockPathAndFilename%"=="" set InfoblockPathAndFilename=UserArea\ESA_Setup\Infoblock.hpp

:: check if too many arguments passed
if "%7" NEQ "" (
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
if "%BuildArtifactFileBaseName%"=="" (
     echo Wrong arguments passed
     call :help
     exit /B 1
)
if "%ProjRootPath%"=="" (
     echo Wrong arguments passed
     call :help
     exit /B 1
)

:: set default parameters if none are given
if "%BuildType%"=="" set BuildType="Release"

:: set helpers
set toolsDir=%~dp0tools

:: delete old bin file
del %BuildArtifactFileBaseName%.bin >nul 2>&1

echo # generate output file in binary format "%BuildArtifactFileBaseName%.bin"
arm-none-eabi-objcopy -O binary "%BuildArtifactFileName%" "%BuildArtifactFileBaseName%.bin"

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
    echo Syntax: postbuildstep.bat BuildArtifactFileName("UserArea.elf") BuildArtifactFileBaseName("UserArea") ProjRootPath BuildType
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

    call :copyFileToOutputDirectory "%BuildArtifactFileBaseName%.bin"
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
    echo # calculate checksum and write it into the file
    %toolsDir%\Buerkert_stmCRC32.exe -i "%BuildArtifactFileBaseName%.bin" -f
    if !ERRORLEVEL! NEQ 0 (
        echo Error calculating CRC
        exit /B 1
    )
    if "%SW_IDNO%"=="" (
        :: start python script to generate new filename and store the output value into variable
        for /f %%i in ('python "%~dp0\generateBinaryName.py" -f "%ProjRootPath%\%InfoblockPathAndFilename%"') do set binaryName=%%i
    ) else (
        :: start python script to extract version and store the output value into variable
        for /f %%i in ('python "%~dp0\versionextract.py" -f "%ProjRootPath%\%InfoblockPathAndFilename%"') do set binaryName=Q1%SW_IDNO%_%%i
    )
    IF !ERRORLEVEL! NEQ 0 (
        echo Error generating binary name
        exit /B 1
    )
    :: append file appendix (if defined, else no appendix)
    set binaryName=%binaryName%%FileAppendix%

    :: delete old bin file
    del %binaryName%.bin >nul 2>&1

    :: rename output file
    echo # rename output file to "%binaryName%.bin"
    ren "%BuildArtifactFileBaseName%.bin" "%binaryName%.bin"

    call :copyFileToOutputDirectory "%binaryName%.bin"
    if !ERRORLEVEL! NEQ 0 (
        echo Error copy binary file to output directory
        exit /B 1
    )

    if "%DisableAES%" NEQ "1" (
        :: create encrypted binary
        echo # generate encrypted binary
        %toolsDir%\Buerkert_AES128.exe "%binaryName%.bin"
        if !ERRORLEVEL! NEQ 0 (
            echo Error encypting binary
            exit /B 1
        )

        call :copyFileToOutputDirectory "%binaryName%-AES.bin"
        if !ERRORLEVEL! NEQ 0 (
            echo Error copy encrypted binary file to output directory
            exit /B 1
        )
    )
    exit /B 0