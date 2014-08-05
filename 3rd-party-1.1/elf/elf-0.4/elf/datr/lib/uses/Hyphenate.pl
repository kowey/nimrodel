% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/uses/Hyphenate.pl                                    %
% Purpose:         DATR library function: Hyphenate                         %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 2001.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


'Hyphenate'([Sep,A|P], _GN, _GP, [A|L]) :- datr_lib_hyphenate(P,Sep,L), !.
'Hyphenate'(P,GN,GP,V) :- 'Fail'(['Hyphenate' | P],GN,GP,V).

datr_lib_hyphenate([A|T1],Sep,[A,Sep|T2]) :-
    datr_lib_hyphenate(T1, Sep, T2).
datr_lib_hyphenate([], _Sep, []).

% The next line is the Revision Control System Id: do not delete it.
% $Id: Idem.pl 1.1 1999/03/04 15:38:35 rpe Exp $
