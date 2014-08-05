% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Sed.pl                                          %
% Purpose:         DATR library function: Sed                               %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Sed'([Sep|P], _GN, _GP, L) :- datr_lib_sed(P,Sep,L), !.
'Sed'(P,GN,GP,V) :- 'Fail'(['Sed' | P],GN,GP,V).

datr_lib_sed(P1, Sep, P4) :-
    datr_lib_sed_pattern(P1,Sep,Patt1,P2),
    datr_lib_sed_pattern(P2,Sep,Patt2,P3),
    datr_lib_sed_subst(P3,Patt1,Patt2,P4).

datr_lib_sed_pattern([Sep|Rest],Sep,[],Rest) :- !.
datr_lib_sed_pattern([H|T],Sep,[H|T2],P) :-
    datr_lib_sed_pattern(T,Sep,T2,P).

datr_lib_sed_subst([],_Patt,_Subst,[]).
datr_lib_sed_subst(P1,Patt,Subst,P4) :-
    datr_append(Patt,P2,P1),!,
    datr_lib_sed_subst(P2,Patt,Subst,P3),
    datr_append(Subst,P3,P4).
datr_lib_sed_subst([H|T1],Patt,Subst,[H|T2]) :-
    datr_lib_sed_subst(T1,Patt,Subst,T2).

% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
