% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            util.pl                                                  %
% Purpose:         DATR utility predicates                                  %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1999.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


%   This file contains definitions for standard utility predicates

%   member NB: also needed at runtime (see compile.pl)
datr_member(X,[X|Y]) :- !.
datr_member(X,[Y|Z]) :- !, datr_member(X,Z).

%   append NB: also needed at runtime (see compile.pl)
datr_append([],L,L) :- !.
datr_append([H|L1],L2,[H|L3]) :- !,
    datr_append(L1,L2,L3).
datr_append(H,T,[H|T]) :- !.

%   append but removing duplicates
datr_union([],L,L) :- !.
datr_union([H|T],X,Y) :-
    datr_member(H,X),!,
    datr_union(T,X,Y).
datr_union([H|T],X,[H|Y]) :- !,
    datr_union(T,X,Y).

%   assert a list of clauses
datr_assertlist([]) :- !.
datr_assertlist([H|T]) :- !,
    db_assertz(H), !,
    datr_assertlist(T).

%   retract a list of clauses
datr_retractlist([]) :- !.
datr_retractlist([H|T]) :-
    (db_retract(H);true),!, % don't care if clause is not there
    datr_retractlist(T).

%   retract and return clauses matching Head
datr_retracthead(Head,[Clause|Clauses]) :-
    datr_copy(Head,THead),
    db_clause(THead,Body), !,
    Clause = (THead :- Body),
    db_retract(Clause), !,
    datr_retracthead(Head,Clauses),!.
datr_retracthead(Head,[]) :- !.

%   copy a term
datr_copy(Term,Term) :- db_atomic(Term),!.
datr_copy(Term1,Term2) :- db_var(Term1),!.
datr_copy(Term1, Term2) :- !,
    db_goal(L1,Term1), !,
    datr_copylist(L1,L2), !,
    db_goal(L2,Term2),!.

datr_copylist([],[]) :- !.
datr_copylist([H1|T1],[H2|T2]) :- !,
    datr_copy(H1,H2), !,
    datr_copylist(T1,T2).

%   call a predicate in 'univ' list form
datr_call(L) :- !, db_goal(L,G), db_call(G).


% The next line is the Revision Control System Id: do not delete it.
% $Id: util.pl 1.3 1999/03/04 15:39:13 rpe Exp $
