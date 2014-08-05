% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            sentence.pl                                              %
% Purpose:         read DATR sentences from input stream                    %
% Author:          Roger Evans                                              %
%                                                                           %
%      Copyright (c) University of Sussex 1992.  All rights reserved.       %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   $Revision: 1.2 $
%   $Author: rpe $
%   $Date: 1995/01/27 15:51:23 $
%   $State: Release $

%   -- datr_sentence(S) -----------------------------------------------------
%
%   This predicate returns a tokenised DATR sentence (a list of tokens,
%   delimited by a terminator token) from the current input stream.
%   If the input stream is exhausted, it will fail.

datr_sentence(S,Type) :- !,
    db_seeing(Tag),
    (db_retract(datr_lastchar(C, Tag)); C = 32),!,   % pick up lookahead or space
    (   Type = rtf, !,
        datr_rtf_sentence2(S,C,NC)                   % read sentence
        ;
        datr_sentence2(S,C,NC)
    ), !,
    db_asserta(datr_lastchar(NC, Tag)),              % save lookahead char
    !, db_not(S = ['#', atom(eof), dot]).            % fail if we saw #eof.

datr_sentence2([Token|Tokens],C,NC) :- !,
    datr_token(Token,C,IC),                     % get one token
    datr_sentence3(Token,Tokens,IC,NC).         % get more (if necesssary)

datr_sentence3(Token,[],C,C) :-
    datr_term_token(Token),!.                   % finish at terminator token
datr_sentence3(_,Tokens,C,NC) :- !,
    datr_sentence2(Tokens,C,NC).                % go for some more

datr_sentence_from_tokens([H|Rest], Rest, [H]) :- datr_term_token(H), !.
datr_sentence_from_tokens([H|T], Rest, [H|T2]) :-
	datr_sentence_from_tokens(T, Rest, T2).

%  valid sentence terminators

datr_term_token(dot) :- !.
datr_term_token('?') :- !.


%   -- datr_reset_sentence --------------------------------------------------
%
%   This predicate resets the global state of the sentence read
%   routines.  It should be called whenever a new input stream
%   is opened, before reading any sentences.

datr_reset_sentence :-
    db_retractall(datr_lastchar(X)).

% (dynamic) predicate to remember last char read

:- db_asserta((datr_lastchar(_,_) :- fail)).
