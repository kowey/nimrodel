% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            runtime.pl                                               %
% Purpose:         runtime support predicates                               %
% Authors:         Roger Evans, Gerald Gazdar, Liz Jenkins                  %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1994.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   These predicates provide some simple runtime support for DATR queries.
%   They assume the existence of the predicate datr_query(Node,Path,Value)
%   provided by individual compilers plus datr_runtime(Tag,Info) produced by
%   main.pl in response to declarations etc.. Both the main compiler system
%   and free-standing compiled code provided these predicate. Thus this file
%   is used by the compiler to respond to queries, but it can also be loaded
%   in conjuction with a compiled datr preogram to make querying a little
%   easier without loading in the whole compiler.


%   -- datr_theorem(Node,Path,Value) ----------------------------------------
%   -- datr_theorem(Node,Path) ----------------------------------------------
%   -- datr_theorem(Node) ---------------------------------------------------
%   -- datr_theorem ---------------------------------------------------------
%
%   datr_theorem prints theorems derivable from a compiled datr definition.
%   Given Node, Path and Value it succeeds (and prints) iff Value unifies
%   with the value derivable (if any) at that Node, Path spec. Given just
%   Node and Path it succeeds (and prints) iff a Value is defined. Given
%   just Node it prints values (if any) for all paths declared using
%   #show. Given nothing, it prints all #show paths for all nodes not
%   declares with #hide.

datr_theorem(N,P,V) :- !,
    datr_query(N,P,V),
    db_not(datr_undefval(V)),
    datr_write_theorem(N,P,V), !.

datr_theorem(N,P) :- !,
    datr_theorem(N,P,_).

datr_theorem(N) :-
    datr_runtime(F,show(P,VL)),
    datr_instantiate_path(P, VL),
    datr_once(datr_theorem(N,P,V)),
    fail.
datr_theorem(_) :- !.

datr_theorem :-
    datr_runtime(_,node(N)),
    db_not(datr_runtime(_,hide(N))),
    datr_once(datr_theorem(N)),
    fail.
datr_theorem :- !.

% show a fixed path for all nodes (no path expansion possible here)
datr_theorem_show(no) :- !, datr_theorem.
datr_theorem_show(P) :-
    datr_runtime(_,node(N)),
    db_not(datr_runtime(_,hide(N))),
    datr_once(datr_theorem(N,P,V)),
    fail.
datr_theorem_show(_) :- !.






datr_once(Goal) :- db_call(Goal), !.


datr_instantiate_path(P, []).
datr_instantiate_path(P, [datr_var(Name, Val)|T]) :-
    datr_instantiate_path(P, T),
    datr_var_repeater(Val, Name).


% write out a datr theorem

datr_write_theorem(N,P,V) :-
    datr_get_dump_action(Act),
    datr_write_theorem(Act, N, P, V).

datr_get_dump_action(Act) :-
    datr_dump_action(Act), !.
datr_get_dump_action(prefix(Pre,default)) :-
    datr_dump_prefix(Pre),!.
datr_get_dump_action(default).


datr_write_theorem(default, N, P, V) :- !,
    datr_write_head(N,P),
    datr_write_val(V),
    db_write('.'), db_nl.
datr_write_theorem(prefix(Pre), N, P, V) :- !,
    db_write(Pre),
    datr_write_theorem(default, N, P, V).
datr_write_theorem(val(Sep), N, P, V) :-
    datr_write_val2(V, Sep).

datr_write_head(N,P) :-
    db_write(N), db_write(':<'),
    datr_write_list(P, ' '),
    db_write('>').

datr_write_val(V) :- db_var(V),!.   % nothing for unknown values
datr_write_val(V) :- db_write(' = '), datr_write_val2(V, ' ').

datr_write_val2([H|T], Sep) :- !,
    datr_write_list([H|T], Sep).
datr_write_val2([],_) :- !.
datr_write_val2(V,_) :- !,
    db_write(V).

datr_write_list(X, Sep) :- datr_end_of_list(X), !.
datr_write_list([H|T], Sep) :- !,
    db_write(H),
    (   datr_end_of_list(T)
        ;
        db_write(Sep),
        datr_write_list(T, Sep)
    ),!.

datr_end_of_list(X) :- db_var(X),!.
datr_end_of_list([]).

% runtime checking of variable ranges

datr_var_member(A,V) :- datr_runtime(_,vars(V,R-NR)),!,
    datr_range_member(A,R),!,
    db_not(datr_range_member(A,NR)),!.
% undeclared variables range over everything
datr_var_member(A,V).

datr_range_member(A,R) :- db_var(R),!.
datr_range_member(A,[A|T]).
datr_range_member(A,[dvar(V)|T]) :- datr_var_member(A,V).
datr_range_member(A,[H|T]) :- datr_range_member(A,T).

datr_var_repeater(A, V) :- datr_runtime(_, vars(V, R-NR)), !,
    datr_range_member(A, R),
    db_not(datr_range_member(A, NR)).
datr_var_repeater(A, V) :-
    datr_error(V, 'invalid use of unrestricted variable').


% The next line is the Revision Control System Id: do not delete it.
% $Id: runtime.pl 1.8 1998/09/18 22:07:46 rpe Exp $
