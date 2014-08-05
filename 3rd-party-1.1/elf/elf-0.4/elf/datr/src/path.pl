% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            path.pl                                                  %
% Purpose:         path manipulation utilities                              %
% Author:          Roger Evans and Liz Jenkins                              %
%                                                                           %
%      Copyright (c) University of Sussex 1992.  All rights reserved.       %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   $Revision: 1.2 $
%   $Author: rpe $
%   $Date: 1996/09/20 21:06:53 $
%   $State: Exp $

%   -- datr_lpath_match(G,NG,P1,P2,L) ---------------------------------------
%
%   G is a term possibly with an lpath in it.  NG is the same term with
%   the lpath replaced by P2 (a variable), P1 is the lpath found, but
%   with atom functors stripped off atoms where found (P1 will be used
%   to build code to make the lpath, the resultant path will be unified
%   with P2, hence incorporated into NG, which will be used in the code).
%   L is the list of variables that may be used in G. Flat operators
%   are just passed back to the caller (wrapping P1)

datr_lpath_match(lpath(flat(P1)),lpath(P2),flat(P1),P2,L) :- !.
datr_lpath_match(node_lpath(N,flat(P1)),node_lpath(N,P2),flat(P1),P2,L) :- !.
datr_lpath_match(G,NG,P1,P2,L) :- !,
    datr_path_domatch(G,[],NG,P1,P2,L).


%   -- datr_path_match(G,X,NG,L) --------------------------------------------
%
%   G is a term possibly with a path in it (lpaths are either not possible
%   or need no special treatment).  NG is the same term with the path
%   extended with the variable X (X will be bound to all the other path
%   extensions in the current clause, and then NG will be used in the code).
%   L is the list of variables that may be used in G.

datr_path_match(G,X,NG,L) :- !,
    datr_path_domatch(G,X,NG,P,P,L).


%   Locate paths in a term, create a term with path replaced by variable,
%   return term, variable and extension of path found.
%   New variables may not be encountered on the RHS of a datr sentence.

datr_path_domatch(path(P2),X,path(P3),no,no,L) :- !,
    datr_path_extend(P2,P3,X,L,L,no).
datr_path_domatch(lpath(P2),X,lpath(P4),P3,P4,L) :- !,
    datr_path_extend(P2,P3,X,L,L,no).
datr_path_domatch(node_lpath(N,P2),X,node_lpath(N,P4),P3,P4,L) :- !,
    datr_path_extend(P2,P3,X,L,L,no).
datr_path_domatch(G,X,G,no,no,_) :- !.


%   -- datr_path_extend(OP,NP,X,OV,NV,VFlag) --------------------------------
%
%   Extend a path OP to NP by putting X on the end.  If the path has subpaths
%   extend those too (we use datr_path_match to find them - don't need
%   datr_lpath_match here because that will be used explicitly if needed
%   later in the recursive code building).  Also strip out atom functors
%   where found.  OV is the list of variables already known, NV is the
%   new list after processing this path. VFlag controls whether new
%   variables may be created.

datr_path_extend([],X,X,L,L,_) :- !.                 % -- end - extend with X
datr_path_extend(noext,noext,X,L,L,_) :- !.             % -- end - *don't* extend with X
datr_path_extend([H|T],[H|NT],X,L,VL,F) :- db_var(H),!, % -- var
    datr_path_extend(T,NT,X,L,VL,F),!.               % carry on down
datr_path_extend([atom(H)|T],[H|NT],X,L,VL,F) :- !,  % -- atom - strip functor
    datr_path_extend(T,NT,X,L,VL,F),!.               % carry on down
datr_path_extend([dvar(V)|T],[NV|NT],X,L,VL,F) :- !, % -- variable
    datr_getvar(V,NV,L,NVL,F),                       % get prolog vble
    datr_path_extend(T,NT,X,NVL,VL,F),!.               % carry on down
datr_path_extend([quote(H)|T],[quote(H2)|NT],X,L,VL,F) :- !, % -- quote
    datr_path_match(H,X,H2,L),                       % match desc component
    datr_path_extend(T,NT,X,L,VL,F),!.               % carry on down
datr_path_extend([H|T],[H2|NT],X,L,VL,F) :- !,       % -- desc
    datr_path_match(H,X,H2,L),                       % match desc
    datr_path_extend(T,NT,X,L,VL,F),!.               % carry on down


%   Each datr variable in a path is replaced by a prolog variable, the
%   same one every time it occurs.

datr_getvar(V,NV,VL,VL,_) :-
    datr_member(datr_var(V,NV),VL), !.           % datr variable seen before
datr_getvar(V,NV,VL,[datr_var(V,NV)|VL],yes) :-  % added to list of variables
    datr_variable(V,R), !.                         % if not seen before
datr_getvar(V,NV,VL,[datr_var(V,NV)|VL],yes) :- !. % undeclared variables
datr_getvar(V,_,_,_,_) :- !,
   datr_error(V,'invalid DATR variable').        % new variable on RHS
