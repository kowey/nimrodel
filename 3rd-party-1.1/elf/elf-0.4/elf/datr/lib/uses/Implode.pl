% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Implode.pl                                      %
% Purpose:         DATR library function: Implode                           %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Implode'(P, _GN, _GP, [V]) :- datr_lib_implode(P,VL), db_name(V,VL), !.

datr_lib_implode([H|T],VL) :-
    db_name(H,HL), !,
    datr_append(HL,VL2,VL), !,
    datr_lib_implode(T,VL2).
datr_lib_implode([],[]).


% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
