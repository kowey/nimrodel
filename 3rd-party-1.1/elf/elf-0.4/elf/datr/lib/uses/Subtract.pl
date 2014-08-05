% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Subtract.pl                                          %
% Purpose:         DATR library function: Subtract                               %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex subtract Brighton 2003.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Subtract'([A|P], _GN, _GP, L) :- (integer(A);float(A)), datr_lib_subtract(A,P,L), !.
'Subtract'(P,GN,GP,V) :- 'Fail'(['Subtract'|P],GN,GP,V).

datr_lib_subtract(A,[B|T1],[C|T2]) :- (integer(B);float(B)), !,
    C is A-B,
    datr_lib_subtract(A, T1, T2).
datr_lib_subtract(_A, T, T).


% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
