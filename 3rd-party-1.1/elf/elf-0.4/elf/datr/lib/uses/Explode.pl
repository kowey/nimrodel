% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Explode.pl                                      %
% Purpose:         DATR library function: Explode                           %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Explode'(P, _GN, _GP, V) :- datr_lib_explode(P,V).

datr_lib_explode([H|T],VL) :-
    db_name(H,HL), !,
    datr_lib_explode_append(HL,VL2,VL), !,
    datr_lib_explode(T,VL2).
datr_lib_explode([],[]).

datr_lib_explode_append([],VL,VL).
datr_lib_explode_append([H|T],VL1,[HN|VL2]) :- !,
    db_name(HN,[H]), !,
    datr_lib_explode_append(T,VL1,VL2).


% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
