% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            useslib/Local.pl                                         %
% Purpose:         definition of Local: implementing local inheritance      %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1997.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Local'([N|P],GN,GP,V) :- datr_call([N,P,GN,GP,V]).

% The next line is the Revision Control System Id: do not delete it.
% $Id: Local.pl 1.2 1997/11/23 20:55:33 rpe Exp $
