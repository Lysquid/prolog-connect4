%.......................................
% move
%.......................................
% applies a move on the given board
% (put mark M in position N of column C on board B and return the resulting board B2)
%

move(B,C,M,B2) :-
	column_is_not_full(B,C),
	!,
	search_column_position(B,C,N), 
	set_item(B,N,M,B2)
	.

%.....
% column_is_not_full
%.....
% checks if the input column C of the board B is full and returns a flag F

column_is_not_full(B,C) :-
	get_item(B,C,V),
	(V == 'e'),
	!
	.
	

%.......................................
% set_item
%.......................................
% Given a list L, replace the item at position N with V
% return the new list in list L2
%

set_item(L, N, V, L2) :-
    set_item2(L, N, V, 1, L2)
        .

set_item2( [], N, V, A, L2) :- 
    N == -1, 
    L2 = []
    .

set_item2( [_|T1], N, V, A, [V|T2] ) :- 
    A = N,
    A1 is N + 1,
    set_item2( T1, -1, V, A1, T2 )
    .

set_item2( [H|T1], N, V, A, [H|T2] ) :- 
    A1 is A + 1, 
    set_item2( T1, N, V, A1, T2 )
    .



%.......................................
% get_item
%.......................................
% Given a list L, retrieve the item at position N and return it as value V
%

get_item(L, N, V) :-
    get_item2(L, N, 1, V)
    .

get_item2( [], _N, _A, V) :- 
    V = [], !,
    fail
        .

get_item2( [H|_T], N, A, V) :- 
    A = N,
    V = H
    .

get_item2( [_|T], N, A, V) :-
    A1 is A + 1,
    get_item2( T, N, A1, V)
    .
