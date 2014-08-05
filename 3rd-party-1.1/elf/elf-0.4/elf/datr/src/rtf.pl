% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            rtf.pl                                                   %
% Purpose:         DATR rtf extensions                                      %
% Author:          Roger Evans                                              %
% Version:         1.5                                                      %
% Date:            06/06/01                                                 %
%                                                                           %
%      Copyright (c) University of Brighton 2001.  All rights reserved.     %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%

% extended to handle rtf controls

%   -- datr_rtf_token(Token,NextChar_In,NextChar_Out) ---------------------------
%
%   Read a token, given next char of input stream, and returning new
%   next char of input stream. Fail at end of file.

%   A token is one of:
%       a reserved symbol  (: < > ( ) = == . ? " ?? #)
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



datr_rtf_token(_,C,_) :-                % end of file
    datr_eofchar(C),!,
    fail.

datr_rtf_token(T,C,NC) :-               % skip whitespace
    datr_whitechar(C), !,
    datr_rtf_get0(IC),!,
    datr_rtf_token(T,IC,NC).

datr_rtf_token(T,C,NC) :-
    datr_commentchar(C), !,         % comment
    datr_endcommentchars(EC),
    datr_rtf_readcharsto(EC,Chrs,IC,_F),% read and discard comment
    datr_rtf_token(T,IC,NC).            % read another token

datr_rtf_token(T,C,NC) :-
    datr_symchar(C),!,              % reserved symbol
    datr_rtf_readsym(S,C,NC),
    db_name(T,S).

datr_rtf_token(T,C,NC) :-
    datr_quotechar(C),!,            % quoted item
    datr_endquotechars(EC),
    datr_rtf_readcharsto(EC,Chrs,NC,F), % read to quote closer
    datr_rtf_name(I,Chrs,F),                % convert to an atom
    datr_itemtype(T,I,no).          % decide type - no default strategy

datr_rtf_token(atom(T),C,NC) :-
    datr_foreignchar(C),!,          % foreign atom
    datr_endforeignchars(EC),
    datr_rtf_readcharsto(EC,Chrs,NC,F),
    (   dc_foreign(Chrs,T)          % pass chars to foreign handler
        ;
        datr_rtf_name(N,Chrs,F),
        datr_error(N,'bad foreign atom')
    ).

datr_rtf_token(T,C,NC) :-
    datr_rtf_get_current_font(F),
    datr_rtf_readitem(IL,C,NC),!,       % other (node or atom)
    datr_rtf_name(I,IL,F),
    datr_itemtype(T,I,IL).          % decide type using default strategy


datr_rtf_get_current_font(F) :-
    db_seeing(Tag),
    F = _+Tag,
    datr_rtf_current_font(F).

%   read reserved symbol - only one and two char cases handled

datr_rtf_readsym(S,C,NC) :-
    datr_symchar([C,C2]),!,         % might be two char symbol
    datr_rtf_get0(IC),
    datr_rtf_readsym2(C,C2,IC,NC,S).
datr_rtf_readsym([C],C,NC) :- !,        % definitely one char
    datr_rtf_get0(NC).

datr_rtf_readsym2(C,C2,C2,NC,[C,C2]) :- !, datr_rtf_get0(NC).
datr_rtf_readsym2(C,C2,NC,NC,[C]) :- !.


%   read any other item

datr_rtf_readitem([],C,C) :-
    (  datr_whitechar(C);           % stop at delimiters
       datr_symchar(C);
       datr_commentchar(C)
    ),!.
datr_rtf_readitem([EC|L],C,NC) :-
    datr_escapechar(C),!,
    datr_rtf_get0(EC),                    % read escaped character
    datr_rtf_get0(IC),
    datr_rtf_readitem(L,IC,NC).         % get some more
datr_rtf_readitem([C|L],C,NC) :- !,     % otherwise read more chars
    datr_rtf_get0(IC),
    datr_rtf_readitem(L,IC,NC).


%   read characters up to one of specified terminators

datr_rtf_readcharsto(Term,Chrs,NC,F) :- !,
    datr_rtf_get0(C),
    % get font *after* reading first char, in case quote is in different font
    datr_rtf_get_current_font(F),
    datr_rtf_rct(Term,Chrs,C,NC).

datr_rtf_rct(Term,[EC|T],C,NC) :-
    datr_escapechar(C),!,
    datr_rtf_get0(EC),
    datr_rtf_get0(IC),
    datr_rtf_rct(Term,T,IC,NC).
datr_rtf_rct(Term,[],C,NC) :-
    datr_member(C,Term),!,
    datr_rtf_get0(NC).
datr_rtf_rct(Term,_,C,_) :-
    datr_eofchar(C),!,
    db_name(T,Term),
    datr_append("reading to ", Term, S),
    db_name(SName, S),
    datr_error(SName, 'unexpected end of file').
datr_rtf_rct(Term,[C|T],C,NC) :- !,
    datr_rtf_get0(IC),
    datr_rtf_rct(Term,T,IC,NC).




% -- rtf support --

datr_rtfchar(123).     % {
datr_rtfchar(125).     % }
datr_rtfchar(92).      % backslash

datr_rtf_get0(C2) :-
    db_get0(C1),
    datr_rtf_control(C1,C2).

datr_rtf_control(123,NC) :-  !,   % { - skip it
    datr_rtf_get0(NC).
datr_rtf_control(125,NC) :-  !,   % } - skip it
    datr_rtf_get0(NC).
datr_rtf_control(92,NC) :-  !,    % backslash
    datr_rtf_read_control(Control, IC, yes),
    datr_rtf_control(Control, IC, MC),
    datr_rtf_control(MC, NC).
datr_rtf_control(escape(C),C) :- !.
datr_rtf_control(C,C).

datr_rtf_read_control(Control, NC, First) :-
    db_get0(C),
    datr_rtf_read_control2(C, Control, NC, First).

datr_rtf_read_control2(C, [], C, _First) :-  % end of file - return (possibly null) command
    datr_eofchar(C), !.
datr_rtf_read_control2(C, escape, C, yes) :-   % end of control name - must be escaped
    datr_rtfchar(C), !.
datr_rtf_read_control2(C, [], C, no) :-   % end of control name - finished
    (datr_rtfchar(C); datr_whitechar(C)), !.
datr_rtf_read_control2(39, escape, C, yes) :-  !, % hex char repn
    db_get0(C1), datr_rtf_hex_map(C1, H1),
    db_get0(C2), datr_rtf_hex_map(C2, H2),
    C is H1*16+H2.
% special case for controls of the form \fN (N a digit)
% don't look for any more chars (to avoid control name runaway if followed by a ')
% follow them with a ' without the control name runni
datr_rtf_read_control2(102, [102,C|Tail], NC, _First) :- !, % possible font control
    db_get0(C),
    (   C > 47, C < 58, Tail = [], db_get0(NC)     % font control
        ;
        datr_rtf_read_control(Tail, NC, no)        % not font control - read more
    ), !.
datr_rtf_read_control2(C, [C|Tail], NC, _First) :-
    datr_rtf_read_control(Tail, NC, no).

:- dynamic datr_rtf_font_table/2.
:- dynamic datr_rtf_default_font/2.
:- dynamic datr_rtf_current_font/1.

datr_rtf_control(escape, NC, escape(NC)) :-  !.    % escaped rtf or hex char
datr_rtf_control("fonttbl", IC, NC) :- !,    % read a font table (and assert clauses for it)
    db_seeing(Tag),
    db_retractall(datr_rtf_font_table(_+Tag,_)),
    db_retractall(datr_rtf_default_font(_+Tag,_)),
    db_retractall(datr_rtf_current_font(_+Tag)),
    datr_rtf_read_font_table(IC, NC, Tag).
datr_rtf_control(Control, NC, NC) :-
    Control = [102, N | _Tail], N > 47, N < 58,   % font selection
    db_seeing(Tag),
    db_name(ControlName, Control),
    datr_rtf_font_table(ControlName+Tag, FontName), !,
    db_retractall(datr_rtf_current_font(_+Tag)),
    db_asserta(datr_rtf_current_font(ControlName+Tag)),
    (   datr_rtf_default_font(_+Tag,_)
        ;
        db_asserta(datr_rtf_default_font(ControlName+Tag,FontName))
    ),!.
datr_rtf_control(_Control, NC, NC).       % ignore any other controls

datr_rtf_read_font_table(123, NC, Tag) :- !,      % '{', so there's another entry to read
    db_get0(C),
    datr_rtf_read_font_entry(C, MC, Tag),
    datr_rtf_read_font_table(MC,NC, Tag).
datr_rtf_read_font_table(C, C, _Tag).             % not '{' - we've finished.

datr_rtf_read_font_entry(92, NC, Tag) :- !,      % next char is backslash as expected
    datr_rtf_read_control(Control, C1, yes),
    datr_rtf_rct2(32, _S1, C1, C2),
    datr_rtf_rct2(59, S2, C2, C3),
    datr_rtf_rct2(125, S3, C3, NC),
    db_name(ControlName, Control),
    db_asserta(datr_rtf_font_table(ControlName+Tag, S2)).
datr_rtf_read_font_entry(C, C, _Tag).


datr_rtf_rct2(C,[],C,NC) :- !,
    db_get0(NC).
datr_rtf_rct2(Term,_,C,_) :-
    datr_eofchar(C),!,
    db_name(T,Term),
    datr_append("reading to ", Term, S),
    db_name(SName, S),
    datr_error(SName, 'unexpected end of file').
datr_rtf_rct2(Term,[C|T],C,NC) :- !,
    db_get0(IC),
    datr_rtf_rct2(Term,T,IC,NC).

datr_rtf_hex_map(C1, C2) :- C1 > 47, C1 < 58, !, C2=C1-48.
datr_rtf_hex_map(C1, C2) :- C1 > 96, C1 < 103, !, C2=C1-87.


datr_rtf_name(I, Chars, FSpec) :-
    FSpec=F+Tag,
    datr_rtf_default_font(DF+Tag,DFN),
    not(DF=F),      % not exactly the same font as the default
    datr_rtf_font_table(FSpec, FN),
    not(FN=DFN),    % not same font name as the default
    !,
    % build '<font face="FN">Chars</font>'
    datr_append(Chars, "</font>", I1),
    datr_append("\">",I1,I2),
    datr_append(FN,I2,I3),
    datr_append("<font face=\"",I3,I4),
    db_name(I, I4).

datr_rtf_name(I, Chars, _F) :-
    db_name(I, Chars).


%   reading from input

%   called from datr_sentence in sentence.pl

datr_rtf_sentence2([Token|Tokens],C,NC) :- !,
    datr_rtf_token(Token,C,IC),                     % get one token
    datr_rtf_sentence3(Token,Tokens,IC,NC).         % get more (if necesssary)

datr_rtf_sentence3(Token,[],C,C) :-
    datr_term_token(Token),!.                   % finish at terminator token
datr_rtf_sentence3(_,Tokens,C,NC) :- !,
    datr_rtf_sentence2(Tokens,C,NC).                % go for some more
