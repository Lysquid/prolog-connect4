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
% checks if the input column C of the board B is full

example_board([
    e, e, x, e, e, e, e,
    x, e, e, e, x, e, e,
    x, e, x, x, o, e, e,
    x, e, o, x, o, e, e,
    x, x, o, o, o, e, e,
    x, x, o, x, x, o, x
]).

column_is_not_full(B,C) :-
	nth0(C, B, V),
	(V == 'e'),
	!
	.

%....
% search_column_position 
%....
% searches the empty position N in the column C of the board B

search_column_position(B,C,N) :-
	N is C-7,
	nth0(C,B,'e'),
	!,
	C2 is C+7,
	search_column_position(B,C2,N)
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

