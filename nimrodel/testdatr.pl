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
%	

% invocation as prolog 'application' 

% main/1
% invoke DATR app.MAIN with user supplied args (main/1), or args from command line (main/0)
main(L) :-
	datr_query('TEST', [unwords|L], Vs),
	foreach(member(V,Vs), write(V)),
	nl,
	halt.
