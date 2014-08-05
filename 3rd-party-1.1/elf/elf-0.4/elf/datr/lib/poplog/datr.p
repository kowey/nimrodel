/* --- Copyright University of Sussex 1994. All rights reserved. ---------
 > File:            $poplocal/local/lib/datr.p
 > Purpose:         Pop11 interface to DATR compiler
 > Author:          Roger Evans, Feb 16 1989 (see revisions)
 > Documentation:   HELP datr
 > Related Files:   lib datr_compile, lib datr_subsystem, $DATR/...
 > RCS Data:		$Id: datr.p 1.8 1999/04/23 22:24:51 rpe Exp $
 */

/*  This file defines datr_subsystem_procedures for the DATR substem
	interface to the compiler (see lib datr_subsystem).
*/

compile_mode :pop11 +strict;

section;

loadinclude datr
uses datr_compile
uses datr_subsystem


/*  User-friendly top-level char repeater
    A character repeater which does primitive command detection on the input.
	The first item on each line (delimited by a character < 33) is looked up
	in -prolog_command-, (see PLOGHELP *COMMANDS) if it maps to a procedure,
	that procedure is run. This allows interpretation of commands like ved,
	help, cd etc. and the library(languages) mechanism to operate from within
	datr.
*/

define lconstant expand_command(rep);
	lvars last =`\n`, rep;
	procedure;
	    lvars l c;
        while last == `\n` then
            ;;; read first 'item' and look for prolog commands
            0 -> l;
            [%  repeat;
                    rep() -> c;
                    quitif(c == termin or c fi_<= 32);
                    c;
                    l fi_+ 1 -> l;
                endrepeat;
            %] -> last;
            if prolog_command(consword(dl(last),l)) ->> l then
                ;;; found a command
			    define lconstant Read_arg();
				    if c == termin or c == `\n` then
					    nullstring;		;;; nothing else on current line
				    else
					    ;;; skip whitespace
					    repeat;
						    rep() -> c;
						    quitunless(c == `\s` or c == `\t`);
					    endrepeat;
					    ;;; read to end of line and make a string
					    consstring(#|
						    repeat;
							    quitif(c == termin or c == `\n`);
							    c;
							    rep() -> c;
						    endrepeat;
					    |#);
				    endif;
			    enddefine;

			    l(if pdnargs(l) == 1 then Read_arg() endif);	;;; run command

                `\n` -> last;	;;; mark start of new line
            else
                ;;; not a command - put delimiting char in buffer too
                last ncjoin [^c] -> last;
            endif
        endwhile;
        ;;; no macro - may be buffered chars to return
        if ispair(last) then
            destpair(last) -> last;
            ;;; no further buffered chars, so remember last char
            if last == [] then dup() -> last endif;
        else
            ;;; nothing buffered, return and remember next char
            rep() ->> last;
        endif;
	endprocedure;
enddefine;


/* datr_subsystem_procedures */

define lconstant Compile(file);
	lvars file;

	if isprocedure(file) and not(isclosure(file) and pdpart(file) == discin) then
		/*  add command expansion to anything that MIGHT be an
			interactive compilation */
		expand_command(file) -> file;
	endif;
	
	datr_compile(file);
enddefine;

define lconstant Trycompile(file) -> file;
	lvars file;

	if readable(file) ->> file then
		Compile(file);
	endif;
enddefine;

define lconstant Reset;
	returnunless(systrmdev(pop_charin_device));
	syspr(datr_reset_string);
enddefine;

define lconstant Setup;
enddefine;

define lconstant Banner;
	prolog_invoke(prolog_maketerm("datr_banner",0)) -> ;
enddefine;

define lconstant Initcomp;
	dlocal weakref vedvedname;
	Trycompile('$popsys/init' <> datr_file_type) -> ;
	Trycompile('$poplib/init' <> datr_file_type)
		or Trycompile('init' <> datr_file_type) -> ;
enddefine;

define lconstant Poparg1;
	sys_process_poparg1(Compile, Trycompile, datr_file_type);
enddefine;

define lconstant Vedsetup;
	lconstant filetype_rec = [ ^datr_file_type {subsystem datr_subsystem} ];
	
	returnunless(testdef vedfiletypes);

	unless member(filetype_rec, weakref vedfiletypes) then
	    filetype_rec :: weakref vedfiletypes -> weakref vedfiletypes;
	endunless;

	unless weakref vedsetupdone then
		'datr' ->> weakref vedhelpname -> weakref vedteachname;
		'temp' <> datr_file_type -> weakref vedvedname;
		'output' <> datr_file_type ->> weakref vedlmr_print_in_file
			-> weakref vedlmr_errs_in_file;
	endunless;
enddefine;

define lconstant Xsetup;
enddefine;

global vars datr_subsystem_procedures =
	{% Compile, Reset, Setup, Banner, Initcomp, Poparg1, Vedsetup, Xsetup %};

sys_init_subsystem(datr_subsystem);

;;;global vars pop_nobanner;
;;;unless pop_nobanner then
;;;	Banner();
;;;endunless;


global vars datr = true;

endsection;

/* --- Revision History ---------------------------------------------------
--- Roger Evans, Mar 22 1989 filename changes etc.
--- Roger Evans, Mar 10 1989 Version 2
 */
