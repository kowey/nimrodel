% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            load.pl                                                  %
% Purpose:         load the core DATR compiler                              %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1999.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   This file reconsults all the files for the core DATR compiler
%   It assumes the appropriate builtin file has already been loaded
%   and custom files are loaded elsewhere (eg in ../datr.pl)

:-

    % dynamic declarations if required (as specified in builtin.pl)

    (db_need_dynamics -> reconsult('$DATR/src/dynamic.pl'); true),

    % main compiler files

    reconsult('$DATR/directory.pl'),
    reconsult('$DATR/src/files.pl'),
    reconsult('$DATR/src/util.pl'),
    reconsult('$DATR/src/errors.pl'),
    reconsult('$DATR/src/token.pl'),
    reconsult('$DATR/src/sentence.pl'),
    reconsult('$DATR/src/dcg.pl'),
    reconsult('$DATR/src/path.pl'),
    reconsult('$DATR/src/main.pl'),
    reconsult('$DATR/src/declare.pl'),
    reconsult('$DATR/src/runtime.pl'),
    reconsult('$DATR/src/api.pl'),
    reconsult('$DATR/src/debug.pl'),
    reconsult('$DATR/src/version.pl'),
    reconsult('$DATR/src/compile.pl'),
    reconsult('$DATR/src/rtf.pl').

% The next line is the Revision Control System Id: do not delete it.
% $Id: load.pl 1.5 1999/03/04 15:36:21 rpe Exp $
