@echo off
REM run biomine visualiser - assumes dm code is in codebase\dm
REM data dir provided as argument (or use current dir). Results assumed to be in subdirectory results/

set filename=dm_PROB_nodates_candidates.bmg 

if -%1- == -- (
	set dir=.
) else (
	set dir=%1
)
set file=%dir%\dm\%filename%

if NOT EXIST "%file%" (
	echo biomine: %file% does not exist 1>&2
	exit/B 1
)

REM use start to avoid blocking current shell. biomine diagnostics still appear on shell, however
start/B java -jar %TCROOT%/../dm/chartex/biomine/bmvis2/dist/bmvis2-monolithic.jar %file%
