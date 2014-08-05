% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Subseq.pl                                         %
% Purpose:         DATR library function: Subseq                              %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% NB: implementation is different from RFC - inexing starts from 1 and
%     a negative first index is interpreted as indexing from the end of
%     the string


'Subseq'([I, J | P], _GN, _GP, L) :- integer(I), integer(J), datr_lib_subseq(I,J,P,L), !.
'Subseq'(P,GN,GP,V) :- 'Fail'(['Subseq'|P],GN,GP,V).

datr_lib_subseq(I,J,L1,L3) :-
    datr_lib_subseq_map(I,J,I2,J2,L1),
    datr_lib_subseq_seq(I2, L1, _, L2),
    datr_lib_subseq_seq(J2, L2, L3, _).

datr_lib_subseq_map(I, J, I3, J2, L) :- I < 0, !,
    datr_lib_subseq_len(L, Len),
    I2 is Len + I + 1,
    datr_lib_subseq_map(I2, J, I3, J2, L).
datr_lib_subseq_map(I, J, I3, J3, L) :- J < 0, !,
    I2 is I + J + 1,
    J2 is 0 - J,
    datr_lib_subseq_map(I2, J2, I3, J3, L).
datr_lib_subseq_map(I,J,I2,J,_L) :-
    I >= 0, J >= 0,
    I2 is I - 1.

datr_lib_subseq_seq(0, L, [], L) :- !.
datr_lib_subseq_seq(I, [H|T], [H|T1], T2) :-
    I2 is I - 1,
    datr_lib_subseq_seq(I2, T, T1, T2).

datr_lib_subseq_len([], 0) :- !.
datr_lib_subseq_len([_|T],I) :-
    datr_lib_subseq_len(T, I2),
    I is I2 + 1.

% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
