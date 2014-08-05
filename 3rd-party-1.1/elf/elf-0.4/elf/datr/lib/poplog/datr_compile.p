/* --- Copyright University of Sussex 1994. All rights reserved. ---------
 > File:            $poplocal/local/auto/datr_compile.p
 > Purpose:         Pop11 interface to DATR compiler
 > Author:          Roger Evans, Mar 29 1994
 > Documentation:   HELP datr
 > Related Files:   lib datr, lib datr_subsystem, $DATR/...
 > RCS Data:        $Id: datr_compile.p 1.4 1999/04/23 21:46:20 rpe Exp $
 */

/*  This file loads the DATR compiler, and defines a pop11 interface to it  */

compile_mode :pop11 +strict;

section;

weak vars is_ved_lmr_stream, vedpathname;

include datr

/* load datr system */
procedure;
    dlocal current_directory = datr_directory;
    loadcompiler('poplog.pl');
endprocedure();

/* main interface procedure - datr_compile */
define global datr_compile(file);
    lvars file, p, tag = file, props;
    dlocal pop_default_type = datr_file_type;

    if isprocedure(tag) then
        ;;; try to recover a sensible tag from a proc (probably a repeater)
        pdprops(tag) -> props;
        if testdef vedrepeater and
           (weakref is_ved_lmr_stream(tag) or tag == weakref vedrepeater or props == "vedrangerepeater") then
            weakref vedpathname -> tag;
        elseif props then
            ;;; sensible for discin procedures
            props -> tag;
        endif;
    endif;

    unless isprocedure(file) then discin(file) -> file endunless;

    ;;; the prompts in the subsystem table have no effect, because
    ;;; prolog_invoke resets the prompt to a prolog one.
    ;;; so we have to set the prompt using the prolog 'prompt' predicate

    ;;; build call term: (prompt(N,<prompt>), datr_compile(file,mode,tag))
    prolog_maketerm(prolog_newvar(),datr_prompt,"prompt",2);
    prolog_maketerm(file, "reconsult", tag, "datr_compile",3);
    prolog_maketerm(",",2);

    ;;; call it
    unless sysCOMPILE(prolog_invoke) then
        mishap(file,1,'DATR compilation failed');
    endunless;
enddefine;

endsection;
