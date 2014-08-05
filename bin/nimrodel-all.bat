@echo off
setlocal EnableDelayedExpansion

REM run %TCAPP% command on files given as arguments - assumed to be .txt, output in .ann
REM if none then run on all the txt files in current directory
REM assume environment set up so we can find %TCAPP% command

if -%1-==--model- (
	set model=-model %2
	shift
	shift
) else (
	set model=
)

if -%1-==--language- (
	set language=-language %2
	shift
	shift
) else (
	set language=
)

if -%1-==-- (
	REM no filename args - do all text files in folder
	set files=*.txt
) else (
	REM shift doesn't change %*, so we need to collect up any remaining filename args manually
	set files=
	:loop
	set files=%files% %1
	shift
	if NOT -%1-==-- goto loop
)

for %%f in (%files%) do (
	echo %%f 1>&2
	set g=%%f
	set comm=%TCAPP% %model% %language% ^< !g! ^> !g:.txt=.ann!
	cmd /c !comm!
)

endlocal