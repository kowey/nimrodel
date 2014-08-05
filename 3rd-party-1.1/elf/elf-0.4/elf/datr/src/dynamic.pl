% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            dynamic.pl                                               %
% Purpose:         declaration of dynamic predicates                        %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1995.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   Some Prolog systems insist on explicit declaration of dynamic predicates,
%   other don't like them.
%
%   Some Prolog systems only accept such declarations at top level, so
%   we can't do this via the builtin facility.
%
%   This file contains all such declarations assumed by DATR. It is
%   conditionally loaded by load.pl if the predicate -db_need_dynamics-
%   succeeds - this should be defined appropriately in the builtin.pl
%   file for the particular prolog system.

:- dynamic datr_variable/2.
:- dynamic datr_recorded/3.
:- dynamic datr_node_cleared/1.
:- dynamic datr_lastchar/1.
:- dynamic datr_qnode/2.
:- dynamic datr_undefval/1.
:- dynamic datr_dump_prefix/1.
:- dynamic datr_dump_action/1.
:- dynamic datr_library_loaded/1.
:- dynamic datr_flag/1.

% The next line is the Revision Control System Id: do not delete it.
% $Id: dynamic.pl 1.7 1997/11/23 21:03:34 rpe Exp $
