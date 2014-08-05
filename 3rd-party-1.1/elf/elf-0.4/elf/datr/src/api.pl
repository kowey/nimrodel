% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            api.pl   l                                               %
% Purpose:         API interface to DATR compler functionality              %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1997.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Incomplete at present, but at least its a start

% delete session clauses (same as #delete)
datr_api_delete :-
    datr_remove(consult),
    datr_remove(transient).

% reset declarations (same as #reset)
datr_api_reset :-
    (dc_reset; true),
    db_retractall(datr_runtime(_,show(_))),
    db_retractall(datr_runtime(_,hide(_))),
    db_retractall(datr_runtime(_,node(_))).

% full reset - clear out all the compiler state relating to previous compilations
datr_api_full_reset :-
    % what a mess!!
    datr_api_reset,
    db_retractall(datr_runtime(_,filetype(_))),
    datr_api_delete,
    datr_remove(save),
    db_retractall(datr_node_cleared(_)),
    db_retractall(datr_library_loaded(_)).

% declare list of items as node names (same as #node)
datr_api_declare_nodes(List) :-
    datr_declare_items(List,node).

% declare list of items as atoms (same as #atom)
datr_api_declare_atoms(List) :-
    datr_declare_items(List,atom).

% compiel to pl file
datr_api_compile_files(L) :-
    datr_compile_files(L).

% compile and load (uses existing .pl file if its newer than .dtr)
datr_api_load_files(L) :-
    datr_load_files(L,no).

% compile and dump to .dmp file
datr_api_dump_files(L) :-
    datr_dump_files(L).
