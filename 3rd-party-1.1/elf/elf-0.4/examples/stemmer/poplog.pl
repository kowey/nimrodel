%   File:       poplog.pl
%   Purpose:    loader for example lexicon - poplog prolog version
%   Author:     Roger Evans
%   Version:    1.0
%   Date:       27/09/2011
%
%   (c) Copyright 2011, University of Brighton

% push up some poplog memory limit parameters
:- prolog_language(pop11).

;;; a safe way to bump up memory limits as far as possible
uses int_parameters

pop_max_int ->> popmemlim -> pop_callstack_lim;

;;; pushing up pop_prolog_lim this high causes problems so we are more modest
pop_prolog_lim * 10 -> pop_prolog_lim;

unless systranslate('ELFAPP') then
    current_directory -> systranslate('ELFAPP');
endunless;
unless systranslate('ELF') then
    sysfileok('$ELFAPP/../../elf') -> systranslate('ELF');
endunless;
unless systranslate('DATR') then
    sysfileok('$ELF/datr') -> systranslate('DATR');
endunless;

:- prolog_language(prolog).

% load datr if required - assert quiet flag first to prevent messages
:- assert(datr_flag(quiet)).
:- clause(datr_compile(_X),_Y); consult('$DATR/poplog.pl').

:- datr_compile('$ELFAPP/app.dtr').
:- compile('$ELFAPP/api.pl').


:- prolog_language(pop11).

;;; define prolog predicate main/0 to run the datr app.MAIN on command line args
define:prolog main/0(contn);
	prolog_invoke(
		prolog_maketerm(
			"'app.MAIN'", 
			"arglist" :: maplist(poparglist, consword), 
			prolog_newvar(), 
			"datr_query", 3)) ->;
	fast_sysexit();
enddefine;
		
		
		
		
