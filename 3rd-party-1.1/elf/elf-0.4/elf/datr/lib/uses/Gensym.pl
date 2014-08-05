
:- use_module(library(gensym)).

'Gensym'([gensym, Base|_P], _GN, _GP, [V]) :- !, gensym(Base, V).
'Gensym'([reset |L], _GN, _GP, []) :- !, datr_lib_gensym_reset(L).

datr_lib_gensym_reset([]).
datr_lib_gensym_reset([H|T]) :- reset_gensym(H), datr_lib_gensym_reset(T).