% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            custom/poplog.pl                                         %
% Purpose:         DATR customisation predicates - poplog version           %
% Author:          Roger Evans                                              %
%                                                                           %
%      Copyright (c) University of Sussex 1992.  All rights reserved.       %
% Copyright (c) Universities of Sussex and Brighton 1999.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   More efficient versions of declaration sutff, using 'record' library


:- library(record).

dc_reset :- record_init(800).

%   given an Item token and a type (node or atom), declare the item as
%   being of the given type. Under poplog, we use prolog 'record' which
%   is more efficient than the prolog database
dc_declare_item(Item, Type) :-
    recorda(Item, itemtype(Type), _Ref).

%   given an item, (as a word and a list of chars), return its type (atom
%   node, or dvar). If this fails, the default strategy is to use the 'record' database
%   and otherwise the convention that nodes start with capital letters and
%   dvars start with '$'
dc_declared_itemtype(Item, Chars, Type) :-
    recorded(Item, itemtype(Type), _Ref), !.


% add settings to improve spy output

:- spy_action(user).

spy_action_hook(call,Goal,_) :-
    datr_do_spy(1),
    print('>'), print(Goal), nl.
spy_action_hook(exit,Goal,_) :-
    datr_do_spy(-1),
    print('<'),print(Goal), nl.
spy_action_hook(fail,Goal,_) :-
    datr_do_spy(0),  % will fail after first call
    print('*'),print(Goal), nl.
spy_action_hook(_,_,_).

:- prolog_language(pop11).

global vars datr_spy_indent = 0;
define:prolog datr_do_spy/1(arg, contn);
    lvars arg, contn;
    returnif(datr_spy_indent < 0);
    prolog_full_deref(arg) -> arg;
    if arg == 1 then
        repeat datr_spy_indent times cucharout(32) endrepeat;
        datr_spy_indent + 1 -> datr_spy_indent;
    else
        datr_spy_indent - 1 -> datr_spy_indent;
        repeat datr_spy_indent times cucharout(32) endrepeat;
        if arg == 0 then
            -1 -> datr_spy_indent;
        endif;
    endif;
    chain(contn);
enddefine;

:- prolog_language(prolog).

dc_before_query(_,_,_) :-  prolog_setq(datr_spy_indent,0).

% The next line is the Revision Control System Id: do not delete it.
% $Id: poplog.pl 1.3 1999/03/04 15:37:50 rpe Exp $
