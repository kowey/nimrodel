% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            version.pl                                               %
% Purpose:         specify datr version                                     %
% Author:          Roger Evans                                              %
%                                                                           %
% Copyright (c) Universities of Sussex and Brighton 1998-2009.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

datr_version(2,'11.1').

datr_version_date('25 September 2012').


datr_banner_string(Banner):-
    datr_version(Rel,Rev),
    datr_version_date(Date),
    db_name(Rel, Relname),
    db_name(Rev, Revname),
    db_name(Date, Datename),
    datr_append(Datename, ")",B1),
    datr_append(" -- ", B1, B2),
    datr_append(Revname, B2, B3),
    datr_append(".", B3, B4),
    datr_append(Relname, B4, B5),
    datr_append("Sussex/Brighton DATR (Version ", B5, B6),
    db_name(Banner, B6).

datr_banner :-
    not(datr_flag(quiet)), telling(user), !,
    datr_banner_string(B),
    db_write(B),
    db_nl,
    datr_custom_banner,
    db_nl,
    db_nl.
datr_banner.

datr_custom_banner :- dc_custom_banner, !.
datr_custom_banner.
