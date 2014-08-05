% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            sicstus.pl                                               %
% Purpose:         load a standard DATR system running under sicstus        %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2009.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   This file loads the standard datr system (using sicstus builtin and
%   default custom files) and then prints a welcome banner

% stop sicstus from generating lots of warnings
:- prolog_flag(single_var_warnings, _, off).
:- prolog_flag(redefine_warnings, _, off).

:-
%    reconsult('custom/vanilla.pl'),   % sicstus doesn't like redefining these, so we don't bother to define them in the first place
    reconsult('builtin/sicstus.pl'),
    reconsult('load.pl'),
    reconsult('custom/default.pl'),
    datr_banner.


% The next line is the Revision Control System Id: do not delete it.
% $Id: sicstus.pl 1.1 1999/03/04 15:36:21 rpe Exp $
