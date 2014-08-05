%   File:       api.pl
%   Purpose:    prolog api for elf example code
%   Author:     Roger Evans
%   Version:    1.0
%   Date:       17/03/10
%
%   (c) Copyright 2010, University of Brighton


/* application api from prolog */
pos(X) :- atom(X), !,
    pos([X]).
pos(X) :-
    pos(X, V),
    datr_write_val2(V, '').
pos(X, V) :-
    datr_query('pos.MAIN', X, V).
