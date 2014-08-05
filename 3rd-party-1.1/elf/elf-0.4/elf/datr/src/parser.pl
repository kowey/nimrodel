% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            parser.pl                                                %
% Purpose:         parser derived directly from dcg.pl                      %
% Author:          Roger Evans and Liz Jenkins                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1994.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% for prolog systems that don't have dcg compilation...

sentence_1(_1, _2, _2) :- db_var(_1), !.
sentence_1(_1, _2, query(_2)).

decl_body(node, _1, _2, _3) :- !, item(_1, _2, _3).
decl_body(atom, _1, _2, _3) :- !, item(_1, _2, _3).
decl_body(show, _1, _2, _3) :- !, path(_1, _2, _3).
decl_body(hide, _1, _2, _3) :- !, node(_1, _2, _3).
decl_body(compile, _1, _2, _3) :- !, item(_1, _2, _3).
decl_body(load, _1, _2, _3) :- !, item(_1, _2, _3).
decl_body(dump, _1, _2, _3) :- !, item(_1, _2, _3).
decl_body(flag, _1, _2, _3) :- !, item(_1, _2, _3).
decl_body(uses, _1, _2, _3) :- !, node(_1, _2, _3).
decl_body(spy, _1, _2, _3) :- !, node(_1, _2, _3).
decl_body(nospy, _1, _2, _3) :- !, node(_1, _2, _3).
decl_body(tracemode, _1, [atom(_1) | _2], _2) :- !.
decl_body(native, _1, _2, _3) :- !, item(_1, _2, _3).

effpath(_1, _2, _3, _4) :- path(_5, _3, _4), datr_append(_1, _5, _2).

datr_decl_name(_1, _2) :- dc_decl_name(_1, _2), !.
datr_decl_name(_1, _1) :- datr_member(_1, [node, atom, reset, show, hide, vars, delete, exec, compile, load, dump, flag, uses, spy, nospy, native, tracemode]), !.
datr_decl_name(encoding(_1), _1) :- datr_member(_1, ['utf-8','utf-16','us-ascii']), !.

decl(dec(_1, _2), [# | _3], _4) :- item(_5, _3, _6), datr_decl_name(_1, _5), decl_1(_1, _2, _6, _4).

top_level(_1, _2, _3) :- sentence(_1, _2, _3), !.
top_level(_1, _2, _3) :- decl(_1, _2, _3), !.
top_level(_1, _2, _3) :- quick_query(_1, _2, _3), !.

var_rhs(_1 - _2, _3, _4) :- range_seq(_1, _5, _3, _6), range_seq_1(_5, _2, _6, _4).

decl_2(_1, [], [dot | _2], _2) :- !.
decl_2(_1, [_2 | _3], _4, _5) :- decl_body(_1, _2, _4, _6), !, decl_2(_1, _3, _6, _5).

stmt(_1, _2, _3, _4, _5, _6, _7) :- effpath(_2, _8, _6, [== | _9]), !, rhs(_1, _8, _3, _4, _5, _9, _7).
stmt(_1, _2, [ext(_1, _3, _4) | _5], _5, ext, _6, _7) :- effpath(_2, _3, _6, [= | _8]), val(_4, _8, _7), !.
stmt(_1, _2, [ext(_1, _3, _4) | _5], _5, ext, _6, _7) :- effpath(_2, _3, _6, [=, ?? | _7]), !.

val(_1, _2, _3) :- !, lval(_4, _1, _2, _3), db_var(_4).

rhs(_1, _2, _3, _4, _5, [atom('[') | _6], _7) :- datr_flag('[_]'), !, stmtsubseq(_1, _2, _3, _4, _5, atom(']'), _6, _7).
rhs(_1, _2, [def(_1, _2, _3) | _4], _4, _5, _6, _7) :- lval(_8, _3, _6, _7).

stmtsubseq(_1, _2, _3, _3, _4, _5, [_5 | _6], _6) :- !.
stmtsubseq(_1, _2, _3, _4, _5, _6, _7, _8) :- stmt(_1, _2, _3, _9, _5, _7, _10), stmtsubseq(_1, _2, _9, _4, _5, _6, _10, _8).

decl_1(vars, _1, _2, _3) :- !, vardecl(_1, _2, _3).
decl_1(_1, _2, _3, _4) :- decl_2(_1, _2, _3, _4).

vardecl_1(_1, _2 - [], [dot | _3], _3) :- !.
vardecl_1([], _1, [: | _2], _3) :- !, var_rhs(_1, _2, _3).
vardecl_1([range(_1, _2) | _3], _2, [dvar(_1) | _4], _5) :- vardecl_1(_3, _2, _4, _5).

lval(_1, list(_2), ['(' | _3], _4) :- !, lvalseq(_1, ')', _2, _3, _4).
lval(_1, list(_2), _3, _4) :- !, lvalseq(_1, bare, _2, _3, _4).

path(_1, [comp(path(_1)) | _2], _2) :- !.
path(_2, [< | _3], _4) :- !, lvalseq(_1, '>', _2, _3, _4), db_var(_1).

desc(lpath(_1), _2, _3) :- lpath(_4, _1, _2, _3), !.
desc(node_lpath(_1, _2), _3, _4) :- node(_1, _3, [: | _5]), !, lpath(_6, _2, _5, _4).
desc(node(_1), _2, _3) :- !, node(_1, _2, _3).

sentence(_1, _2, _3) :- node(_4, _2, [: | _5]), stmtseq(_4, _6, _7, _5, _3), sentence_1(_7, _6, _1).

vardecl(_1, _2, _3) :- vardecl_1(_1, _4, _2, _3).

quick_query(qquery(node_path(_1, _2)), _3, _4) :- node(_1, _3, [: | _5]), path(_2, _5, [? | _4]), !.
quick_query(qquery(node(_1)), _2, _3) :- node(_1, _2, [? | _3]), !.
quick_query(qquery(dump), [? | _1], _1) :- !.

lvalseq(_1, bare, [], _2, _2) :- _2 = [_3 | _4], (_3 = dot ; datr_flag('[_]'), _3 = atom(']')), !.
lvalseq(_1, bare, [], _2, [comp(path(_3)) | _4]) :- path(_3, _2, _4), _4 = [_5 | _6], (_5 = == ; _5 = =), !.
lvalseq(_1, '.>', noext, ['.>' | _3], _3) :- !.
lvalseq(_1, '.>', [], [ > | _3], _3) :- !.
lvalseq(_1, _2, [], [_2 | _3], _3) :- !.
lvalseq(_1, _2, [_3 | _4], _5, _6) :- !, pval(_1, _3, _5, _7), lvalseq(_1, _2, _4, _7, _6).

lpath(_1, _2, [< | _3], _4) :- !, lvalseq(_1, '.>', _2, _3, _4).

range_seq([], dot, [dot | _1], _1) :- !.
range_seq([_1 | _2], _3, _4, _5) :- range_elt(_1, _4, _6), !, range_seq(_2, _3, _6, _5).
range_seq([], -, [atom(-) | _1], _1) :- !.

pval(_1, dvar(_2), [dvar(_2) | _3], _3) :- !.
pval(g(_1), quote(_2), ['"' | _3], _4) :- !, desc(_2, _3, ['"' | _4]).
pval(g(l), desc(_1), _2, _3) :- desc(_1, _2, _3), !.
pval(_1, atom(_2), [atom(_2) | _3], _3) :- !.

stmtseq(_1, _2, _3, _4, _5) :- stmtsubseq(_1, [], _2, [], _3, dot, _4, _5).

range_elt(dvar(_1), [dvar(_1) | _2], _2) :- !.
range_elt(-, _1, _3) :- range_sep(_1, _2), !, range_sep(_2, _3).
range_elt(_1, [atom(_1) | _2], _2) :- !.

range_sep([atom(-) | _1], _1).


item(_1, _2, _3) :- node(_1, _2, _3).
item(_1, [atom(_1) | _2], _2).

range_seq_1(dot, [], _1, _1) :- !.
range_seq_1(-, _1, _2, _3) :- range_seq(_1, dot, _2, _3).


node(_1, [atom(_2), . | _3], _4) :- !, node(_5, _3, _4), datr_qualnode(_2, _5, _1).
node(_1, [node(_1) | _2], _2).

datr_qualnode(A, N1, N2) :-
    db_name(A, AN),
    db_name(N1, N1N),
    datr_append(AN, [46 | N1N],N2N),
    db_name(N2, N2N), !.


% The next line is the Revision Control System Id: do not delete it.
% $Id: parser.pl 1.7 1997/11/23 21:08:07 rpe Exp $
