
% DATR bindings for prolog openNLP calls

:- compile('$ELFROOT/opennlp/opennlp.pl').

'openNLP.SentenceDetector'(In, _GN, _GP, Out) :- opennlp(sentenceDetector, In, Out).
'openNLP.Tokenizer'(In, _GN, _GP, Out) :- opennlp(tokenizer, In, Out).
'openNLP.PosTagger'(In, _GN, _GP, Out) :- opennlp(posTagger, In, Out).
'openNLP.Chunker'(In, _GN, _GP, Out) :- opennlp(posTagger, In, Tags), opennlp(chunker, [In, Tags], Out).
'openNLP.NameFinder'(In, _GN, _GP, Out) :- opennlp(nameFinder, In, Out).
'openNLP.PlaceFinder'(In, _GN, _GP, Out) :- opennlp(placeFinder, In, Out).

'openNLP.OpenNLP'([Module, Method|Args], _GN, _GP, Out) :- opennlp(Module, Method, Args, Out).
'openNLP.GetSpanStrings'([Source|Spans], _GN, _GP, Out) :- !, opennlp_getSpanStrings(Spans, Out, Source).
'openNLP.TokenSpanToStringSpan'([In|Args], _GN, _GP, [Out]) :- !, opennlp_tokenSpanToStringSpan(In, Args, Out).
'openNLP.AbsoluteSpan'([S1, S2| _], _GN, _GP, [S3]) :- !, opennlp_absoluteSpan(S1, S2, S3).

'openNLP.NewSpan'([T,S,E|_L], _GN, _GP, [Span]) :- opennlp_newSpan(T,S,E,_Text,Span).

'openNLP.WrapString'([Str|_L], _GN, _GP, [Wrapped]) :- !,
	mk_string_buffer(Str, Wrapped).
'openNLP.GetWrappedSpanStrings'([Source|Spans], _GN, _GP, Out) :- !,
	opennlp_getWrappedSpanStrings(Spans, Out, Source).

'openNLP.Span'([F|L], _GN, _GP, NL) :- !,
	openNLPSpanField(F, N),
	openNLPSpan(N,L,NL).
	
openNLPSpanField(type,1).
openNLPSpanField(start,2).
openNLPSpanField(end,3).
openNLPSpanField(text,4).

openNLPSpan(_N,[],[]) :- !.
openNLPSpan(N, [H|T], [NH|NT]) :- 
	arg(N, H, NH),
	openNLPSpan(N, T, NT).

