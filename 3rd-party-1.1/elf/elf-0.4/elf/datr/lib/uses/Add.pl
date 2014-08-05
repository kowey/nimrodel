% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Add.pl                                          %
% Purpose:         DATR library function: Add                               %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex add Brighton 2003.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Add'([A|P], _GN, _GP, L) :- (integer(A);float(A)), datr_lib_add(A,P,L), !.
'Add'(P,GN,GP,V) :- 'Fail'(['Add'|P],GN,GP,V).

datr_lib_add(A,[B|T1],[C|T2]) :- (integer(B);float(B)), !,
    C is A+B,
    datr_lib_add(A, T1, T2).
datr_lib_add(_A, T, T).


% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
