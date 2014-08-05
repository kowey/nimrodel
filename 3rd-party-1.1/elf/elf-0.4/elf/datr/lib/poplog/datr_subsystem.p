/* --- Copyright University of Sussex 1994. All rights reserved. ----------
 > File:            $poplocal/local/auto/datr_subsystem.p
 > Purpose:         Definition of DATR subsystem record for Poplog
 > Author:          Roger Evans, May 12th 1993
 > Documentation:   HELP datr
 > Related Files:   lib datr, $DATR/...
 > RCS data:        $Id: datr_subsystem.p 1.4 1997/12/22 23:33:22 rpe Exp $
 */

/*  This file defines the DATR subsystem record (see REF subsystem) used
    by VED, load etc. to manipulate .dtr files.

    Note: it does not actually load the DATR compiler: lib datr
    (or prolog library(datr)) does this

    NB: this library presupposes the subsystem mechanism post poplog v14.22
*/

compile_mode :pop11 +strict;

uses datr_directory;    /* pick up pathname for DATR directory */

section;

include datr

global vars datr_lib_list = ['$DATR/dtr/'];

lconstant Searchlists =
    [   vedsrcname      [['$DATR/' src]]
        vedlibname      [% ident datr_lib_list %]
    ];

subsystem_add_new(
    "datr",                         ;;; SS_NAME
     "datr_subsystem_procedures",   ;;; SS_PROCEDURES
     datr_file_type,                ;;; SS_FILE_EXTN
     datr_prompt,                   ;;; SS_PROMPT - not used (see -datr_compile-)
     Searchlists,                   ;;; SS_SEARCH_LISTS
     'DATR'                         ;;; SS_TITLE
    );

/*  the following definition makes vedfiletypes entries neat: an entry of
    the form
        ['.dtr' {subsystem datr_subsystem}]
    will cause this library to be autoloaded as soon as a .dtr file is read
    into VED, and also sets subsystem correctly.
*/
global vars datr_subsystem = "datr";

endsection;
