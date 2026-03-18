@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Initialize
if "%~2"=="--i-want-to-create-config-here" (
    if not exist "%~dp0Functions" mkdir "%~dp0Functions"
    
    if not exist "%~dp0csh.cmd" (
        echo @echo off > "%~dp0csh.cmd"
        echo "%~dp0cmdsh.cmd" %%* >> "%~dp0csh.cmd"
    )
    
    if not exist "%~dp0startup.cmd" ( 
        echo :: This script will launch on startup of cSH > "%~dp0startup.cmd" )
    if not exist "%~dp0.config" mkdir "%~dp0.config"
    
    if not exist "%~dp0.config\.config" (
        (
            echo enable_flashfetch_on_startup=true
            echo enable_start.cmd_on_startup=true
            echo use_functions=true
            echo startup_path=default
        ) > "%~dp0.config\.config"
    )
    if not exist "%~dp0sandbox" ( mkdir sandbox )
)

if "%~3" == "--installer" ( exit )

:: Loading the config
if exist "%~dp0.config\.config" (
    :: Using the full path ensures it loads even if the 'current directory' changes
    for /f "usebackq tokens=1,2 delims==" %%A in ("%~dp0.config\.config") do (
        set "%%A=%%B"
    )
)
:: load config
if not "%~1"=="" ( 
    cd /d "%~1" 
) else (
    if /i "%startup_path%" == "default" ( 
        cd /d "%USERPROFILE%" 
    ) else (
        if exist "%startup_path%" (
            cd /d "%startup_path%" 
        ) else ( 
            echo Path not found^, going to the default path^.
            echo Please check your config default path^.
            cd /d "%USERPROFILE%" 
        ) 
    ) 
)
:: default path
if "%use_functions%" == "true" ( set "PATH=%PATH%;%~dp0Functions" )
:: PATH
:: flashfetch thing
if "%enable_flashfetch_on_startup%" == true ( where flashfetch >nul 2>nul && flashfetch )

:: ANSI Colors
set "ESC="
set "G=%ESC%[92m"
set "R=%ESC%[91m"
set "C=%ESC%[96m"
set "W=%ESC%[0m"

:: Identity
set "currHost=%COMPUTERNAME%"
net session >nul 2>&1
if %errorLevel% == 0 (set "privs=root") else (set "privs=%USERNAME%")
set "symCol=%G%"

:: Startup
if "%enable_start.cmd_on_startup%" == "true" ( if exist %~dp0startup.cmd call %~dp0startup.cmd )

:main_loop
set "input="
set "linuxPath=%cd:\=/%"

echo !symCol!╭%G%!privs!@%currHost% %C%!linuxPath!
set /p input=!symCol!╰^> %W%

if /i "!input!"=="exit" goto :eof
if /i "!input!"=="cls" cls & goto main_loop
if "!input!"=="" goto main_loop

:: Run whatever was typed
title cmdSH - [!input!]
call %input%
title cmdSH - %cd%
if %errorlevel% equ 0 (set "symCol=%G%") else (set "symCol=%R%")

goto main_loop

echo This piece of code will never run.
