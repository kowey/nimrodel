% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Chars.pl                                        %
% Purpose:         DATR library function: Chars                             %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2003.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Chars'(P, _GN, _GP, V) :- datr_lib_chars(P,V).

datr_lib_chars([],[]) :- !.
datr_lib_chars([H1|T1],[H2|T2]) :- !,
    datr_lib_chars_map(H1,H2), !,
    datr_lib_chars(T1,T2).

datr_lib_chars_map(0, 'NUL') :- !.
datr_lib_chars_map(27,'ESC') :- !.
/* more needed! */
datr_lib_chars_map(A2,A1) :-
    db_name(A1,[A2]),!.
datr_lib_chars_map(A,A).

% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
