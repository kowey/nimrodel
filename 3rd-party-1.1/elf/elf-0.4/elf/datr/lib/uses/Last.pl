% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Last.pl                                         %
% Purpose:         DATR library function: Last                              %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Last'(P, _GN, _GP, L) :- P=[_|_], !, datr_lib_last(P,L).
'Last'(P,GN,GP,V) :- 'Fail'(['Last'|P],GN,GP,V).

datr_lib_last(L,L) :- L = [_], !.
datr_lib_last([_H|T],L) :- datr_lib_last(T,L).

% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
