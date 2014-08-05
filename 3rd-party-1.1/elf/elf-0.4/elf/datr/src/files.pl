
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            files.pl                                                 %
% Purpose:         DATR file handling predicates                            %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1999.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

datr_pathname(File, Type, Filename) :-
    db_atomic(File), !,
    db_name(File, FName),
    datr_append(FName, ".dtr", FName2),
    datr_pathname(FName2, Type, Filename), !.
datr_pathname(File, Type, Filename) :-
    datr_directory(Dir),
    datr_append(Type, File, F1),
    datr_append(Dir, F1, Filename1),
    db_name(Filename, Filename1),!.


% datr_filename(+Prefix,+Suffix,-Filename)
%
% concatenate Prefix and Suffix to form Filename
% except (user, dtr) ==> user (not user.dtr)

datr_filename(user,dtr,user).

datr_filename(Prefix,Suffix,FileName) :-
    db_name(Prefix,PreList),
    db_name(Suffix,SufList),
    datr_append(PreList,[46|SufList],FileChars),
    db_name(FileName,FileChars).

% datr_file_suffix(+IN,-OUT,+Suffix,+Force)
%
% OUT is IN but with suffix Suffix appended if IN has no filetype.
% If IN has a filetype, it is replaced with Suffix if Force is 'yes'
% otherwise it is left alone (ie OUT=IN)
% Suffix should start with . eg '.dtr'
datr_file_suffix(A,B,Suff,yes) :- !,
    db_name(A,AN),
	datr_get_suffix(AN, ANPref, ANSuff, InSuffix),
	(InSuffix = yes -> ANname=AN ; ANname=ANPref),
    datr_append(ANname,Suff,BN),
    db_name(B, BN).
datr_file_suffix(A,B,Suff,no) :- !,
    db_name(A,AN),
	datr_get_suffix(AN, ANPref, ANSuff, InSuffix),
	(	InSuffix = yes 
	->  datr_append(AN,Suff,BN),
        db_name(B, BN)
	;   B=A
	).

	
datr_get_suffix([], [], [], yes) :- !.
datr_get_suffix([C|List], Prefix, Suffix, InSuffix) :-
	datr_get_suffix(List, Prefix2, Suffix2, InSuffix2),
	(	InSuffix2 = no
	->	Prefix = [C|Prefix2], Suffix = Suffix2, InSuffix = no
	;	Prefix = Prefix2, Suffix = [C|Suffix2], (C=46 -> InSuffix = no; InSuffix = yes)
	).

datr_parse_filename(In, Out, Path) :-
    db_name(In, InChars),
    db_parse_filename(1, InChars, OutChars, PathChars),
    db_name(Out, OutChars),
    (PathChars = [] -> Path = no; db_name(Path2, PathChars), Path = [dump, Path2]),!.

db_parse_filename(_,[],[],[]).
db_parse_filename(_, [46|IT], [46|IT], []) :- !.
db_parse_filename(1, [45|IT], ST, PT) :- !,
    db_parse_filename(2, IT, ST, PT).
db_parse_filename(1, [H|IT], [H|OT], PT) :- !,
    db_parse_filename(1, IT, OT, PT).
db_parse_filename(2, [H|IT], OT, [H|PT]) :- !,
    db_parse_filename(2, IT, OT, PT).

datr_probe_file(user, 'us-ascii') :- !.
datr_probe_file(inchan, 'us-ascii') :- !.
datr_probe_file(File, Type) :-
    atom(File),!,
    db_probe_get_chars(File, Chars),
    db_probe_get_type(Chars, Type), !.
datr_probe_file(_File, 'us-ascii') :- !.

db_probe_get_chars(File, Chars) :-
    db_see(File),
    db_get0(C),
    db_get_more(C, Chars, 7),
    db_seen.

db_get_more(C,[],N) :- (datr_eofchar(C); N=0), !.
db_get_more(C, [C|T], N) :-
    db_get0(C2),
    N2 is N-1,
    db_get_more(C2, T, N2).


db_probe_get_type([254,255|_], 'utf-16').               % BOM for utf-16
db_probe_get_type([255,254|_], 'utf-16').               % BOM for utf-16
db_probe_get_type([239,187,191|_], 'utf-8').            % BOM for utf-8
db_probe_get_type([35,117,116,102,45,56,46|_], 'utf-8').  % '#utf-8.'
db_probe_get_type([123,92,114,116,102|_], 'rtf').       % '\{rtf'
db_probe_get_type(_, 'us-ascii').

% The next line is the Revision Control System Id: do not delete it.
% $Id: files.pl 1.1 1999/03/04 15:39:13 rpe Exp $
