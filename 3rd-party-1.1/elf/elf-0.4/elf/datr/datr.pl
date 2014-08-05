% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            datr.pl                                                  %
% Purpose:         load a standard DATR system                              %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1998.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   This file loads the standard datr system (using default builtin and
%   custom files) and then prints a welcome banner

:-
    reconsult('builtin/vanilla.pl'),
    reconsult('load.pl'),
    reconsult('custom/default.pl'),
    datr_banner.


% The next line is the Revision Control System Id: do not delete it.
% $Id: datr.pl 1.1 1999/03/04 15:35:52 rpe Exp $
