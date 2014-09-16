% Eric Kow <eric@erickow.com>
% (c) Copyright 2014, University of Brighton
% (BSD3 license)

:- use_module(library(http/json)).

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
        consult('$ELFAPP/datr_patches.pl').

% load the ELF app and the prolog api
:- dynamic 'nimrodel.PARAMS/4'.
:- datr_compile('$ELFAPP/app.dtr').
:- compile('$ELFAPP/api.pl').

% load the test grammar
:- consult('$ELFAPP/../test/attrdcg.pl').


% ----------------------------------------------------------------------
% mode 1: text directly on command line
% ----------------------------------------------------------------------

% main/0, main/1
% invoke datr on all test cases produced by our test grammar


test_json(test(Attrs, Str, Result)) :-
    tstring(Attrs, Str, []), % from attrdcg
    datr_query('app.MAIN', [arglist1|Str], [Result|_]).


show_result(test(Attrs, Str, Result)) :-
    new_memory_file(Handle),
    % write/read the json to a memory file so we can read it
    % back in the json library (wants a stream)
    open_memory_file(Handle, write, S),
    write(S, Result),
    close(S),
    open_memory_file(Handle, read, R, [free_on_close(true)]),
    json_read(R, JTerm),
    close(R),
    show_result_inner(Attrs, Str, JTerm).


% show_result with the json already parsed
show_result_inner(Attrs, Str, JTerm) :-
    write_unwords(Str), nl,
    findall(TRes, mk_test_result(Attrs, JTerm, TRes), TRes),
    forall(member(TR, TRes), show_result_single(TR)).
show_result_single(result(Attr, Res)) :-
    format('    ~w ~46t ~w~72|~n', [Attr, Res]).

% mk_test_result(?Attr, +Attrs, +JTerm, -TRes)
mk_test_result(Attrs, JTerm, TRes) :-
    member(Attr, Attrs),
    mk_test_result_helper(Attr, JTerm, TRes).
mk_test_result_helper(Attr, [], result(Attr,'FAIL')) :- !.
mk_test_result_helper(Attr, [json(JArgs)|_], result(Attr,ok)) :-
    is_in_avlist(Attr, JArgs),!.
mk_test_result_helper(Attr, _, result(Attr,'FAIL')).

% in_av_list 
is_in_avlist(Attr, [Attr=_|_]).
is_in_avlist(Attr, [_|X]) :- is_in_avlist(Attr, X).

% this horrible thing only exists because I don't know how to write
% unwords :: [String] -> String in Prolog
write_unwords([]) :- true.
write_unwords([X]) :- write(X).
write_unwords([X|Xs]) :- write(X), write(' '), write_unwords(Xs).



main :-
    findall(X, test_json(X), Results),
    forall(member(R, Results), show_result(R)).
