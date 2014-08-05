@echo off
REM run ChartEx dm - assumes dm code is in codebase\dm
REM arg specifies data directory - use current dir if absent

REM running 32 bit java, so reduced memory size down to 800M (from 1600M)
java -Xmx800M -cp %TCROOT%\..\dm\chartex\ChartEx\bin nl.liacs.chartex.ChartEx %* > dm\dm-out.txt
