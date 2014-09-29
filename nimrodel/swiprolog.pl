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

use(library(pio)).
use(library(filesex)).

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


% ----------------------------------------------------------------------
% mode 1: text directly on command line
% ----------------------------------------------------------------------

% main/0, main/1
% invoke DATR app.MAIN with user supplied args (main/1), or args from command line (main/0)
main :- swi_get_arglist(L), main(L).
main(L) :- datr_query('app.MAIN', [arglist|L], _V), halt.	


% ----------------------------------------------------------------------
% mode 2: multiple filenames on command line, one output
% ----------------------------------------------------------------------

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

% ----------------------------------------------------------------------
% mode 3: input/output directory on command line
% recursive traversal, one output file per input file
% ----------------------------------------------------------------------

% traverse_dir/0, traverse_dir/2
% walk a directory, and invoke DATR app.MAIN on each file
% within that dir (recursive search)
%
% save the result with a mirror filename in the output dir
traverse_dir :- swi_get_arglist([DirIn, DirOut]), !, traverse_dir(DirIn, DirOut), halt.
traverse_dir :- write('Usage: <prognam> input-dir output-dir'), nl, halt.
traverse_dir(DirIn, DirOut) :- on_dir(DirIn, DirOut, query_and_jsonify).

% time_dir/0
% walk a directory, and invoke DATR app.MAIN on each file
% within that dir (recursive search),
% time each DATR call and printing timing information to stdout
%
% save the result with a mirror filename in the output dir
time_dir :- swi_get_arglist([DirIn, DirOut]), !, time_dir(DirIn, DirOut), halt.
time_dir :- write('Usage: <prognam> input-dir output-dir'), nl, halt.
time_dir(DirIn, DirOut) :- on_dir(DirIn, DirOut, time_query).


% on_dir/3
%
% given an input directory, an output directory, and a job (/2)
% apply that job to every input/output file name pair we can get
% by walking the directory and mirroring any input filename into
% an equivalent output file name
%
% We also create any intermediary output directories
% along the way
on_dir(DirIn, DirOut, Job) :-
	write('walking dir '), write(DirIn), write(' (->'), write(DirOut), write(')'), nl,
	directory_files(DirIn, Files),
	make_directory_path(DirOut),
	foreach(member(File, Files), on_dir_item(DirIn, File, DirOut, Job)).

% on_dir_item
on_dir_item(_, '.', _, _).
on_dir_item(_, '..', _, _).
on_dir_item(DirIn, Item, DirOut, Job) :-
	directory_file_path(DirIn, Item, ItemIn),
	directory_file_path(DirOut, Item, ItemOut),
	on_dir_item_exp(ItemIn, ItemOut, Job).

% on_dir_item with the item expanded to be relative
on_dir_item_exp(ItemIn, ItemOut, Job) :-
	exists_file(ItemIn),
	DoJob =.. [Job, ItemIn, ItemOut],
	call(DoJob).
on_dir_item_exp(ItemIn, ItemOut, Job) :-
	exists_directory(ItemIn),
	on_dir(ItemIn, ItemOut, Job).

% trivial example of a directory traversal job
%simple_job(In, Out) :-
%	write('JOB! '),
%	write(In), write(' > '), write(Out),
%	nl.

% query_and_jsonify/2
% read from input filename and write query result to output filename
query_and_jsonify(In, Out) :-
	write(In), nl,
	once(phrase_from_file(all(Chars), In)),
	string_codes(Str, Chars),
	query_and_jsonify_str(Str, Out).
query_and_jsonify_str(Str, _) :- is_whitespace_only(Str).
query_and_jsonify_str(Str, Out) :-
	datr_query('app.MAIN', [arglist1,Str|[]], Vs),
	open(Out,write,OutStream),
	foreach(member(V,Vs), write(OutStream, V)),
	close(OutStream).

% time_query/2
% read from input filename and time the datr query
% without writing any other output
time_query(In, _) :-
	once(phrase_from_file(all(Chars), In)),
	string_codes(Str, Chars),
	time_query_str(In, Str).
time_query_str(_, Str) :- is_whitespace_only(Str).
time_query_str(In, Str) :-
	Keys = [stack, localused, globalused, trailused, heapused],
	time(datr_query('app.MAIN', [arglist1,'-format','raw',Str|[]], _)),
	file_base_name(In, InBasename),
	write(InBasename), write('\t'),
	foreach(member(Key, Keys), write_stat(Key)),
	nl,
	statistics.

write_stat(Key) :-
	statistics(Key, Val),
	%write(Key), write(': '), write(Val), nl.
	write(Val), write('\t').


% ----------------------------------------------------------------------
% file/string manipulation
% ----------------------------------------------------------------------

% force a lazy list
all([])     --> [].
all([L|Ls]) --> [L], all(Ls).

% is_whitespace_only/1
is_whitespace_only(Str) :-
	normalize_space(string(NormStr), Str),
	string_length(NormStr, 0).

% ----------------------------------------------------------------------
% command line arguments
% ----------------------------------------------------------------------

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
