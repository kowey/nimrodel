%   File:       swiprolog.pl
%   Purpose:    loader for example lexicon - SWI prolog version
%   Author:     Roger Evans
%   Version:    1.0
%   Date:       24/09/2012
%
%   (c) Copyright 2012, University of Brighton

% swi-specific startup
% from commandline args:
% 	swipl -q -f swiprolog.pl -g main -t halt -- <args>
% from standard input:
%	swipl -q -f swiprolog.pl -g main -t halt
% NB: currently (swi v6.0.2, under Windows7) it appears swipl falls over 
% if you redirect just stdin to a file or pipeline. But if you also redirect 
% stdout it works.

:- getenv('ELFAPP', _V); working_directory(D,D), setenv('ELFAPP', D).

:- getenv('ELF', _V) ; expand_file_name('$ELFAPP/../../elf', [F]), setenv('ELF', F).

:- getenv('DATR', _V); expand_file_name('$ELF/datr', [F]), setenv('DATR', F).

% load datr if required - assert quiet flag first to prevent messages
:- assert(datr_flag(quiet)).
:- clause(datr_compile(_X),_Y); consult('$DATR/swiprolog.pl').

% load the datr app, and the prolog api to it
:- datr_compile('$ELFAPP/app.dtr').
:- compile('$ELFAPP/api.pl').	
	
% argument handling
swi_get_arglist(L) :-
	current_prolog_flag(argv, L1),
	swi_get_user_args(L1, L).

swi_get_user_args(['--'|L],L) :- !.
swi_get_user_args([_H|T],L) :- swi_get_user_args(T, L).
swi_get_user_args([],[]).

% main predicate
main :- swi_get_arglist(L), main(L).
main(L) :- datr_query('app.MAIN', [arglist|L], _V), halt.
		
		
