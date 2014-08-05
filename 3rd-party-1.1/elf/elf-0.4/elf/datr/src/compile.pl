% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            compile.pl                                               %
% Purpose:         DATR compiler main code                                  %
% Author:          Roger Evans and Liz Jenkins                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1994.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   -- datr_compile(InFile,OutFile) -----------------------------------------
%   -- datr_compile(InFile) -------------------------------------------------
%
%   Compile DATR source from InFile and place results in OutFile. InFile and
%   OutFile are as described in main.pl. If OutFile is omitted "reconsult"
%   is assumed (ie compile into current database)

datr_compile(InFile, OutFile, Tag) :- !,
	datr_main(InFile, OutFile, datr_do_compile, Tag).
datr_compile(InFile, OutFile) :- !,  % no tag - use InFile itself, unless its a token stream
	(InFile=tokens(_) -> Tag=tokens; Tag=InFile),
	datr_compile(InFile, OutFile, Tag).
datr_compile(File) :- !,			 % no output, use reconsult
	datr_compile(File,reconsult).


%   -- datr_query(Node,Path,Value) ------------------------------------------
%
%   Basic query predicate for code produced by this compiler. Node is a
%   (prolog) atom, Path is a (prolog) list of (prolog) atoms. Succeeds
%   iff V unifies with the extensional value defined by the datr code


datr_query(N,P,V) :-
	(dc_before_query(N,P,V);true),!,
	db_retractall(datr_qnode(_,_)),
	db_asserta(datr_qnode(N,P)), !,
	datr_call([N,P,N,P,V]),
	db_retractall(datr_qnode(_,_)),
	(dc_after_query(N,P,V);true),
	!.


%   the main compiler entry points (accessed by datr_main in main.pl):

datr_do_compile(init([])) :- !.         % initialise clause list
datr_do_compile(comp(A,B,C,D)) :- !,    % compile a parse tree into clauses
    datr_compile_proc(A,B,C,D).
datr_do_compile(final(A,B,Tag)) :- !,       % finalise free-standing clause list
    datr_compile_final(A,B,Tag).
datr_do_compile(node(Node,Name)) :- !,  % map node id onto node name
    db_goal([Name|_],Node).


%   constructing clauses for a given parse tree: a list of def or ext
%   (but not both) sentences about a single node. Node is the id for
%   clauses built, ie a sufficiently instantiated clause head to access
%   ALL clauses for this node (not just the ones built here)

datr_compile_proc(qquery(S),C,CD,Node) :- !,
    datr_do_qquery(S).
datr_compile_proc([H|T],C,CD,Node) :- !,
    datr_compile_clause(H,TC,C,TCD,CD,Node),    % get clause for first
    datr_compile_proc(T,TC,TCD,Node).           % then get the rest
datr_compile_proc([],[],[],Node).


%   build internal representation for a clause

datr_compile_clause(def(N,P,L),     % definitional sentences
    CL,[(Head :- Tail)|CL], CDL,[X|CDL],Node) :- !,

    db_goal([N,_,_,_,_],Node),                          % build node id
    datr_path_extend(P,NP,X,[],VL,yes),                 % extend tail with X
    db_goal([N,NP,GN,GP,V],Head),                       % build clause head
    datr_compile_tail(L,hargs(N,NP,GN,GP),X,V,Tail,VL). % build tail

datr_compile_clause(ext(N,P,V),     % extensional sentences (queries)
    CL,CL,CDL,CDL,none) :- !,

    datr_path_extend(P,NP,[],[],[],no),         % remove atom functors in path
	% a nasty patch... RE  24/3/95
	% mark uninstantiated query vars to avoid confusing datr_compile_rest
	(db_var(V) -> V2=ext(V);V2=V),	
    datr_compile_tail(V2,H,[],NV,(true,!,Tail),[]),   % compile code to build value
    db_call(Tail),                              % run it to get actual value
    datr_do_query(N,NP,NV).                     % answer the query

%   warn about anything and ignore it
datr_compile_clause(X,CL,CL,CDL,CDL,none) :- !,
    datr_warn(X,'invalid DATR statement').


%   build the tail of a clause (Hargs is a hargs/4 structure containing
%   the N,P,GN,GP args of the head)

datr_compile_tail(L,Hargs,X,V,Tail,VL) :- !,
    datr_compile_var(VL,VTail),                 % build clauses for vars
    datr_compile_rest(L,Hargs,X,V2,CTail,VL),   % build rest of tail
    datr_optimise(CTail,OTail),        			% optimise main body
	datr_combine_tail(V,V2,VTail,OTail,Tail).	% put all the bits together

%	combine bits of the tail together - here we optimise handling of
%	value var - if the body vaule is unistantiated we can unify it
%	with the head now, but otherwise we have to do it AFTER the cut.

datr_combine_tail(V1,V2,VTail,BTail,(VTail,Tail)) :- var(V2),!,
	V1=V2, (BTail = (!,_), Tail=BTail; Tail=(!,BTail)), !.
datr_combine_tail(V1,V2,VTail,BTail,(VTail,!,V1=V2,BTail)).


%   build the rest of the tail of a clause for N:P according to value type

datr_compile_rest(NV,Hargs,X,V,Tail,VL) :-          % -- prolog var
    db_var(NV),!,                                   % (compiled datr var)
    Tail=(V=[NV],!).                                % unify value
datr_compile_rest(ext(NV),Hargs,X,V,Tail,VL) :- !,  % -- open query
    Tail=(V=NV,!).                                  % unify value
datr_compile_rest(list(L),Hargs,X,V,Tail,VL) :- !,  % -- list
    datr_compile_list(L,Hargs,X,LV,LGoal,VL,[]),    % compile code to build it
    Tail=(LGoal,!,V=LV,!).                          % add unification with V
datr_compile_rest(atom(A),Hargs,X,V,Tail,VL) :- !,  % -- atom
    Tail=(V=[A],!).                                 % unify value
datr_compile_rest(dvar(W),Hargs,X,V,Tail,VL) :- !,  % -- datr variable
    datr_member(datr_var(W,NV),VL),               % find corresponding
    Tail=(V=[NV],!).                                % prolog var and unify
datr_compile_rest(quote(G),Hargs,X,V,Tail,VL) :- !, % -- quoted thing
    datr_lpath_match(G,NG,P1,P2,VL),                % match RHS lpaths
    datr_compile_list(P1,Hargs,X,P2,Tail1,VL,X),    % build evaluable path code
    datr_compile_quoted(NG,Hargs,V,Tail2),          % build quoted tail code
    datr_optimise((Tail1,!,Tail2),Tail).          % put them together
datr_compile_rest(desc(L),Hargs,X,V,Tail,VL) :- !,  % -- descriptor
    datr_lpath_match(L,NL,P1,P2,VL),                % match RHS lpaths
    datr_compile_list(P1,Hargs,X,P2,Tail1,VL,X),    % build evaluable path code
    datr_compile_desc(NL,Hargs,V,Tail2),            % build desc tail code
    datr_optimise((Tail1,!,Tail2),Tail).          % put them together

%   assume anything else is a stripped atom (or arbitrary foreign term)
datr_compile_rest(A,Hargs,X,V,Tail,_) :- !,         % -- bare atom
    Tail=(V=[A]).                                   % unify value


%   compile a list structure - build code for each element and
%   conjoin them. Use the same path extension X throughout.
%   N.B. Produces code even for non-evaluable paths, but this
%   gets optimised away later.

datr_compile_list(no,Hargs,X,_,true,_,_) :- !.   % no lpath found
datr_compile_list(noext,Hargs,X,[],true,_,Y) :- !.
datr_compile_list([],Hargs,X,Y,true,_,Y) :- !.
datr_compile_list([H|T],Hargs,X,V,(TH,!, datr_append(VH,VT,V), !, TT),VL,Y) :- !,
    datr_compile_rest(H,Hargs,X,VH,TH,VL),
    datr_compile_list(T,Hargs,X,VT,TT,VL,Y).


%   Build clauses to check variable ranges

datr_compile_var([],true) :- !.
datr_compile_var([datr_var(V,NV)|VT],(datr_var_member(NV,V),T)) :- !,
    datr_compile_var(VT,T).


%   Build the tail for a quoted descriptor

datr_compile_quoted(node(N2),hargs(N1,P1,GN,GP),V,Tail) :- !,
	db_goal([N2,GP,N2,GP,V],Tail).
datr_compile_quoted(lpath(P2),hargs(N1,P1,GN,GP),V,Tail) :- !,
    db_plantcall([GN,P2,GN,P2,V],Tail).
datr_compile_quoted(node_lpath(N2,P2),hargs(N1,P1,GN,GP),V,Tail) :- !,
	db_goal([N2,P2,N2,P2,V],Tail).

%   Build the tail for a bare descriptor

datr_compile_desc(node(N2),hargs(N1,P1,GN,GP),V,Tail) :- !,
	db_goal([N2,P1,GN,GP,V],Tail).
datr_compile_desc(lpath(P2),hargs(N1,P1,GN,GP),V,Tail) :- !,
    db_goal([N1,P2,GN,GP,V],Tail).
datr_compile_desc(node_lpath(N2,P2),hargs(N1,P1,GN,GP),V,Tail) :- !,
	db_goal([N2,P2,GN,GP,V],Tail).




%   execute a query, using code in runtime.pl

datr_do_query(N,P,V) :- datr_theorem(N,P,V),!.
datr_do_query(N,P,V) :- !, datr_warn([N,P,V],'query failed').


%   execute a qquery, using code in runtime.pl

datr_do_qquery(node_path(N,P)) :- !,
    datr_path_extend(P,NP,[],[],[],no),         % remove atom functors in path
    datr_do_query(N,NP,V).
datr_do_qquery(node(N)) :- !, datr_theorem(N).
datr_do_qquery(dump) :- !, datr_theorem.


%   Optimise code built - normalise conjunct structure, remove 'true' goals
%   (most of them!) and execute anything that can be done at compile-time

datr_optimise(A,C) :-
	datr_optimise1(A,B),
	datr_optimise2(B,C).

datr_optimise1(((A,B),C),NA) :- !, datr_optimise1((A,(B,C)),NA).
datr_optimise1((true,B),NB) :- !, datr_optimise1(B,NB).
datr_optimise1(((X=Y),B),NB) :- X=Y,!, datr_optimise1(B,NB).
datr_optimise1((datr_append(X,Y,X),B),NB) :- nonvar(Y), Y = [], !,
	datr_optimise1(B,NB).
datr_optimise1((datr_append(X,Y,Z),B),NB) :- db_nonvar(X),!,
    datr_append(X,Y,Z),     % do the append now
    datr_optimise1(B,NB).
datr_optimise1((A,B),(A,NB)) :- !, datr_optimise1(B,NB).
datr_optimise1(A=A,true) :- !.
datr_optimise1(A,A).

datr_optimise2((A,B),C) :- !,
	datr_optimise2(B,NB),
	datr_optimise3(A,NB,C).
datr_optimise2(A, A).

datr_optimise3(!, (!, A), (!, A)) :- !.
datr_optimise3(A, !, A) :- !.
datr_optimise3(A, B, (A,B)).

%   Finalisation routine - standalone code needs datr_query, datr_member and
%   datr_append predicates.

datr_compile_final(C,CL,Tag) :- !,
    db_plantcall([N,P,N,P,V],G),
    datr_append(
        [	(:- retractall(datr_runtime(Tag,_))) | C ],
        [
            (datr_query(N,P,V) :- !, G),

            (datr_append([],L,L) :- !),
            (datr_append([H|L1],L2,[H|L3]) :- !, datr_append(L1,L2,L3)),
			%	final clause allows ^ to return non-lists
            (datr_append(H,T,[H|T]) :- !),

            (datr_member(X1,[X1|_]) :- !),
            (datr_member(X2,[_|Y2]) :- !, datr_member(X2,Y2))

        ],
    CL).


% The next line is the Revision Control System Id: do not delete it.
% $Id: compile.pl 1.7 1996/09/20 21:17:20 rpe Exp $
