% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            builtin/poplog.pl                                        %
% Purpose:         POPLOG Prolog built-in predicates used by DATR system    %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1994.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   This file contains definitions for built-in predicates as used by
%   POPLOG prolog. Copy this file to builtin.pl in the DATR directory.


db_asserta(X) :- asserta(X).        % assert X before other clauses
db_assertz(X) :- assertz(X).        % assert X after other clauses
db_retract(X) :- retract(X).        % retract one clause matching X
db_retractall(G) :- retractall(G).  % remove all clauses matching G
db_clause(H,T) :- clause(H,T).      % look up clause H :- T in database

db_see(F) :- see(F).                % select input stream
db_seeing(F) :- seeing(F).          % return current input stream
db_seen :- seen.                    % close input stream
db_tell(F) :- tell(F).              % select output stream
db_telling(F) :- telling(F).        % return current output stream
db_told :- told.                    % close current output stream

db_get0(C) :- get0(C).              % get char from current input
db_put(C) :- put(C).
db_write(X) :- write(X).            % write item to current output
db_writeq(X) :- writeq(X).          % write in re-readable format
db_nl :- nl.                        % write a newline

db_name(N, L) :-                    % poplog name can do +ve integers but
                                    % we need to do -ve ones too...
    nonvar(L), L = [45|L2], name(N2, L2), integer(N2),!,
    N is 0 - N2.
db_name(N,L) :- name(N,L).          % N is word with list of chars L

db_goal(L,G) :- G =.. L.            % G is goal built from list L
db_call(G) :- call(G).              % call term G as a goal
db_plantcall(L,(G =.. L, call(G))). % return code to build and call list L

db_abort :- abort.

:- prolog_language(pop11).

vars datr_batch = false;
define:prolog dbl_halt_if_batch/0(contn);
    lvars contn;
    if datr_batch then
        identfn -> popexit;
        false -> pop_exit_ok;
        sysexit();
    else
        chain(contn);
    endif;
enddefine;

:- prolog_language(prolog).

dc_warn(I,M) :- datr_do_warn(I,M), dbl_halt_if_batch.
dc_error(I,M) :- datr_do_error(I,M), dbl_halt_if_batch, db_abort.

db_var(V) :- var(V).                % V is an uninstantiated variable
db_nonvar(V) :- nonvar(V).          % V is not an uninstantiated variable
db_atomic(A) :- atomic(A).          % A is atomic (word or number etc.)
db_not(G) :- not(G).                % goal G cannot be satisfied

db_eofchar(26).                     % character signalling end of file

db_reconsult(X) :- reconsult(X).

db_need_dynamics.                   % use dynamic predicate declarations


% handle native directive
db_native([load, File]) :-  !,  % file loader that is language sensitive
    prolog_eval(loadcompiler(word_string(File))).
db_native([initialise]) :- !,     % setup main system (read init files etc)
    % don't want to call syssetup here cos of risk of recursive calls
    % so we just call the setup procedure (1280 is 5<<8 ie SS_INITCOMP)
    prolog_eval(sys_subsystems_init(1280)).
db_native([memory, Level]) :- !,   % set memory limit
    dbl_native_memlim(Level).
db_native([system]) :- !,          % compile as system predicates
    prolog_syspredicates(on).
db_native([batch]) :-
    prolog_setq(datr_batch,true).
db_native(L) :-
    datr_warn(L,'#native directive failed').


:- prolog_language(pop11).

    uses int_parameters

    define:prolog dbl_native_memlim/1(limit, contn);
        lvars limit, contn;
        prolog_full_deref(limit) -> limit;
        if limit == "max" then
            pop_max_int ->> popmemlim -> pop_callstack_lim;
            ;;; pushing up pop_prolog_lim this high causes problems so we are more modest
            pop_prolog_lim * 10 -> pop_prolog_lim;
        elseif isinteger(limit) then
            limit ->> popmemlim -> pop_callstack_lim;
        else
            return; ;;; fail
        endif;
        chain(contn);
    enddefine;

:- prolog_language(prolog).

db_see(InFile, U) :-
    db_unicode_encoding(U,U2), !,
    db_see(InFile),
    dbl_set_unicode(in, U2).
db_see(InFile, _Type) :-
    db_see(InFile).

db_tell(InFile, U) :-
    db_unicode_encoding(U,U2), !,
    db_tell(InFile),
    dbl_set_unicode(out, U2).
db_tell(InFile, _Type) :-
    db_tell(InFile).

db_unicode_encoding('utf-8', utf_8).
db_unicode_encoding('utf-16', ucs_2).
db_unicode_encoding('us-ascii', ascii).

:- prolog_language(pop11).

    define:prolog dbl_set_unicode/2(mode,encoding,contn);
        lvars mode, encoding, contn;
        lvars dev, enc;
        lvars input = prolog_full_deref(mode) == "in";
        if input then
            discin_device(cucharin, false) -> dev;
        else
            ;;; can't prevent this from mishapping if it has a problem :-(
            discout_device(cucharout) -> dev;
        endif;
        if dev then
            prolog_full_deref(encoding) -> enc;
            enc /== "ascii" and enc -> device_encoding(dev);
        endif;
        chain(contn);
    enddefine;

define:prolog db_newer/2(F1, F2, contn);
    lvars F1, F2, contn;

    prolog_full_deref(F1) -> F1;
    prolog_full_deref(F2) -> F2;
    if readable(F1) and readable(F2) and sysmodtime(F1) > sysmodtime(F2) then
        chain(contn);
    endif;
enddefine;

:- prolog_language(prolog).


% The next line is the Revision Control System Id: do not delete it.
% $Id: poplog.pl 1.3 1999/03/04 15:36:59 rpe Exp $
