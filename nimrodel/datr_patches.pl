%   File:       datr_patches.pl
%   Purpose:    some patches to the standard DATR system
%   Author:     Roger Evans
%   Version:    1.0
%   Date:       21/12/2013
%
%   (c) Copyright 2013, University of Brighton


% redefine datr_var_member to allow roles to be arbitrary numbers:

:- abolish(datr_var_member/2).
datr_var_member(V,'$elf-role') :- !,number(V).
datr_var_member(V,'$elf-prev') :- !, number(V), V<0.
datr_var_member(V,'$elf-next') :- !, number(V), V>0.
% datr_var_member(A, V) :- datr_runtime(_, cached_vars(V, A, Status)), !, Status = yes.
datr_var_member(A,V) :- datr_runtime(_,vars(V,R-NR)),!,
    datr_range_member(A,R),!,
    db_not(datr_range_member(A,NR)),!.
% undeclared variables range over everything
datr_var_member(_A,_V).


% redefine datr_load_files to accept wildcard patterns

:- abolish(datr_load_files/1).
datr_load_files(L) :- 
	(datr_flag(quiet) -> Verbose=no; Verbose=yes),
	datr_load_files2(L, Verbose).
	
datr_load_files2([],_).
datr_load_files2([H|T],V) :-
	expand_file_name(H, List),
	datr_load_files(List, V),
	datr_load_files2(T, V).
