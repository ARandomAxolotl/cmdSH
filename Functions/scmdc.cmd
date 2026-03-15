@echo off
setlocal EnableDelayedExpansion

:setup
set "path_replace=@"

pushd "%~dp0.."
set "replace_with=%CD%\sandbox"
popd

:start_replace
set "input=%~1.scmd"
set "output=%~1.cmd"

(for /f "usebackq delims=" %%A in ("%input%") do (
    set "line=%%A"
    set "line=!line:%path_replace%=%replace_with%!"
    echo !line!
)) > "%output%"