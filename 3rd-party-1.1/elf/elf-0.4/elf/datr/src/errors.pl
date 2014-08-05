% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            errors.pl                                                %
% Purpose:         error routines                                           %
% Author:          Roger Evans                                              %
%                                                                           %
%      Copyright (c) University of Sussex 1992.  All rights reserved.       %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   $Revision: 1.2 $
%   $Author: rpe $
%   $Date: 1997/11/23 21:33:15 $
%   $State: Exp $

%   -- datr_warn(Culprit,Message) -------------------------------------------

%   give a warning message - look for customised routine first, otherwise
%   print something sensible

datr_warn(Item,Mess) :- dc_warn(Item,Mess),!.
datr_warn(Item,Mess) :- !, datr_do_warn(Item,Mess).

datr_do_warn(Item,Mess) :- !,
    db_nl,
    db_write('DATR warning - '), db_write(Mess),db_nl,
    db_write('Involving: '), db_write(Item),db_nl.


%   -- datr_error(Culprit,Message) ------------------------------------------

%   give an error message - look for customised routine first, otherwise
%   print something sensible and abort

datr_error(Item,Mess) :- dc_error(Item,Mess),!.
datr_error(Item,Mess) :- !, datr_do_error(Item,Mess).

datr_do_error(Item,Mess) :- !,
    db_nl,
    db_write('DATR error - '), db_write(Mess),db_nl,
    db_write('Involving: '), db_write(Item),db_nl,
    db_seen, db_told,
    db_abort.
