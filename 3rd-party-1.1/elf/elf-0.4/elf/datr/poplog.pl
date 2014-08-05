% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            poplog.pl                                               %
% Purpose:         load a standard DATR system running under poplog        %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1999.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   This file loads the standard datr system (using poplog builtin and
%   default custom files) and then prints a welcome banner

%   IMPORTANT NOTE:
%
%   Poplog prolog interprets filenames of nested compilations as being
%   relative to the CURRENT directory, not the directory of the invoking file.
%   This means this loader file only works when loaded in the DATR directory
%   itself. The library files in lib/poplog overcome this problem, by locally
%   cd'ing to the datr directory. It is therefore recommended that these
%   library files are installed into your poplog system, and DATR is loaded
%   using them (ie by invoking library(datr)), rather than loading this file
%   directly.


:-
    reconsult('$DATR/custom/vanilla.pl'),
    reconsult('$DATR/builtin/poplog.pl'),
    reconsult('$DATR/custom/poplog.pl'),
    reconsult('$DATR/load.pl'),
    reconsult('$DATR/custom/default.pl'),
    datr_banner.



% The next line is the Revision Control System Id: do not delete it.
% $Id: poplog.pl 1.2 1999/04/23 21:31:29 rpe Exp $
