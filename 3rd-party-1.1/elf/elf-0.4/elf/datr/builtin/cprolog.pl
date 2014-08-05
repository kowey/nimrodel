% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            builtin/cprolog.pl                                       %
% Purpose:         DATR built-in predicates - Cprolog version               %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1994.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   This file contains definitions for built-in predicates as used by
%   C prolog. Copy this file to builtin.pl in the DATR directory.


db_asserta(X) :- asserta(X).        % assert before other clauses
db_assertz(X) :- assertz(X).        % assert after other clauses
db_retract(X) :- retract(X).        % retract one clause matching X
db_retractall(G) :- retractall(G).  % remove all clauses matching G
db_clause(H,T) :- clause(H,T).      % look up clause H :- T in database

db_see(F) :- see(F).                % select input stream
db_seeing(F) :- seeing(F).          % return current input stream
db_seen :- seen.                    % close input stream
db_tell(F) :- tell(F).              % select output stream
db_telling(F) :- telling(F).        % return current output stream
db_told :- told.                    % close current output stream

db_get0(C) :- get0(C).              % get char from current input
db_write(X) :- write(X).            % write item to current output
db_writeq(X) :- writeq(X).          % write in re-readable format
db_nl :- nl.                        % write a newline

db_name(N,L) :- name(N,L).          % N is word with list of chars L

db_goal(L,G) :- G =.. L.            % G is goal built from list L
db_call(G) :- call(G).              % call term G as a goal
db_plantcall(L,(G =.. L, call(G))). % return term to build and call list L

db_abort :- abort.                  % abort execution

db_var(V) :- var(V).                % V is an uninstantiated variable
db_nonvar(V) :- nonvar(V).          % V is not an uninstantiated variable
db_atomic(A) :- atomic(A).          % A is atomic (word or number etc.)
db_not(G) :- not(G).                % goal G cannot be satisfied

db_eofchar(26).                     % character signalling end of file

db_reconsult(X) :- reconsult(X).

db_need_dynamics :- fail.           % don't use dynamic predicate declarations

% The next line is the Revision Control System Id: do not delete it.
% $Id: cprolog.pl 1.2 1994/07/14 22:06:28 rpe Release $
