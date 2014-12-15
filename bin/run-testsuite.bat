@echo off
setlocal

call %~dp0/env

swipl -q -f %ELFAPP%\..\harness.pl -g main -t halt

endlocal
