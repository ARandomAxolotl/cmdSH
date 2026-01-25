@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Initialize
if not "%1"=="" cd %~1
if "%~2"=="--i-want-to-create-config-here" (
if not exist "%~dp0Functions" mkdir "%~dp0Functions"
set "PATH=%PATH%;%~dp0Functions"
if not exist "%~dp0csh.cmd" (
	echo ^@echo off > csh.cmd
	echo %~dp0cmdsh.cmd %* >> csh.cmd
)
if not exist "%~dp0startup.cmd" ( echo ^:^: This script will launch on startup of cSH > startup.cmd )
)

:: flashfetch thing
where flashfetch >nul 2>nul && flashfetch

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
if exist %~dp0startup.cmd call %~dp0startup.cmd

:main_loop
set "input="
set "linuxPath=%cd:\=/%"

echo !symCol!╭%G%!privs!@%currHost% %C%!linuxPath!
set /p input=!symCol!╰^> %W%

if /i "%input%"=="exit" goto :eof
if /i "%input%"=="cls" cls & goto main_loop
if "%input%"=="" goto main_loop

:: Run whatever was typed
title cmdSH - [!input!]
call %input%
title cmdSH - %cd%
if %errorlevel% equ 0 (set "symCol=%G%") else (set "symCol=%R%")

goto main_loop