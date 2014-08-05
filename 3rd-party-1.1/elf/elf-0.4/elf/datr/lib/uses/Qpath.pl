% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            useslib/Qpath.pl                                         %
% Purpose:         definition of Qpath: implementing query path inheritance %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1997.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Qpath'(P,_GN,_GP,V) :- datr_qnode(QN,_QP), datr_call([QN,P,QN,P,V]).

% The next line is the Revision Control System Id: do not delete it.
% $Id: Qpath.pl 1.2 1997/11/23 20:55:33 rpe Exp $
