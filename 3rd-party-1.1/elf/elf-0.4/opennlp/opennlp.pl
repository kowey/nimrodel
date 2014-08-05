
:- use_module(library(jpl)).

:- assertz((user:file_search_path(opennlp_model, X) :- expand_file_name('$ELFROOT/opennlp/models',[X]))).

:- dynamic(opennlp_instance/2).

opennlp(Class, Method, In, Out) :- opennlp_module(In, Out, Class, Method).
opennlp(Class, In, Out) :- opennlp(Class, _Method, In, Out). /* get the first method if none specified*/

opennlp_reset :- retractall(opennlp_instance(_,_)).

opennlp_module(In, Out, Module, Method) :-
	opennlp_module(Module, M), 
	M = opennlp_module(_Name, _ModelClass, _ModelFile, _AppClass, Methods),
	member(method(Method, Arg, Res), Methods), !,
	opennlp_app(M, App),
	opennlp_args(Arg, In, In2),
	jpl_call(App, Method, In2, Out2),
	opennlp_result(Res, Out2, Out).

	
opennlp_app(opennlp_module(Name, _ModelClass, _ModelFile, _AppClass, _Methods), App) :-
	opennlp_instance(Name, App), !.
opennlp_app(opennlp_module(Name, ModelClass, ModelFile, AppClass, _Methods), App) :-
	absolute_file_name(ModelFile, ModelFile2, [extensions([bin, '']), access(exist)]),
	opennlp_model(ModelClass, ModelFile2, Model),
	jpl_new(AppClass, [Model], App),
	asserta(opennlp_instance(Name, App)).
	
opennlp_model(Class, ModelFile, Model) :-
	jpl_new('java.io.FileInputStream', [ModelFile], MF),
	jpl_new(Class, [MF], Model),
	jpl_call(MF, close, [], _).
	
opennlp_args(void, In, []) :- !, In = [].
opennlp_args(array, In, [In2]) :- !, jpl_datums_to_array(In, In2).
opennlp_args(string, [In], [In]).
opennlp_args(string, In, [In]) :- !.
opennlp_args(list(_Type), [], []) :- !.
opennlp_args(ListType, [H|T], [H2|T2]) :- ListType = list(Type), !, 
	opennlp_args(Type, H, [H2]), opennlp_args(list(Type), T, T2).
opennlp_args(_Arg, In, [In]).

opennlp_result(void, Out, Out) :- !.
opennlp_result(span, Out2, Out) :- !,
	opennlp_getSpan(Out2, Out, _In).
opennlp_result(ListType, Out2, Out) :- ListType = list(Type), !, 
	jpl_array_to_list(Out2, Out3),
	opennlp_resultlist(Type, Out3, Out).
opennlp_result(_Res, Out2, Out) :- 
	jpl_array_to_list(Out2, Out).
	
opennlp_resultlist(_Type, [], []).
opennlp_resultlist(Type, [H|T], [NH|NT]) :-
	opennlp_result(Type, H, NH),
	opennlp_resultlist(Type, T, NT).
	
% return/instantiate spans as prolog objects
opennlp_getSpans([], [], _In).
opennlp_getSpans([JplSpan|Rest], [Span|Rest2], In) :-
	opennlp_getSpan(JplSpan, Span, In),
	opennlp_getSpans(Rest, Rest2, In).

opennlp_getSpan(JplSpan, Span, In) :-
	Span=span(T, S, E, Text, JplSpan), 
	(var(T) -> jpl_call(JplSpan, getType, [], T1), opennlp_mapval(T1,T);true),
	(var(S) -> jpl_call(JplSpan, getStart, [], S1), opennlp_mapval(S1,S);true),
	(var(E) -> jpl_call(JplSpan, getEnd, [], E1), opennlp_mapval(E1,E);true),
	opennlp_getSpanString(Span, Text, In).
	
% extract text strings from spans
opennlp_getSpanStrings([], [], _In).
opennlp_getSpanStrings([H|T], [NH|NT], In) :-
	opennlp_getSpanString(H,NH, In),
	opennlp_getSpanStrings(T,NT, In).
	
opennlp_getSpanString(span(_T,_S,_E,Text,JplSpan), Text, In) :-
	((nonvar(In), var(Text)) -> 
		jpl_call(JplSpan, getCoveredText, [In], Text)
	 ;true).

opennlp_absoluteSpan(span(T,S,E,Text,_J), span(_T,S2,_E,_Text,_J2), Span) :-
	S3 is S + S2,
	E3 is E + S2,
	opennlp_newSpan(T,S3,E3,Text,Span).

opennlp_newSpan(T,S,E,Text,span(T,S,E,Text,J)) :- 
	jpl_new('opennlp.tools.util.Span', [S, E, T], J).



% recover underlying string spans from list of spans and list of tokens
opennlp_tokenSpansToStringSpans([], _TokenStringSpans, []).
opennlp_tokenSpansToStringSpans([H|T], TokenStringSpans, [NH|NT]) :-
	opennlp_tokenSpanToStringSpan(H,TokenStringSpans,NH),
	opennlp_tokenSpansToStringSpans(T, TokenStringSpans, NT).
	
% recover underlying string span from a token span and a list of tokens
opennlp_tokenSpanToStringSpan(span(T, S, E, _Text1, _JplSpan), TokenStringSpans, span(T, NS, NE, _Text2, NJplSpan)) :-
	opennlp_skipto(S, 0, TokenStringSpans, StartSpans),
	StartSpans = [StartSpan|_], arg(2,StartSpan, NS),
	E2 is E-1,
	opennlp_skipto(E2, S, StartSpans, [EndSpan|_]), arg(3,EndSpan, NE),
	jpl_new('opennlp.tools.util.Span', [NS, NE, T], NJplSpan).
	
opennlp_skipto(S,S,T,T) :- !.
opennlp_skipto(S,OS,[_Span|T],NT) :-
	NS is OS+1,
	opennlp_skipto(S, NS, T, NT).	
	
opennlp_mapval(@(null), null) :- !.
opennlp_mapval(V, V).
		
	
	
	
% opennlp module definitions
opennlp_module(sentenceDetector, opennlp_module(
	sentenceDetector, 
	'opennlp.tools.sentdetect.SentenceModel', 
	opennlp_model('en-sent.bin'),
	'opennlp.tools.sentdetect.SentenceDetectorME',
	[method(sentDetect, string, array), method(sentPosDetect, string, list(span))]
)).
opennlp_module(tokenizer, opennlp_module(
	tokenizer, 
	'opennlp.tools.tokenize.TokenizerModel', 
	opennlp_model('en-token.bin'),
	'opennlp.tools.tokenize.TokenizerME',
	[method(tokenize, string, array), method(tokenizePos, string, list(span))]
)).
opennlp_module(posTagger, opennlp_module(
	posTagger, 
	'opennlp.tools.postag.POSModel', 
	opennlp_model('en-pos-maxent.bin'),
	'opennlp.tools.postag.POSTaggerME',
	[method(tag, array, array)]
)).
opennlp_module(chunker, opennlp_module(
	chunker, 
	'opennlp.tools.chunker.ChunkerModel', 
	opennlp_model('en-chunker.bin'),
	'opennlp.tools.chunker.ChunkerME',
	[method(chunk, list(array), array)]
)).
opennlp_module(nameFinder, opennlp_module(
	nameFinder, 
	'opennlp.tools.namefind.TokenNameFinderModel', 
	opennlp_model('en-ner-person.bin'),
	'opennlp.tools.namefind.NameFinderME',
	[method(find, array, list(span)), method(clearAdaptiveData, void, void)]
)).
opennlp_module(placeFinder, opennlp_module(
	placeFinder, 
	'opennlp.tools.namefind.TokenNameFinderModel', 
	opennlp_model('en-ner-location.bin'),
	'opennlp.tools.namefind.NameFinderME',
	[method(find, array, list(span)), method(clearAdaptiveData, void, void)]
)).