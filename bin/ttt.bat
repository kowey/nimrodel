@echo off
REM run TTT processing pipeline on current directory
REM arg specifies data directory - use current dir if absent
setlocal
if -%1- == -- (
	set dir=.
) else (
	set dir=%1
)
cd %dir%
if NOT EXIST dm mkdir dm

call nimrodel-all
call dm 
call biomine 

endlocal