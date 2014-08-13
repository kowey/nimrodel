%   File:       swiprolog.pl
%   Purpose:    SWI prolog loader for complete application
%   Author:     Roger Evans
%   Version:    1.0
%   Date:       21/12/2013
%
%   (c) Copyright 2013, University of Brighton

% SWI prolog-specific startup
% input from command line args:
% 	swipl -q -f swiprolog.pl -g main -t halt -- <args>
% input from standard input:
%	swipl -q -f swiprolog.pl -g main -t halt
% NB: currently (swi v6.6.1, under Windows 7) it appears swipl falls over 
% 	  if you redirect just stdin to a file or pipeline. But if you also redirect 
% 	  stdout it works.

% set prolog prompt to be empty 
:- prompt(_P, '').

% get $ELFAPP, or set to current directory
:- getenv('ELFAPP', _V); working_directory(D,D), setenv('ELFAPP', D).

% get $ELFROOT or set relative to $ELFAPP
:- getenv('ELFROOT', _V) ; expand_file_name('$ELFAPP/../..', [F]), setenv('ELFROOT', F).

% get $ELF or set relative to $ELFROOT
:- getenv('ELF', _V) ; expand_file_name('$ELFROOT/elf', [F]), setenv('ELF', F).

% get $DATR or set relative to $ELF
:- getenv('DATR', _V); expand_file_name('$ELF/datr', [F]), setenv('DATR', F).

% load datr (and patches) if required - assert quiet flag first to prevent printing of messages
:- clause(datr_compile(_X),_Y); 
		assert(datr_flag(quiet)),
		consult('$DATR/swiprolog.pl'), 
		consult('datr_patches.pl').

% load the ELF app and the prolog api
:- dynamic 'nimrodel.PARAMS/4'.
:- datr_compile('$ELFAPP/app.dtr').
:- compile('$ELFAPP/api.pl').	
	

% invocation as prolog 'application' 

% main/0, main/1
% invoke DATR app.MAIN with user supplied args (main/1), or args from command line (main/0)
main :- swi_get_arglist(L), main(L).
main(L) :- datr_query('app.MAIN', [arglist|L], _V), halt.	

use(library(pio)).

% force a lazy list
all([])     --> [].
all([L|Ls]) --> [L], all(Ls).

% on_files/0, on_files/1
% invoke DATR app.MAIN on each file in the list
on_files :- swi_get_arglist(L), on_files(L).
on_files(Files) :-
	foreach(member(File,Files), on_file(File)),
	halt.

% on_file/1
% run DATR app.MAIN on a single file, for now printing the
% results to stdout
on_file(File) :-
	% EYK: I don't understand this magic from
	% http://stackoverflow.com/a/11107786
	% to slurp a file
	once(phrase_from_file(all(Chars), File)),
	string_codes(Str, Chars),
	datr_query('app.MAIN', [arglist,Str|[]], _V).



% swi_get_arglist/1
% return all args following '--' from command line 
% since swi 6.6.1, just return all the args (others have been stripped already)

swi_get_arglist(L) :-
	current_prolog_flag(argv, L1),
	current_prolog_flag(version, V),
	( V > 60600 -> L = L1 ; swi_get_user_args(L1, L) ).

swi_get_user_args(['--'|L],L) :- !.
swi_get_user_args([_H|T],L) :- swi_get_user_args(T, L).
swi_get_user_args([],[]).
