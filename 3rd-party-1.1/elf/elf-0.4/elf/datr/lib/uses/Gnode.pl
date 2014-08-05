% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            useslib/Gnode.pl                                         %
% Purpose:         definition of Gnode: implementing global node inheritance%
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1997.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Gnode'([N|_P],_GN,GP,V) :- datr_call([N,GP,N,GP,V]).

% The next line is the Revision Control System Id: do not delete it.
% $Id: Gnode.pl 1.2 1997/11/23 20:55:33 rpe Exp $
