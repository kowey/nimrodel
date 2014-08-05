% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            useslib/Qnode.pl                                         %
% Purpose:         definition of Qnode: implementing query node inheritance %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1997.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Qnode'([N|_P],_GN,_GP,V) :- datr_qnode(_QN,QP), datr_call([N,QP,N,QP,V]).

% The next line is the Revision Control System Id: do not delete it.
% $Id: Qnode.pl 1.2 1997/11/23 20:55:33 rpe Exp $
