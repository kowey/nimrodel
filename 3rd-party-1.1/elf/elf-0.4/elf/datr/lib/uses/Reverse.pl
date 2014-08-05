% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Reverse.pl                                      %
% Purpose:         DATR library function: Reverse                           %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Reverse'(P,_GN,_GP,RP) :- datr_lib_reverse(P,[],RP).

datr_lib_reverse([],RP,RP) :- !.
datr_lib_reverse([H|T],Rest,RP) :- datr_lib_reverse(T,[H|Rest],RP).

% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
