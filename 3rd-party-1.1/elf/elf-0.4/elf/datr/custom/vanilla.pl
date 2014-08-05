% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                           %
% File:            custom/vanilla.pl                                        %
% Purpose:         DATR customisation predicates - vanilla version          %
% Author:          Roger Evans                                              %
%                                                                           %
%      Copyright (c) University of Sussex 1992.  All rights reserved.       %
% Copyright (c) Universities of Sussex and Brighton 1999.                   %
% All rights reserved.                                                      %
%                                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%   The predicates in this file can be customised by the user to achieve
%   different effects (foreign language messages and declarations etc.)
%   If they fail, the system will use a reasonable default. This file
%   defines them all to fail. Other customisation files may exist in the
%   custom subdirectory - copy whichever you want to custom.pl in the DATR
%   directory (or write your own)

%   Any custom actions at system reset time
dc_reset :- fail.

%   Print a warning message concerning some culprit item.
dc_warn(Culprit,Message) :- fail.

%   Print an error message concerning some culprit item and abort processing.
dc_error(Culprit,Message) :- fail.

%   given a list of characters read as a foreign term, return a Prolog term
%   to be treated as a DATR atom. If this fails DATR will give an error (ie
%   the default here is not to allow foreign terms at all).
dc_foreign(List, Term) :- fail.

%   given a name read as a declaration (after a #) return the DATR key
%   indicating declaration type (one of node,reset,show,hide,vars,delete,
%   exec). This allows alternative or multiple names for various declarations.
%   If this fails, the system will use the identity mapping.
dc_decl_name(Key,Name) :- fail.

%   given an Item token and a type (node or atom), declare the item as
%   being of the given type. If this fails, the default strategy uses prolog
%   'record'
dc_declare_item(Item, Type) :- fail.

%   given an item, (as a word and a list of chars), return its type (atom
%   node, or dvar). If this fails, the default strategy is to use the 'record' database
%   and otherwise the convention that nodes start with capital letters and
%   dvars start with '$'
dc_declared_itemtype(Item, Chars, Type) :- fail.

%   given a node name specified in a #uses declaration, return the (prolog)
%   filename to be loaded. If this fails, the system returns 'useslib/Node.pl'
dc_library_name(Node,File) :- fail.


%   print a custom banner string. If this fails, the system prints nothing.
dc_custom_banner :- fail.


% hooks before and after a top level DATR query
dc_before_query(N,P,V) :- fail.
dc_after_query(N,P,V) :- fail.


% The next line is the Revision Control System Id: do not delete it.
% $Id: vanilla.pl 1.3 1999/03/04 15:37:50 rpe Exp $
