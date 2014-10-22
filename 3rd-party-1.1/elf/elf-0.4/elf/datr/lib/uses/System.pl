
'System'([readline|_P], _GN, _GP, V) :- !, system_readline(V1), V1=V.
'System'([readstring|_P], _GN, _GP, V) :- !, system_readstring(V1), V1=V.
'System'([readinput|P], _GN, _GP, V) :- !, system_readinput(P,V1), V1=V.
'System'([writeline|P], _GN, _GP, []) :- !, datr_write_val2(P, ' '), nl.
'System'([firstline|P], _GN, _GP, V) :- !, system_firstline(P, V1), V1=V.
'System'([skipfirstline|P], _GN, _GP, V) :- !, system_skipfirstline(P, V1), V1=V.
'System'([writecompact|P], _GN, _GP, []) :- !, datr_write_val2(P, '').
'System'([gettime|P], _GN, _GP, V) :- !, system_gettime(P, V).
'System'([query, N|P], _GN, _GP, V) :- !, datr_qnode(ON,OP), datr_query(N,P,V), db_asserta(datr_qnode(ON,OP)).
'System'([exit|_P], _GN, _GP, []) :- !, halt.
'System'([Command|Code], _GN, _GP, []) :- (Command = consult; Command = reconsult), !,
	datr_compile(tokens(Code), Command, '**system**').
'System'([atom, A|_], _GN, _GP, [atom(A)]) :- !.
'System'([node, A|_], _GN, _GP, [node(A)]) :- !.
'System'([dvar, A|_], _GN, _GP, [dvar(A)]) :- !.
'System'([exists|NodeSpec], _GN, _GP, [Node]) :- !,
	system_nodefunctor(NodeSpec, F),
	(clause(F,_B) -> functor(F, Node, _); Node = '**fail**').
'System'([retract|NodeSpec], _GN, _GP, []) :- !, 
	system_nodefunctor(NodeSpec, F),
	db_retractall(F).
'System'([remove, Command|NodeSpec], _GN, _GP, []) :- !, 
	system_nodefunctor(NodeSpec, F),
	datr_remove(Command,F,_Clauses).
'System'([nodename|NodeSpec], _GN, _GP, [N]) :- !,
	system_nodename(NodeSpec, N, []).
'System'([prolog | Files], _GN, _GP, []) :- !, 
	system_loadfiles(Files).
'System'([CaseOp | Atoms], _GN, _GP, List) :- clause(system_caseop2(CaseOp,_,_),_Body), !,
	system_caseop(Atoms, CaseOp, List).

system_nodename([node(N)|P], N, P) :-  !.
system_nodename([atom(A), '.'|NP], N, P) :- !,
	system_nodename(NP, N2, P),
	db_name(N2,N2Name),
	db_name(A,AName),
    datr_append(AName,[46|N2Name],NName), 
	db_name(N, NName).
system_nodename([atom(N)|P], N, P) :- !.
system_nodename([N|P], N, P).
	
system_nodefunctor(NodeSpec, F) :-
	system_nodename(NodeSpec, N, P),
	functor(F,N,4), 
	datr_path_extend(P,NP,_X,[],_,no),
	arg(1, F, NP).
	
system_readline(S) :- !,
    db_seeing(Tag),
    (db_retract(datr_lastchar(C, Tag)), datr_eofchar(C); C = 32),!,   
    system_readline2(S,C,NC), !,
    db_asserta(datr_lastchar(NC, Tag)).              % save lookahead char

system_readline2(['#eof'], C, C) :- datr_eofchar(C), !.
system_readline2([0], C, C) :- C = 10, !.
system_readline2(T, C, NC) :- datr_whitechar(C), !,
	db_get0(IC), 
	system_readline2(T, IC, NC).
system_readline2([N|T], C, NC) :-
	system_readline3(T, N, C, NC).
	
system_readline3([Token|Tokens],N,C,NC) :-
    system_readword(Token,C,IC),                  % get one token
    system_readline4(Tokens,IN,IC,NC),            % get more (if necessary)
	N is IN + 1.

system_readline4([],0,C,C) :-
    (datr_eofchar(C); C = 10),!.          		  % finish at end of line (or file)
system_readline4(T, N, C, NC) :- datr_whitechar(C), !,
	db_get0(IC), 
	system_readline4(T, N, IC, NC).
system_readline4(Tokens,N,C,NC) :- !,
    system_readline3(Tokens,N,C,NC). 
	
system_readword(W, C, NC) :-
	system_readchars(WC, C, NC),
	db_name(W, WC).

system_readchars(Chrs, C, NC) :- datr_quotechar(C),!,            % quoted item
    datr_endquotechars(EC),
    datr_readcharsto(EC,Chrs,NC).   % read to quote closer
system_readchars([], C, C) :- (datr_whitechar(C); datr_eofchar(C)), !.
system_readchars([C|R], C, NC) :-
	db_get0(IC),
	system_readchars(R, IC, NC).
	
system_readstring(S) :- !,
    db_seeing(Tag),
    (db_retract(datr_lastchar(C, Tag)), datr_eofchar(C); C = 32),!,   
    system_readstring2(S,C,NC), !,
    db_asserta(datr_lastchar(NC, Tag)).              % save lookahead char

system_readstring2(['#eof'], C, C) :- datr_eofchar(C), !.
system_readstring2([''], C, C) :- C = 10, !.
system_readstring2(T, C, NC) :- C = 13, !,
	db_get0(IC), 
	system_readstring2(T, IC, NC).
system_readstring2([S], C, NC) :-
	system_readstring3(SChars, C, NC),
	db_name(S, SChars).
	
system_readstring3([],C,C) :-
    (datr_eofchar(C); C = 10),!.          		  % finish at end of line (or file)
system_readstring3([C|T], C, NC) :- 
	db_get0(IC), 
	system_readstring3(T, IC, NC).

system_readinput(P,[N]) :- 
	db_get0(C),
	system_readinput1(P,C,L),
	db_name(N,L).
system_readinput1([],C,[]) :- datr_eofchar(C), !.
system_readinput1([C],C,[]) :- !.
system_readinput1(P,C,[C|L]) :-
	db_get0(C2),
	system_readinput1(P,C2,L).
	
system_firstline([SN], [FLN]) :-
	db_name(SN, S),
	system_firstline2(S, FL),
	db_name(FLN,FL).
system_firstline2([], []).
system_firstline2([10|_], []).
system_firstline2([H|T], [H|NT]) :- system_firstline2(T, NT).

system_skipfirstline([SN], [FLN]) :-
	db_name(SN, S),
	system_skipfirstline2(S, FL),
	db_name(FLN,FL).
system_skipfirstline2([], []).
system_skipfirstline2([10|L], L).
system_skipfirstline2([_H|T], NT) :- system_skipfirstline2(T, NT).

	
system_loadfiles([]).
system_loadfiles([H|T]) :-
	db_reconsult(H),
	system_loadfiles(T).
	
system_gettime([], V) :- system_gettime(['%a, %d %b %Y %T %z'], V).
system_gettime([F|_], [V]) :-
	get_time(Time),
	stamp_date_time(Time, Date, 'UTC'),
	format_time(atom(V), F, Date).
	
system_caseop([], _CaseOp, []).
system_caseop([H|T], CaseOp, [NH|NT]) :-
	system_caseop2(CaseOp, H, NH),
	system_caseop(T, CaseOp, NT).
	
system_caseop2(lowercase, In, Out) :- !, downcase_atom(In, Out).
system_caseop2(uppercase, In, Out) :- !, upcase_atom(In, Out).
system_caseop2(casetype, In, lowercase) :- downcase_atom(In, In), !.
system_caseop2(casetype, In, uppercase) :- upcase_atom(In, In), !.
system_caseop2(casetype, In, capitalised) :- 
	name(In, [First|Chars]), 
	code_type(First, upper),
	name(Rest, Chars),
	downcase_atom(Rest,Rest), !.
system_caseop2(casetype, _In, mixed) :- !.
	


