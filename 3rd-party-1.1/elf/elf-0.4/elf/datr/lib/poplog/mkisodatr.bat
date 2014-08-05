@echo off
rem --- Copyright University of Sussex 1994. All rights reserved. ----------
rem File:             $poplocal/local/pop/mkdatr.bat
rem Purpose:          Rebuild DATR saved image - isoprolog version
rem Author:           Roger Evans, Dec 11 2002
rem Documentation:    HELP *DATR

setlocal

rem note use of '$poplocal' (etc) here. Shell does not interpret these, so
rem they are passed through to poplog, which expands them *after* it has
rem set their default values if necessary
%usepop%\pop\pop\pop11 +startup %%nort $popliblib/mkimage.p -subsystem datr $poplocalbin/datr.psv isoprolog datr datr_subsystem

endlocal
