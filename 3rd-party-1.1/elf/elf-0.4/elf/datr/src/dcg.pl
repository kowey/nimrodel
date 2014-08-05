% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            dcg.pl                                                   %
% Purpose:         DCG parser for DATR definitions                          %
% Author:          Roger Evans and Liz Jenkins                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1994.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   -- s(Words,Rem,Tree) ----------------------------------------------------
%
%   Basically a standard DCG.
%
%   The syntax differs from that given in the inference and semantics
%   papers - this one does not have the excessive structural ambiguity
%   for values.  It also caters for node definition abbreviations,
%   declarations, variables, flattening and queries.
%
%   It builds a structural description of a sentence as a list
%   of terms, each representing a definitional or extensional
%   statement.
%
%   The parser optimises its handling of values by implementing the
%   l-g-v hierarchy using unification. Values are instances of 'lval'
%   with an argument that specifies their type - if the arg is a variable,
%   its a value, if it is g(X), (X a variable) it is a gvalue (but not
%   a value), if it is g(l), it is an lvalue (but not a gvalue). This means
%   that when parsing list values, all the args can be unified together
%   to give the arg of the expression as a whole.
%
%   N.B. the parser may well handle more cases than any particular
%        compiler does.

% == TOP LEVEL ============================================================

%   top_level(-S)

%   Parse a top level expression, returning a syntactic structure S.
%   Top level expressions are declarations, 'quick' queries, full sentences
%   (which may themselves contain ordinary queries).

top_level(S) --> sentence(S),!.
top_level(S) --> decl(S),!.
top_level(S) --> quick_query(S),!.


% == SENTENCES ============================================================

%   sentence(-Statements)

%   Read a Datr sentence and return syntactic structures for the statements
%   it contains.

sentence(S) --> node(N), [':'], stmtseq(N,S1,Ext), {sentence_1(Ext,S1,S)}.


%   sentence_1(+Ext,+Sin,-Sout)

%   sentence_1 tests Ext to discover whether the sequence Sin contains
%   any extensional sentences (iff Ext is not a free variable). If
%   so, Sout is wrapped in a query/1 term to indicate a query request.

sentence_1(Ext,S,S) :- db_var(Ext),!.
sentence_1(Ext,S,query(S)).


% -- Statement sequences ----------------------------------------------------

%   stmtseq(+Node,-Seq,-Ext)

%   Read a sequence of (nodeless) statements terminated by a period.
%   Construct a list Seq of structures for them. Instantiate Ext if
%   any extensional sentences were encountered.

stmtseq(N,S,Ext) --> stmtsubseq(N,[],S,[],Ext,dot).


%   stmtsubseq(+Node,+Path,-Sout,+Sin,-Ext,+Term)

%   Read a sequence of (nodeless) statements in the context of Node,Path.
%   up to the terminator Term. Add structures for sentences read to Sin
%   giving Sout. Instantiate Ext if any extensional sentences encountered.

stmtsubseq(N,P,S,S,Ext,Term) --> [Term], !.
stmtsubseq(N,P,Sout,Sin,Ext,Term) --> stmt(N,P,Sout,Stmp,Ext),
                                    stmtsubseq(N,P,Stmp,Sin,Ext,Term).

% -- Statements -------------------------------------------------------------

%   stmt(+Node,-Sout,+Sin,-Ext)

%   Read a nodeless statement for node Node and add a structure for it
%   to Sin giving Sout. If it's extensional, instantiate Ext.

stmt(N,P1,Sout,Sin,Ext) --> effpath(P1,P2), ['=='], !, rhs(N,P2,Sout,Sin,Ext).
stmt(N,P1,[ext(N,P2,L)|S],S,ext) --> effpath(P1,P2), ['='], val(L), !.
stmt(N,P1,[ext(N,P2,_)|S],S,ext) --> effpath(P1,P2), ['=', '??'], !.

rhs(N,P,Sout,Sin,Ext) --> {datr_flag('[_]')}, [atom('[')], !, stmtsubseq(N,P,Sout,Sin,Ext,atom(']')).
rhs(N,P,[def(N,P,L)|S],S,Ext) --> lval(_,L).

effpath(P1,P3) --> path(P2), {datr_append(P1,P2,P3)}.


% -- Values -----------------------------------------------------------------

%   val(-V)

%   a value is an lvalue whose type arg (X) is uninstantiated

val(V) --> !, lval(X,V), {db_var(X)}.


% -- Lvalues ----------------------------------------------------------------

%   lvalue as () sequence of lvalues
lval(X,list(L)) --> ['('], !, lvalseq(X,')',L).
lval(X,list(L)) --> !, lvalseq(X,bare,L).

%   primitive lvalue: arg X is more instantiated the higher up the l-g-v
%   sequence it is (l higher than g higher than v)
pval(X,dvar(V)) --> [dvar(V)], !.
pval(g(X),quote(D)) --> ['"'], !, desc(D), ['"'].
pval(g(l),desc(D)) --> desc(D), !.
pval(X,atom(A)) --> [atom(A)], !.


% -- Lvalue sequences -------------------------------------------------------

%   lvalue sequence - arg is unification of member args - ie the
%   same as the highest member in the l-g-v sequence. E is the closing
%   bracket ('>' or ')').

lvalseq(X,bare,[],L,L) :- L = [F|R], (F = dot; datr_flag('[_]'), F = atom(']')),!.
lvalseq(X,bare,[],L,[comp(path(P))|L2]) :-
    path(P,L,L2), L2 = [F|R], (F = '=='; F = '='), !.
lvalseq(X,'.>',noext) --> ['.>'], !.
lvalseq(X,'.>',[]) --> ['>'], !.
lvalseq(X,E,[]) --> [E], !.
lvalseq(X,E,[H|T]) --> !, pval(X,H),lvalseq(X,E,T).


% -- Descriptors ------------------------------------------------------------

desc(lpath(P)) --> lpath(F,P), !.
desc(node_lpath(N,P)) --> node(N), [':'], !, lpath(X,P).
desc(node(N)) --> !, node(N).


% -- lpaths -----------------------------------------------------------------

%   lpaths as <> sequences of lvalue (X is the overall type)
lpath(X,P) --> ['<'], !, lvalseq(X,'.>',P).


% -- paths ------------------------------------------------------------------
%   paths are lpaths containing only values (ie X uninstantiated)

path(P) --> [comp(path(P))],!.
path(P) --> !, ['<'], lvalseq(X,'>',P), {db_var(X)}.


% == QUICK QUERIES =========================================================

%   quick_query(-S)

%   Quick queries are terminated by a question mark rather than a period.
%   They can contain a node/path pair, just a node, or nothing at all,
%   (they refer to paths/nodes declared with 'show' and 'hide' to fill
%   in missing information)

quick_query(qquery(node_path(N,P))) --> node(N), [':'], path(P), ['?'], !.
quick_query(qquery(node(N))) --> node(N), ['?'], !.
quick_query(qquery(dump)) --> ['?'], !.


% == DECLARATIONS ===========================================================

%   declaration(-Declarations)
%       Declarations = dec(Type,Body)

%   Declarations are introduced by a #, followed by a known declaration
%   keyword, and the declaration body. Keywords are mapped onto declaration
%   types using the (user-customisable) predicate -datr_decl_name-. The
%   returned structure is an instance of dec/2 containing the (mapped) type
%   Type, and a list, Body, of entities (type-dependent) being declared.

decl(dec(Type,Body)) --> ['#'], item(Key), {datr_decl_name(Type,Key)},
                         decl_1(Type,Body).


%   decl_1(+Type,-Body)

%   Declaration bodies are generally lists of single body instances.
%   But vars is a special case, because of the range specification,
%   we use -vardecl- to read the whole body as a single item.

decl_1(vars,Body) --> !, vardecl(Body).
decl_1(Type,Body) --> decl_2(Type,Body).


%   decl_2(+Type, -Body)

%   Read the body of ordinary declarations. Body is a list of values
%   for each body element found.

decl_2(_,[]) --> [dot], !.
decl_2(Type,[H|T]) --> decl_body(Type,H), !, decl_2(Type,T).


% -- Declaration bodies -----------------------------------------------------

%   decl_body(+Type, +Body)

%   Parse individual bodies (except vars, handled separately), returning
%   structure of body in Body.

decl_body(node,N) --> !, item(N).
decl_body(atom,N) --> !, item(N).
decl_body(show,P) --> !, path(P).
decl_body(hide,N) --> !, node(N).
decl_body(compile,N) --> !, item(N).
decl_body(load,N) --> !, item(N).
decl_body(dump,N) --> !, item(N).
decl_body(flag,N) --> !, item(N).
decl_body(uses,N) --> !, node(N).
decl_body(spy,N)  --> !, node(N).
decl_body(nospy,N)  --> !, node(N).
decl_body(tracemode,N) --> !, [atom(N)].
decl_body(native,N) --> !, item(N).


% -- Variable declarations --------------------------------------------------

%   vardecl(-Variables)
%       Variables = [range(Var,Range), ... ]

%   Variable sequences used in variable declarations - space-separated
%   datr variable tokens, terminated by a period (no range) or a colon,
%   followed by a range specification. Returned structure is a list of
%   range/2 terms giving the Range associated with each Var (NB: all the
%   ranges in a single declaration will be the same). If no range is given,
%   Range is a free variable.

vardecl(V) --> vardecl_1(V,R).


%   vardecl_1(-Variables,-Range)

%   Variable sequence utility. Variables is as in -varseq-, Range is the
%   common range for the declarations (a list of atoms).

vardecl_1(V,R-[]) --> [dot],!.                  % no range specified
vardecl_1([],R) --> [':'], !, var_rhs(R).       % read range
vardecl_1([range(V,R)|T],R) --> [dvar(V)],      % variable - add to list and
                                vardecl_1(T,R). % look for more


% -- Range specifications --------------------------------------------------

%   var_rhs(-Attributes)

%   Right hand sides of variable declarations may contain sequences of
%   atoms or other variable name. They may also contain a hyphen and
%   atoms/vars occuring after the hyphen are treated as being EXCLUDED from the
%   range.

%   Read a positive range R, with terminator Term, then maybe pick up
%   a negative range NR too (depending on Term).

var_rhs(R-NR) --> range_seq(R,Term), range_seq_1(Term,NR).


%   range_seq(-Range,-Term)

%   read a list of range elements, Range, until we encounter a terminator
%   (dot or '-'), which we return as Term.

range_seq([], dot) --> [dot], !.
range_seq([R|T],Term) --> range_elt(R), !, range_seq(T,Term).
range_seq([], '-') --> [atom('-')], !.

%   range_seq_1(+Term, -NegRange)

%   If given terminator is ':', read another list of range elements (NegRange)
%   otherwise leave it free.

range_seq_1(dot,[]) --> !.
range_seq_1('-',NR) --> range_seq(NR,dot).

%   range_elt(-Elt)

%   read a single range element - a variable name or atom.

range_elt(dvar(V)) --> [dvar(V)], !.
range_elt('-') --> range_sep, !, range_sep.
range_elt(A) --> [atom(A)], !.

range_sep --> [atom('-')].

% -- Arbitrary Items --------------------------------------------------------

%   item(-Token)

%   Read a note or atom token, ignoring the distinction between them.
%   Return the (stripped) token as Token.

item(N) --> node(N).
item(N) --> [atom(N)].

% -- Nodes ------------------------------------------------------------------

%    node(-node(N))

%    Read a node expression, which may include module qualifiers
node(N) --> [atom(A), '.'], !, node(N1), { datr_qualnode(A, N1, N) }.
node(N) --> [node(N)].

datr_qualnode(A, N1, N2) :-
    db_name(A, AN),
    db_name(N1, N1N),
    datr_append(AN, [46 | N1N],N2N),
    db_name(N2, N2N), !.

% -- utilities --------------------------------------------------------------

%   mapping from keytype to atom used to represent it
%   user can override default (identity) mapping using dc_decl_name

datr_decl_name(K,A) :-
    dc_decl_name(K,A),!.
datr_decl_name(K,K) :-
    datr_member(K,[node,atom,reset,show,hide,vars,delete,exec,compile,load,dump,flag,uses,spy,nospy,native,tracemode]),!.
datr_decl_name(encoding(K), K) :-
    datr_member(K, ['utf-8','utf-16','us-ascii']),!.

% The next line is the Revision Control System Id: do not delete it.
% $Id: dcg.pl 1.7 1997/11/23 21:03:34 rpe Exp $
