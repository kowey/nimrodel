% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            debug.pl                                                 %
% Purpose:         Debugging support                                        %
% Author:          Roger Evans                                              %
%                                                                           %
%      Copyright (c) University of Sussex 1992.  All rights reserved.       %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   $Revision: 1.1 $
%   $Author: rogere $
%   $Date: 1992/10/30 22:48:29 $
%   $State: Release $

portray(X) :- datr_portray(X).

% definition for portray to print datr predicates nicely
datr_portray(Term) :-
    datr_predicate(Term,List),!,
    datr_tracemode(T),
    datr_do_portray(T,List).

datr_predicate(Term,List) :-
    db_goal(List,Term),
    List = [N1,P1,N2,P2,V],
    datr_runtime(_,node(N1)).

datr_do_portray(local,[N,P,_,_,V]) :-
    datr_debug_write_theorem(N,P,V).
datr_do_portray(global, [N1, P1, N2, P2, V]) :-
    db_write('{'),
    datr_debug_write_head(N2,P2),
    db_write('} '),
    datr_debug_write_theorem(N1,P1,V).

datr_tracemode(local).

datr_debug_write_theorem(N,P,V) :- !,
    datr_debug_write_head(N,P),
    datr_debug_write_val(V).

datr_debug_write_head(N,P) :-
    db_write(N), db_write(':<'),
    datr_debug_write_list(P),
    db_write('>').

datr_debug_write_val(V) :- db_var(V),!.   % nothing for unknown values
datr_debug_write_val(V) :- db_write(' = '), datr_debug_write_val2(V).

datr_debug_write_val2([H|T]) :- !,
    datr_debug_write_list([H|T]).
datr_debug_write_val2([]) :- !.
datr_debug_write_val2(V) :- !,
    db_writeq(V).

datr_debug_write_list(X) :- datr_end_of_list(X), !.
datr_debug_write_list([H|T]) :- !,
    db_writeq(H),
    (   datr_end_of_list(T)
        ;
        db_write(' '),
        datr_debug_write_list(T)
    ),!.
