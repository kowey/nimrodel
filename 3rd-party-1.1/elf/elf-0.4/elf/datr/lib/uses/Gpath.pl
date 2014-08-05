% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            useslib/Gpath.pl                                         %
% Purpose:         definition of Gpath: implementing global path inheritance%
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1997.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Gpath'(P,GN,_GP,V) :- datr_call([GN,P,GN,P,V]).

% The next line is the Revision Control System Id: do not delete it.
% $Id: Gpath.pl 1.2 1997/11/23 20:55:33 rpe Exp $
