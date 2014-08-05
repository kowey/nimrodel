% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            useslib/Global.pl                                        %
% Purpose:         definition of Global: implementing global inheritance    %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1997.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Global'([N|P],_GN,_GP,V) :- datr_call([N,P,N,P,V]).

% The next line is the Revision Control System Id: do not delete it.
% $Id: Global.pl 1.2 1997/11/23 20:55:33 rpe Exp $
