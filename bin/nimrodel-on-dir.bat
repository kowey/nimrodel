@echo off
setlocal

call %~dp0/env

swipl -q -f %ELFAPP%\swiprolog.pl -g traverse_dir -t halt -- %*

endlocal
