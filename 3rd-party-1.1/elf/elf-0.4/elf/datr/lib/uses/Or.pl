% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Or.pl                                           %
% Purpose:         DATR library function: Or                                %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Or'(P, _GN, _GP, L) :- datr_lib_or(P,L), !.

datr_lib_or([0|T1],T2) :- !,
    datr_lib_or(T1,T2).
datr_lib_or([1|T1],[1|T2]) :- !,
    datr_lib_or_skip(T1,T2).
datr_lib_or(T,[0|T]).

datr_lib_or_skip([B|T1],T2) :-
    (B=0;B=1),!,
    datr_lib_or_skip(T1,T2).
datr_lib_or_skip(T,T).




% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
