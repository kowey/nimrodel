% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Member.pl                                       %
% Purpose:         DATR library function: Member                            %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Member'([X|P], _GN, _GP, [1]) :- datr_member(X,P),!.
'Member'([], GN, GP, V) :- 'Fail'(['Member'],GN, GP, V).
'Member'(_P, _GN, _GP, [0]).


% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
