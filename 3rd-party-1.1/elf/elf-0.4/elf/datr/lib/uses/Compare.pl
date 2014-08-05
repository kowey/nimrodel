% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Compare.pl                                      %
% Purpose:         DATR library function: Compare                           %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2003.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Compare'([A, B|_P], _GN, _GP, L) :- 
	(integer(A);float(A)), 
	(integer(B);float(B)),
	datr_lib_compare(A,B,L), !.
'Compare'(P,GN,GP,V) :- 'Fail'(['Compare'|P],GN,GP,V).

datr_lib_compare(A,A, equal) :- !.
datr_lib_compare(A,B, less) :- A < B ,!.
datr_lib_compare(_A,_B, more).
