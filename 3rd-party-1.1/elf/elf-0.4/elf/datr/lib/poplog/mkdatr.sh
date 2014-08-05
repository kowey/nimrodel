#!/bin/sh
# --- Copyright University of Sussex 1994. All rights reserved. ----------
# File:             $poplocal/local/com/mkdatr
# Purpose:          Rebuild DATR saved image
# Author:           Roger Evans, July 29 1992
# Documentation:    HELP *DATR
# RCS Data:         $Id: mkdatr 1.3 1994/07/25 14:38:34 rpe Release $

$popsys/pop11 %nort \
    $popliblib/mkimage.p \
    -subsystem datr\
    $poplocalbin/datr.psv \
    $usepop/pop/plog/src/prolog.p datr datr_subsystem

rm -f $poplocalbin/datr.psv-
