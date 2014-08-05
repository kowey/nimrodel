#!/bin/csh -f
# --- Copyright University of Sussex 1994. All rights reserved. ----------
# File:             $DATR/poplog/install_datr
# Purpose:          Installing Poplog/DATR interface
# Author:           Roger Evans
# Documentation:    HELP *DATR
# RCS Data:         $Id: install_datr 1.7 1999/04/23 22:03:59 rpe Exp $

set INSTALL = `which install`

# get value for datr root
set DATR=$cwd
set DATR=$DATR:h
set DATR=$DATR:h
if ( ! -r $DATR/builtin/poplog.pl ) then
    echo ${0}: grandparent directory is not DATR system directory - aborting
    exit 1
endif

if ("`pop11 ':npr(pop_internal_version<142200)'`" == "<true>" ) then
    echo ${0}: 'Poplog version must be 14.22 or newer'
    exit 1
endif

if ( ! $?poplocal ) then
    echo ${0}: '$poplocal not defined'
    exit 1
else
    echo installing Poplog files in $poplocal...
endif

# edit correct default datr dir into header dir and install
sed "s%DATR_DIR_UNDEFINED%$DATR%" datr.ph > /tmp/datr.ph
$INSTALL -m 644 /tmp/datr.ph $poplocal/local/include/datr.ph
rm -f /tmp/datr.ph

# edit it into the main DATR system file too and install
sed "s%/usr/local/datr/%$DATR/%" ../../directory.pl > /tmp/directory.pl
$INSTALL -m 644 /tmp/directory.pl $DATR/directory.pl
rm -f /tmp/directory.pl


# install other library files
$INSTALL -m 644 datr_directory.p $poplocal/local/auto/datr_directory.p
$INSTALL -m 644 datr_compile.p $poplocal/local/auto/datr_compile.p
$INSTALL -m 644 datr_subsystem.p $poplocal/local/auto/datr_subsystem.p
$INSTALL -m 644 ved_datr.p $poplocal/local/auto/ved_datr.p

$INSTALL -m 644 datr.p $poplocal/local/lib/datr.p
$INSTALL -m 644 datr.pl $poplocal/local/plog/lib/datr.pl
$INSTALL  -m 755 mkdatr.sh $poplocal/local/com/mkdatr.sh

# Look for defunct DATR files in public libraries
foreach f ($poplocal/local/auto/datr_top_compile.p)
    if ( -r $f) then
        echo ${0}: obsolete DATR library found - not needed in this version
        rm -i $f
    endif
end

echo "...done"
