:- use_module(library(jpl)).

:- assertz((user:file_search_path(hunspell_dict, X) :- expand_file_name('$ELFROOT/hunspell/dictionaries',[X]))).

hunspell_getdictionary(File,dict(Dict)) :-
	jpl_call('dk.dren.hunspell.Hunspell', getInstance, [], I),
	absolute_file_name(File,Name,[access(exist)]),
	jpl_call(I, getDictionary, [Name], Dict).
	
hunspell_dictionary(Dict, Dict) :- functor(Dict, dict, 1), !.
hunspell_dictionary(File, Dict) :- 
	hunspell_getdictionary(File, Dict).
	
hunspell_misspelled(Word, File, Result) :- 
	hunspell_dictionary(File, Dict),
	jpl_call(Dict, misspelled, [Word], Result).

hunspell_misspelled(Word, File) :-
	hunspell_misspelled(Word, File, Result), !,
	Result = @(true).

hunspell_suggestions(Word, File, Suggestions) :- 
	hunspell_dictionary(File, Dict),
	jpl_call(Dict, suggest, [Word], Result),
	jpl_call(Result, toArray, [], ResultArray),
	jpl_array_to_list(ResultArray, Suggestions).

hunspell_lookup(Word, File, Ok, Suggestions) :- 
	hunspell_dictionary(File, Dict),
	hunspell_misspelled(Word, Dict, Result),
	( Result = @(true) -> Ok = ok; Ok = no ),
	hunspell_suggestions(Word, Dict, Suggestions).
	
	