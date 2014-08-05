% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            declare.pl                                               %
% Purpose:         declaration handing routines                             %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1994.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   -- datr_declare(Decl,Args,Clauses,Id,Tag) -------------------------------
%
%   return Clauses and clause id Id for an instance of declaration type Decl
%   with arguments Args.

%   declarations which side-effect compilation context
datr_declare(delete,[],[],none) :- !,   % delete session clauses
    datr_api_delete.
datr_declare(reset,[],[],none) :- !,    % clear out item decs
    datr_api_reset.
datr_declare(node,L,[],none) :- !,      % node declarations
    datr_api_declare_nodes(L).
datr_declare(atom,L,[],none) :- !,      % atom declarations
    datr_api_declare_atoms(L).
datr_declare(compile,L,[],none) :- !,   % compile files - clear out previous state and reconsult
    datr_compile_files(L).
datr_declare(load,L,[],none) :- !,      % load (reconsult) files
    datr_load_files(L).
datr_declare(dump,L,[],none) :- !,      % compile and dump files
    datr_dump_files(L).
datr_declare(flag,L,[],none) :- !,      % set datr flags
    datr_set_flags(L).
datr_declare(spy,L,[],none) :- !,       % set spypoint
    (spy L).
datr_declare(nospy,L,[],none) :- !,     % clear spypoint
    (nospy L).
datr_declare(native,L,[],none) :- !,    % send to native handler
    db_native(L).
datr_declare(tracemode,L,[],none) :- !, % adjust tracemode
    L = [M|_],
    db_retractall(datr_tracemode(_)),
    db_asserta(datr_tracemode(M)).
% encoding declaration - do nothing, as it will already have been done
% by datr_probe_file
datr_declare(encoding(_E), [], [], none) :- !.


%   declarations which create run-time clauses - use
%   tag in datr_runtime to make reconsult etc. behave well
datr_declare(show,L,CList,show(_)) :- !,
    datr_declare_paths(L,CList).
datr_declare(hide,L,CList,hide(_)) :- !,
    datr_hide_nodes(L,CList).
datr_declare(vars,L,CList,vars(_,_)) :- !, % datr variables
    datr_declare_var(L,CList).
datr_declare(uses,L,[],none) :- !,      % load library nodes
    datr_load_libraries(L).


%   datr node/atom declarations

datr_declare_items([H|T],Type) :- !,
    datr_declare_item(H,Type), !,
    datr_declare_items(T,Type).
datr_declare_items([],Type) :- !.

%   allow user-define handling of item declaration (in conjunction with
%   dc_itemtype - see token.pl)
datr_declare_item(Item, Type) :-
    dc_declare_item(Item, Type), !.
datr_declare_item(Item, Type) :-
    db_asserta(datr_declared_item(Item,Type)),!.

%   (dynamic) predicate for remembering declarations

:- db_asserta((datr_declared_item(_,_) :- fail)).

%   datr node/atom declarations


%   datr variable declarations

datr_declare_var([],[]).
datr_declare_var([range(V,AL)|T],[vars(V,AL)|CT]) :- !,
    db_assertz((datr_variable(V,AL) :- !)), !,
    datr_declare_var(T,CT).

%   (dynamic) predicate for remembering variables

:- db_asserta((datr_variable(_,_) :- fail)).



% loading files
datr_load_files(L) :- 
	(datr_flag(quiet) -> Verbose=no; Verbose=yes),
	datr_load_files(L, Verbose).

datr_load_files([],_V) :- !.
datr_load_files([H|T],Verbose) :- !,
    datr_file_suffix(H,H2,".dtr",no),
    datr_get_load_file(H2, H3, Goal, H),
    (Verbose=yes -> db_write(H3), db_nl; true),
    db_call(Goal),!,
    datr_load_files(T, Verbose).


% look for a .pl file newer than the given file
datr_get_load_file(F1, F2, db_reconsult(F2), _T) :-
    datr_file_suffix(F1, F2, ".pl", yes),
    db_newer(F2,F1), !.
datr_get_load_file(F1, F1, datr_compile(F1, reconsult, T), T).


% compiling files - from .dtr to .pl
datr_compile_files([]) :- !.  % don't reset if no files are given
datr_compile_files([H|T]) :-
    datr_api_full_reset,
    datr_file_suffix(H,H2,".dtr",no),
    datr_file_suffix(H,H3,".pl",yes),
    datr_compile(H2,H3,H), !,
    datr_compile_files(T).

% dumping
datr_dump_files([]) :- !,
    datr_theorem.
datr_dump_files([H|T]) :- !,
    datr_parse_filename(H, NH, P),
    datr_load_files([NH|T]),
    datr_file_suffix(H,H2,".dmp",yes),
    (datr_runtime(H,filetype(Type)); Type=ascii),
    db_tell(H2,Type),
    datr_theorem_show(P),
    db_told.

% setting flags
datr_set_flags([]).
datr_set_flags([H|T]) :-
    datr_is_flag(H),!,
    db_asserta(datr_flag(H)),
    datr_set_flags(T).
datr_set_flags([H|T]) :-
    datr_error(H,'unknown flag').

datr_is_flag('[_]').
datr_is_flag(quiet).

%   (dynamic) predicate for datr flags
:- db_assertz((datr_flag(X) :- fail)).

% loading (prolog) libraries
datr_load_libraries([]) :- !.
datr_load_libraries([H|T]) :- !,
    datr_library_name(H,F),
    datr_load_library(F),
    datr_load_libraries(T).

datr_load_library(F) :- datr_library_loaded(F), !.
datr_load_library(F) :-
	datr_get_load_file(F, _F2, G, F),
    db_call(G),
    db_assertz(datr_library_loaded(F)).

%   (dynamic) predicate for remembering libraries loaded

:- db_asserta((datr_library_loaded(F) :- fail)).

% mapping library node to filename
datr_library_name(N,F) :- dc_library_name(N,F), !.
datr_library_name(N,F) :-       % default if no customisation
    datr_pathname(N,"lib/uses/",F), !.
	

%   build clauses for interesting path declarations

datr_declare_paths([],[]) :- !.
datr_declare_paths([H|T],[show(P,VL)|List]) :- !,
    datr_path_extend(H,P,[],[],VL,yes),
    datr_declare_paths(T,List), !.


%   build clauses to hide uninteresting nodes

datr_hide_nodes([],[]) :- !.
datr_hide_nodes([H|T],[hide(H)|List]) :- !,
    datr_hide_nodes(T,List).


%   (dynamic) predicate for remembering 'undefined' values

:- db_asserta((datr_undefval(X) :- fail)).

:- db_asserta((datr_dump_prefix(''))).
:- db_asserta((datr_dump_action(default))).

% The next line is the Revision Control System Id: do not delete it.
% $Id: declare.pl 1.8 1999/03/04 15:39:13 rpe Exp $
