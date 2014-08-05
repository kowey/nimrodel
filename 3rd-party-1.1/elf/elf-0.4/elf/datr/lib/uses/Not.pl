% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Not.pl                                          %
% Purpose:         DATR library function: Not                               %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Not'(P, _GN, _GP, L) :- datr_lib_not(P,L), !.

datr_lib_not([B1|T1],[B2|T2]) :-
    ((B1=0,B2=1);(B1=1,B2=0)),!,
    datr_lib_not(T1,T2).
datr_lib_not(L,L).

% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
