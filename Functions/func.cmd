@echo off
setlocal enabledelayedexpansion

:: --- Configuration & Paths ---
:: Using %~dp0 here refers to the Functions folder. 
:: We go up one level to find the .config folder created by cmdsh.cmd.
set "ESC="
set "baseDir=%~dp0.."
set "configDir=!baseDir!\.config"
set "configPath=!configDir!\funcpath"
set "saveDir=!configDir!\saved"
set "funcDir=%~dp0"

:: --- Initialization ---
if not exist "!configDir!" mkdir "!configDir!" [cite: 2]
if not exist "!saveDir!" mkdir "!saveDir!"
if not exist "!configPath!" (
    (
        echo # Default Repository
        echo https://raw.githubusercontent.com/ARandomAxolotl/cmdSH/main/Functions/
        echo # Add more GitHub Raw URLs below
    ) > "!configPath!"
)

:: --- Command Router ---
set "cmd=%~1"
set "target=%~2"

if /i "!cmd!" == "install"        goto :install
if /i "!cmd!" == "uninstall"      goto :uninstall
if /i "!cmd!" == "reinstall"      goto :reinstall
if /i "!cmd!" == "list"           goto :list
if /i "!cmd!" == "update"         goto :update
if /i "!cmd!" == "add-repo"       goto :addrepo
if /i "!cmd!" == "search"         goto :search
if /i "!cmd!" == "remake-config"  goto :remake
if /i "!cmd!" == "purge"          goto :purge

echo %ESC%[33mcSH Package Manager%ESC%[0m
echo Usage: %~n0 [install ^| uninstall ^| reinstall ^| list ^| update ^| add-repo ^| search ^| purge]
goto :end

:: --- Logic Blocks ---

:install
set "found=false"
echo %ESC%[36mSearching repositories...%ESC%[0m
for /f "usebackq tokens=*" %%U in (`findstr /V /B "#" "!configPath!"`) do (
    if "!found!"=="false" (
        curl -f -s "%%U!target!.cmd" --output "!funcDir!!target!.cmd"
        if not errorlevel 1 ( set "found=true" & set "winner=%%U" )
    )
)
if "!found!"=="true" (
    echo %ESC%[32m[Success]%ESC%[0m Installed !target! from !winner!
) else (
    echo %ESC%[31m[Error]%ESC%[0m Function "!target!" not found.
    if exist "!funcDir!!target!.cmd" del "!funcDir!!target!.cmd"
)
goto :end

:addrepo
if "!target!" == "" ( echo %ESC%[31m[Error]%ESC%[0m No URL provided. & goto :end )
findstr /C:"!target!" "!configPath!" >nul
if %errorlevel% == 0 (
    echo %ESC%[33m[Notice]%ESC%[0m Repository already exists.
) else (
    echo !target! >> "!configPath!"
    echo %ESC%[32m[Success]%ESC%[0m Repository added.
)
goto :end

:search
if "!target!" == "" ( echo %ESC%[31m[Error]%ESC%[0m Specify a keyword. & goto :end )
echo %ESC%[36mSearching for "!target!"...%ESC%[0m
for %%F in ("!saveDir!\*.txt") do (
    for /f "tokens=4 delims=:," %%G in ('findstr /i "name" "%%F" ^| grep -i "!target!"') do (
        set "raw=%%~G" & set "clean=!raw: ="!" & set "clean=!clean:"=!"
        if /i "!clean:~-4!" == ".cmd" echo  - !clean:.cmd=! %ESC%[90m(In %%~nxF)%ESC%[0m
    )
)
goto :end

:update
echo %ESC%[36mUpdating Caches...%ESC%[0m
for /f "usebackq tokens=*" %%U in (`findstr /V /B "#" "!configPath!"`) do (
    set "api=%%U"
    set "api=!api:raw.githubusercontent.com=api.github.com/repos!"
    set "api=!api:/main/=/contents/!"
    set "api=!api:/master/=/contents/!"
    set "sName=%%U" & set "sName=!sName::=!" & set "sName=!sName:/=_!"
    echo Fetching: %%U
    curl -s "!api!" > "!saveDir!\!sName!.txt"
)
goto :end

:list
if /i "!target!" == "--installed" (
    echo %ESC%[36mInstalled:%ESC%[0m
    for %%F in ("!funcDir!*.cmd") do (
        for %%A in ("%%F") do set "fTime=%%~tA"
        echo  - %%~nF %ESC%[90m(!fTime!)%ESC%[0m
    )
) else (
    echo %ESC%[36mAvailable (Cached):%ESC%[0m
    for %%F in ("!saveDir!\*.txt") do (
        echo %ESC%[33mSource: %%~nxF%ESC%[0m
        for /f "tokens=4 delims=:," %%G in ('findstr /i "name" "%%F"') do (
            set "raw=%%~G" & set "clean=!raw: ="!" & set "clean=!clean:"=!"
            if /i "!clean:~-4!" == ".cmd" echo  - !clean:.cmd=!
        )
    )
)
goto :end

:uninstall
if exist "!funcDir!!target!.cmd" ( 
    del "!funcDir!!target!.cmd" 
    echo %ESC%[32m[Success]%ESC%[0m Uninstalled. 
) else ( 
    echo %ESC%[31m[Error]%ESC%[0m Not found. 
)
goto :end

:remake
(
    echo # Default Repository
    echo https://raw.githubusercontent.com/ARandomAxolotl/cmdSH/main/Functions/
    echo https://raw.githubusercontent.com/ARandomAxolotl/cmdsh-package-repo/main/
) > "!configPath!"
echo %ESC%[32m[Success]%ESC%[0m Config reset.
goto :end

:purge
set /p "conf=Purge all? (y/N): "
if /i "!conf!"=="y" ( 
    rd /s /q "!funcDir!"
    rd /s /q "!configDir!"
    echo %ESC%[31mPurged. Restart shell to re-initialize.%ESC%[0m
    exit /b 
)
goto :end

:end
endlocal
