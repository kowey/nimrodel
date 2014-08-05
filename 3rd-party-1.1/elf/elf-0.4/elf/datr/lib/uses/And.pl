% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/And.pl                                          %
% Purpose:         DATR library function: And                               %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'And'(P, _GN, _GP, L) :- datr_lib_and(P,L), !.

datr_lib_and([1|T1],T2) :- !,
    datr_lib_and(T1,T2).
datr_lib_and([0|T1],[0|T2]) :- !,
    datr_lib_and_skip(T1,T2).
datr_lib_and(T,[1|T]).

datr_lib_and_skip([B|T1],T2) :-
    (B=0;B=1),!,
    datr_lib_and_skip(T1,T2).
datr_lib_and_skip(T,T).




% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
