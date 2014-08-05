/* --- Copyright University of Sussex 1994. All rights reserved. ----------
 > File:            $poplocal/local/auto/ved_datr.p
 > Purpose:         VED command to access DATR subsystem
 > Author:          Roger Evans, Mar 29 1994
 > Documentation:   HELP datr
 > Related Files:   lib datr_subsystem, $DATR/...
 > RCS Data:        $Id: ved_datr.p 1.4 1997/12/22 23:33:22 rpe Exp $
 */

/*  ved_datr - ved command for accessing files in the datr subsystem
    context (see veddo_in_subsystem) */

compile_mode :pop11 +strict;

uses datr_subsystem;

section;

define vars ved_datr =
    veddo_in_subsystem(% "datr" %)
enddefine;

endsection;
