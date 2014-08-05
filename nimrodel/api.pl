%   File:       api.pl
%   Purpose:    prolog api for elf application
%   Author:     Roger Evans
%   Version:    1.0
%   Date:       21/12/2013
%
%   (c) Copyright 2013, University of Brighton


% application api from prolog
nimrodel(Model, Title, String) :-
	nimrodel(['-model', Model, '-title', Title, String]).
nimrodel(Model, String) :-
	nimrodel(['-model', Model, String]).
nimrodel(X) :- atom(X), !,
	nimrodel([X]).
nimrodel(X) :- 
    datr_query('nimrodel.MAIN', [arglist | X], _V).
	
nimrodel_query(Index, Path) :-
	datr_theorem('nimrodel.STRING-QUERY', [Index | Path]).
	
