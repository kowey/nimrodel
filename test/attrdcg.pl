% vim: set filetype=prolog:
%
% Eric Kow <eric@erickow.com>
% (c) Copyright 2014, University of Brighton
% (BSD3 license)
%
% Silly test grammar to generate test strings to run nimrodel on.
% The basic idea is that given a set of attributes we want to
% extract, we should be able to pull information out from strings
% that comprise any subset of those attributes.
%
% By backtracking through this grammar, we should be able to
% simultaneously generate the a sensible combination of attributes
% to test nimrodel on, along with a string to test it with.
% This is not very thorough, but it should provide a form of
% unit testing.

tstring(Atts) --> tstring([], Atts).
tstring(A0, Atts) --> name(A0, Atts).
tstring(A0, Atts) --> name(A0, A1), role(A1, Atts).

name(A0, Atts) --> title(A0, A1), corename(A1, Atts).
name(A0, Atts) --> corename(A0, Atts).

corename(A0, Atts) --> surname(A0, Atts).
corename(A0, Atts) --> forename(A0, Atts).
corename(A0, Atts) --> forename(A0, A1), surname(A1, Atts).

title(X, ['title'|X]) --> ['Magister'].
surname(X, ['gender','surname'|X]) --> ['Calvert'].
forename(X, ['forename'|X]) --> ['Thomas'].
role(X, ['role'|X]) --> ['Archbishop','of','York'].

% example run
% ?- tstring(Attrs, X, []).
% Attrs = [surname, title],
% X = ['Magister', 'Calvert'] ;
% Attrs = [forename, title],
% X = ['Magister', 'Thomas'] ;
% Attrs = [surname, forename, title],
% X = ['Magister', 'Thomas', 'Calvert'] ;
% Attrs = [surname],
% X = ['Calvert'] ;
% Attrs = [forename],
% X = ['Thomas'] ;
% Attrs = [surname, forename],
% X = ['Thomas', 'Calvert'] ;
% Attrs = [role, surname, title],
% X = ['Magister', 'Calvert', 'Archbishop', of, 'York'] ;
% Attrs = [role, forename, title],
% X = ['Magister', 'Thomas', 'Archbishop', of, 'York'] ;
% Attrs = [role, surname, forename, title],
% X = ['Magister', 'Thomas', 'Calvert', 'Archbishop', of, 'York'] ;
% Attrs = [role, surname],
% X = ['Calvert', 'Archbishop', of, 'York'] ;
% Attrs = [role, forename],
% X = ['Thomas', 'Archbishop', of, 'York'] ;
% Attrs = [role, surname, forename],
% X = ['Thomas', 'Calvert', 'Archbishop', of, 'York'].

% TODO
% article (eg. the) - huh?
% provenance - place, but how do these appear?
% appearanceData - eg 1530, but where in string?
