@echo off

call %~dp0\configure.bat

IF DEFINED %TCAPP% goto end_of_file


set LOCALENV=%~dp0\local.bat
IF EXIST %LOCALENV% ( 
	call %LOCALENV%
)

if DEFINED ProgramFiles(x86) (
	if NOT DEFINED SWI_HOME_DIR set "SWI_HOME_DIR=%ProgramFiles(x86)%\pl"
	if NOT DEFINED JAVA_HOME SET "JAVA_HOME=%ProgramFiles(x86)%\Java\jre7"
) else (
	if NOT DEFINED SWI_HOME_DIR set "SWI_HOME_DIR=%ProgramFiles%\pl"
	if NOT DEFINED JAVA_HOME SET "JAVA_HOME=%ProgramFiles%\Java\jre7"
)

if NOT DEFINED TCROOT set "TCROOT=%~dp0\.."
if NOT DEFINED TC set "TC=%TCROOT%"
set ELFAPP=%TC%\%TCAPP%
set ELFROOT=%TCROOT%\3rd-party\elf
set ELF=%ELFROOT%\elf

set PATH=%TC%\bin;%SWI_HOME_DIR%\bin;%JAVA_HOME%\bin;%PATH%
set CLASSPATH=.;%ELFAPP%;%ELFROOT%\opennlp\lib\jpl.jar;%ELFROOT%\opennlp\lib\opennlp-tools-1.5.3.jar;%ELFROOT%\opennlp\lib\opennlp-maxent-3.0.3.jar

set "%TCAPP%=%ELFAPP%"

:end_of_file