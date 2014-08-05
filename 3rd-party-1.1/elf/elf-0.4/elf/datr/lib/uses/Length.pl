% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Length.pl                                         %
% Purpose:         DATR library function: Length                              %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Length'(P,_GN,_GP,[L]) :- datr_lib_length(P, L).

datr_lib_length([], 0) :- !.
datr_lib_length([_|T],N) :-
    datr_lib_length(T, N1),
    N is N1 + 1.

% The next line is the Revision Control System Id: do not delete it.
% $Id: Length.pl 1.1 1999/03/04 15:38:35 rpe Exp $
