% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            builtin/vanilla.pl                                       %
% Purpose:         DATR built-in predicates - vanilla version               %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1999.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   This file contains dummy definitions for built-in predicates which print
%   a warning telling the user to install an appropriate real builtin file.


db_warn :-
    write('No builtin predicates loaded ...'), nl,
    write('... select from BUILTIN directory and reload DATR'),nl,
    abort.

db_asserta(X) :- db_warn.
db_assertz(X) :- db_warn.
db_retract(X) :- db_warn.
db_retractall(X) :- db_warn.
db_clause(X,Y) :- db_warn.

db_see(F) :- db_warn.
db_seeing(F) :- db_warn.
db_seen :- db_warn.
db_tell(F) :- db_warn.
db_telling(F) :- db_warn.
db_told :- db_warn.

db_get0(C) :- db_warn.
db_put(C) :- db_warn.
db_write(X) :- db_warn.
db_writeq(X) :- db_warn.
db_nl :- db_warn.

db_name(N,L) :- db_warn.

db_goal(L,G) :- db_warn.
db_call(G) :- db_warn.
db_plantcall(L,G) :- db_warn.

db_abort :- db_warn.

db_var(V) :- db_warn.
db_nonvar(V) :- db_warn.
db_atomic(A) :- db_warn.
db_not(G) :- db_warn.

db_eofchar(X) :- db_warn.

db_reconsult(X) :- db_warn;

% db_need_dynamics gets called before error handler is loaded, so its
% default is just to fail (ie don't load dynamics)

db_need_dynamics :- fail.

% The next line is the Revision Control System Id: do not delete it.
% $Id: vanilla.pl 1.4 1999/03/04 15:36:59 rpe Exp $
