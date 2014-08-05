% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            custom/simple_ui.pl                                      %
% Purpose:         DATR customisation -  include simple_ui package          %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1999.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


:- datr_pathname(simple_ui,"lib/",File), datr_load_library(File).

%   print a custom banner string.
:- db_retractall(dc_custom_banner/0).
:- db_asserta((dc_custom_banner :- simple_ui_banner)).


% The next line is the Revision Control System Id: do not delete it.
% $Id: simple_ui.pl 1.1 1999/03/04 15:37:50 rpe Exp $
