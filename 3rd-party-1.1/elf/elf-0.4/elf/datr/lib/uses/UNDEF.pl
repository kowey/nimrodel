% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            useslib/UNDEF.pl                                         %
% Purpose:         definition of an UNDEF node (that always fails)          %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1997.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'UNDEF'(_P,_GN,_GP,_V) :- fail.

% The next line is the Revision Control System Id: do not delete it.
% $Id: UNDEF.pl 1.3 1998/05/27 18:26:56 rpe Exp $
