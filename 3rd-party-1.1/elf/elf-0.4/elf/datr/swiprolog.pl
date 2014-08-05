% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            swiprolog.pl                                             %
% Purpose:         load a standard DATR system running under SWI prolog     %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2008.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   This file loads the standard datr system (using swiprolog builtin and
%   default custom files) and then prints a welcome banner

% stop swi from generating lots of warnings
:- style_check(-singleton).

:- current_op(X,Y,multifile), op(X,Y,spy), op(X,Y, nospy).

% swi warns if we redefine static predictaes, so we make these dynamic
% there are several better ways to do this, but they are more intrusive on
% other configs, so let's do it this way for now ...
:- dynamic dc_reset/0.
:- dynamic dc_warn/2.
:- dynamic dc_error/2.
:- dynamic dc_foreign/2.
:- dynamic dc_decl_name/2.
:- dynamic dc_declared_itemtype/3.
:- dynamic dc_library_name/2.
:- dynamic dc_declare_item/2.
:- dynamic dc_custom_banner/0.

:-
    reconsult('custom/vanilla.pl'),
    reconsult('builtin/swiprolog.pl'),
    reconsult('load.pl'),
    reconsult('custom/default.pl'),
    datr_banner.


% The next line is the Revision Control System Id: do not delete it.
% $Id: sicstus.pl 1.1 1999/03/04 15:36:21 rpe Exp $
