% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Fail.pl                                         %
% Purpose:         DATR library function: Fail                              %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Fail'(P,_GN,_GP,V) :-
    P=[N|P1],!,
    ((P1=[_|_];P1=[]), P2=P1; P2=[P1]),
    datr_append(P1,['>'],P2),
    datr_append(['Error:', N, failed, on, path, '<'],P2,V).
'Fail'(P,GN,GP) :-
    'Fail'(['Fail'|P],GN,GP).


% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
