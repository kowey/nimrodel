
:- compile('$ELFROOT/hunspell/hunspell.pl').

'Hunspell'([dictionary, File], _GN, _GP, [Dict]) :- !,
	hunspell_dictionary(File, Dict).
'Hunspell'([hunspell_dictionary, File], _GN, _GP, [Dict]) :- !,
	hunspell_dictionary(hunspell_dict(File), Dict).
'Hunspell'([misspelled, Word, Dict], _GN, _GP, [Ok]) :- !,
	hunspell_misspelled(Word, Dict, Res),
	( 	Res = @(true) -> Ok = '**true**'; Ok = '**fail**' ).
'Hunspell'([suggestions, Word, Dict], _GN, _GP, L) :- !,
	hunspell_suggestions(Word, Dict, L).
'Hunspell'([lookup, Word, Dict], _GN, _GP, [Ok|L]) :- !,
	hunspell_lookup(Word, Dict, Res, L),
	( 	Res = ok -> Ok = '**true**'; Ok = '**fail**' ).