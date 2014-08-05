% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            lib/simple_ui.pl                                         %
% Purpose:         simple user support utilities                            %
% Author:          Gerald Gazdar                                            %
%                                                                           %
%      Copyright (c) University of Sussex 1998.  All rights reserved.       %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

simple_ui_banner :-
    db_nl,
    db_write('DATR user interface support library loaded.'), db_nl,
    db_write('Type \'datr_help.\' to Prolog prompt for more details.'), db_nl, db_nl.

datr_help :-
    db_nl,
    db_write('COMPILATION AND THEOREM DUMPS'), db_nl,
    db_write('  | ?- dc file.  compile file.dtr'), db_nl,
    db_write('  | ?- dc(file). compile file.dtr'), db_nl,
    db_write('  | ?- dc.       recompile the last file compiled'), db_nl,
    db_write('  | ?- du file.  compile file.dtr and dump theorems to file.dmp'), db_nl,
    db_write('  | ?- du(file). compile file.dtr and dump theorems to file.dmp'), db_nl,
    db_write('  | ?- du.       dump [-hide,+show] theorems from current file'), db_nl,
    db_write('SDATR QUERY MODE'), db_nl,
    db_write('  | ?- dq.       switch into SDATR query mode'), db_nl,
    db_write('  |:             the SDATR query mode prompt'), db_nl,
    db_write('  |: Node ?      exhibit the [+show] theorems for Node'), db_nl,
    db_write('  |: Node:Path ? exhibit the Node:Path theorem'), db_nl,
    db_write('  |: ?           exhibit all [-hide,+show] theorems'), db_nl,
    db_write('  |: #eof.       exit query mode'), db_nl,
    db_write('GETTING HELP AND GETTING OUT'), db_nl,
    db_write('  | ?- datr_help.     display this help listing'), db_nl,
    db_write('  | ?- halt.     leave SDATR and return to operating system'), db_nl,
    db_write('DECLARATIONS, ETC.'), db_nl,
    db_write('  # vars $Var: Atom0 .. AtomN. '), db_nl,
    db_write('  # vars $Var.                here $Var will range over any atom'), db_nl,
    db_write('  # show Path0 .. PathN.      the paths you want to see in dumps'), db_nl,
    db_write('  # hide Node0 .. NodeN.      the nodes you want to omit from dumps'), db_nl,
    db_write('  # atom Atom0 .. AtomN.      useful for uppercase atoms, etc.'), db_nl,
    db_write('  # node Node0 .. NodeN.      useful for lowercase nodes, etc.'), db_nl,
    db_write('  # uses Node0 .. NodeN.      load external node definitions'), db_nl,
    db_write('  # spy  Node0 .. NodeN.      for (verbose) debugging'), db_nl,
    db_write('  # load '), db_put(39), db_write('file'), db_put(39), db_write('.          load file.dtr'), db_nl,
    db_write('  # compile '), db_put(39), db_write('file'), db_put(39), db_write('.       compile file.dtr to file.pl'), db_nl,
    db_write('  # dump '), db_put(39), db_write('file'), db_put(39), db_write('.          compile file.dtr and dump to file.dmp'), db_nl.

dq :-
    db_write('Type \'#eof.\' to exit query mode.'), db_nl,
    datr_compile(user).

%   given the prefix of a filename, construct the full name by adding the
%   .dtr suffix and compile the file thus named.

dc(Prefix) :-
    datr_store(Prefix,prefix),
    dc_compile(Prefix).

%   version of dc/1 that uses stored Prefix

(dc) :-
    datr_stored(Prefix,prefix),
    dc_compile(Prefix).

dc_compile(Prefix) :-
    datr_api_full_reset,
    datr_api_load_files([Prefix]).

%   given the prefix of a filename, construct the full name by adding the
%   .dtr suffix, compile the file thus named, and do a theorem dump, putting
%   the results in the corresponding .dmp file.

du(Prefix) :-
    datr_store(Prefix,prefix),
    datr_dump(Prefix).

%   version of du/1 that uses stored Prefix

(du) :-
    datr_stored(Prefix,prefix),
    datr_dump(Prefix).

datr_dump(Prefix) :-
    datr_api_dump_files([Prefix]).

:- current_op(Op, _, spy), op(Op,fx,[dc,du]).

datr_store(Prefix,Type) :-
    db_retractall(datr_stored(_,Type)),
    db_asserta(datr_stored(Prefix,Type)).
