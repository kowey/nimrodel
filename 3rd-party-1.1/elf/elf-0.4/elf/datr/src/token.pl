% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            token.pl                                                 %
% Purpose:         DATR tokenizer                                           %
% Author:          Roger Evans and Liz Jenkins                              %
%                                                                           %
%      Copyright (c) University of Sussex 1992.  All rights reserved.       %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   -- datr_token(Token,NextChar_In,NextChar_Out) ---------------------------
%
%   Read a token, given next char of input stream, and returning new
%   next char of input stream. Fail at end of file.

%   A token is one of:
%       a reserved symbol  (: < > ( ) = == . ? " ?? # .> .. )
%       a node symbol  (starts with a capital letter, or is declared)
%       an atom symbol (starts with other than a capital letter)
%       a quoted item  (arbitrary sequence of chars surrounded by single
%                       quotes '...' - will be an atom unless declared a node)
%       a variable     (starts with $)
%       a foreign term,(arbitrary sequence of chars surrounded by backquotes
%                       `...` - will be an atom)
%
%   Node, atom and variable symbols are delimited by whitespace or
%   reserved symbol characters, but otherwise may contain anything.
%   Quoted items may contain anything (including newlines). Foreign
%   terms are passed as a list of characters to user-definable
%   dc_foreign, which can return an arbitrary prolog term to be treated
%   as an atom.
%
%   Atoms, nodes and variables are returned as instances of atom/1,
%   node/1, or dvar/1, with the actual symbol as the argument. Reserved
%   symbols are returned simply as themselves (as words).
%
%   Whitespace and control chars are ignored except in quoted things.
%   Comments are introduced by % and continue to the end of the line
%   Characters preceded by backslash lose any special meaning (as
%   delimiter, reserved symbol etc.) they might otherwise have.


datr_token(_,C,_) :-                % end of file
    datr_eofchar(C),!,
    fail.

datr_token(T,C,NC) :-               % skip whitespace
    datr_whitechar(C), !,
    db_get0(IC),
    datr_token(T,IC,NC).

datr_token(T,C,NC) :-
    datr_commentchar(C), !,         % comment
    datr_endcommentchars(EC),
    datr_readcharsto(EC,Chrs,IC),   % read and discard comment
    datr_token(T,IC,NC).            % read another token

datr_token(T,C,NC) :-
    datr_symchar(C),!,              % reserved symbol
    datr_readsym(S,C,NC),
    db_name(T,S).

datr_token(T,C,NC) :-
    datr_quotechar(C),!,            % quoted item
    datr_endquotechars(EC),
    datr_readcharsto(EC,Chrs,NC),   % read to quote closer
    db_name(I,Chrs),                % convert to an atom
    datr_itemtype(T,I,no).          % decide type - no default strategy

datr_token(atom(T),C,NC) :-
    datr_foreignchar(C),!,          % foreign atom
    datr_endforeignchars(EC),
    datr_readcharsto(EC,Chrs,NC),
    (  dc_foreign(Chrs,T);          % pass chars to foreign handler
       db_name(N,Chrs),
       datr_error(N,'bad foreign atom')
    ).

datr_token(T,C,NC) :-
    datr_readitem(IL,C,NC),!,       % other (node or atom)
    db_name(I,IL),
    datr_itemtype(T,I,IL).          % decide type using default strategy


%   read reserved symbol - only one and two char cases handled

datr_readsym(S,C,NC) :-
    datr_symchar([C,_]),!,          % might be two char symbol
    db_get0(IC),
    datr_readsym2(C,IC,NC,S).
datr_readsym([C],C,NC) :- !,        % definitely one char
    db_get0(NC).

datr_readsym2(46, W, W, "dot") :-
    % rewrite a period followed by whitespace (ie end-of-sentence) as 'dot'
    (datr_whitechar(W); datr_eofchar(W)), !.
datr_readsym2(C,C2,NC,[C,C2]) :-
    datr_symchar([C, C2]), !, db_get0(NC).
datr_readsym2(C,NC,NC,[C]) :- !.


%   read any other item

datr_readitem([],C,C) :-
    (  datr_whitechar(C);           % stop at delimiters
       datr_symchar(C);
       datr_commentchar(C)
),!.
datr_readitem([EC|L],C,NC) :-
    datr_escapechar(C),!,
    db_get0(EC1),                    % read escaped character
    datr_escmap(EC1,EC),
    db_get0(IC),
    datr_readitem(L,IC,NC).         % get some more
datr_readitem([C|L],C,NC) :- !,     % otherwise read more chars
    db_get0(IC),
    datr_readitem(L,IC,NC).


%   read characters up to one of specified terminators

datr_readcharsto(Term,Chrs,NC) :- !,
    db_get0(C),
    datr_rct(Term,Chrs,C,NC).

datr_rct(Term,[EC|T],C,NC) :-
    datr_escapechar(C),!,
    db_get0(EC1),
    datr_escmap(EC1,EC),
    db_get0(IC),
    datr_rct(Term,T,IC,NC).
datr_rct(Term,[],C,NC) :-
    datr_member(C,Term),!,
    db_get0(NC).
datr_rct(Term,_,C,_) :-
    datr_eofchar(C),!,
    db_name(T,Term),
    datr_append("reading to ", Term, S),
    db_name(SName, S),
    datr_error(SName, 'unexpected end of file').
datr_rct(Term,[C|T],C,NC) :- !,
    db_get0(IC),
    datr_rct(Term,T,IC,NC).


%   determine item type (node or atom or variable)
%   nodes and atoms can be explicitly declared, otherwise the default
%   strategy is to select on the basis of the first char of the token.
%   This can be disabled (forcing anything not declared as node to be
%   atom), by setting arg3 to a non-list (eg 'no')

datr_itemtype(Term,I,Chars) :-       % declared item
    datr_declared_itemtype(Type,I,Chars), !,
    db_goal([Type, I], Term).
datr_itemtype(node(I),I,[C|_]) :-   % default node starts with a 'nodechar'
    datr_nodechar(C),!.
datr_itemtype(dvar(I),I,[C|_]) :-   % DATR variable
    datr_varchar(C),!.
datr_itemtype(atom(I),I,_) :- !.    % anything else is an atom

%   first clause allows a custom version of this predicate, to support
%   non-standard strategies, or more efficient native implementations
datr_declared_itemtype(Type,I,Chars) :-
    dc_declared_itemtype(I, Chars, Type), !.
%   second uses standard built-in mechanism
datr_declared_itemtype(Type,I,_Chars) :-
    datr_declared_item(I,Type), !.

%   Basic character types:

% end of file characters - system specific
datr_eofchar(X) :- !, db_eofchar(X).

% whitespace characters
datr_whitechar(C) :- C =< 32, !.
datr_whitechar(65279). % unicode byte order flag - notepad sometimes sticks these on the front of a file

% comment characters
datr_commentchar(37).               % %
datr_endcommentchars([10,13,31]).   % LF, CR - 31 is for OpenProlog....

% symbols
datr_symchar(58) :- !.   % :
datr_symchar(34) :- !.   % "
datr_symchar(46) :- !.   % .
datr_symchar(61) :- !.   % =
datr_symchar(60) :- !.   % <
datr_symchar(62) :- !.   % >
%datr_symchar(40) :- !.   % (   % removed () as sym chars RE 19/04/02
%datr_symchar(41) :- !.   % )
datr_symchar(63) :- !.   % ?
datr_symchar(35) :- !.   % #
datr_symchar([61,61]) :- !.  % ==
datr_symchar([63,63]) :- !.  % ??
datr_symchar([46,62]) :- !.  % .>
datr_symchar([46,46]) :- !. % ..

% quoted atom characters
datr_quotechar(39).            % '
datr_endquotechars([39]).      % '

% foreign atom characters
datr_foreignchar(96).          % `
datr_endforeignchars([96]).    % `

% escape char
datr_escapechar(92).    % backslash

datr_escmap(116, 9).    % \t = tab
datr_escmap(110, 10).   % \n = newline
datr_escmap(X,X).

% default node introducer characters
datr_nodechar(C) :- !, C >= 65, C =< 90. % captial letters

% variable introducer characters
datr_varchar(36).   % $

% The next line is the Revision Control System Id: do not delete it.
% $Id: token.pl 1.2 1997/11/23 21:03:34 rpe Exp $
