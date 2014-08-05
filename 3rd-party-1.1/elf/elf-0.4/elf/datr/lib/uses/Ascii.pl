% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Ascii.pl                                      %
% Purpose:         DATR library function: Ascii                           %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Ascii'(P, _GN, _GP, V) :- datr_lib_ascii(P,V).

datr_lib_ascii([],[]) :- !.
datr_lib_ascii([H1|T1],[H2|T2]) :- !,
    datr_lib_ascii_map(H1,H2), !,
    datr_lib_ascii(T1,T2).

datr_lib_ascii_map(A1,A2) :-
    db_name(A1,[A2]),!.
datr_lib_ascii_map('NUL',0) :- !.
datr_lib_ascii_map('ESC',27) :-!.
/* more needed! */
datr_lib_ascii_map(A,A).

% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
