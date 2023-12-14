?- consult(facts).


in_board(C, L) :-
    between(0, 6, C),
    between(0, 5, L).


possible_moves(B, L) :-
    findall(C, (in_board(C, 0), column_is_not_full(B, C)), L).


%.......................................
% move
%.......................................
% applies a move on the given board
% (put mark M in position N of column C on board B and return the resulting board B2)

move(B,C,M,B2) :-
	column_is_not_full(B,C),
	search_column_position(B,C,L),
    set_cell(B, C, L, M, B2).

%.....
% column_is_not_full
%.....
% checks if the input column C of the board B is full

column_is_not_full(B,C) :-
	nth0(C, B, V),
	(V == 'e'),
	!
	.

cell(B, C, L, M) :- 
    I is L * 7 + C,
    nth0(I, B, M).

set_cell(B, C, L, E, B2) :- 
    I is L * 7 + C,
    nth0(I, B, _, R),
    nth0(I, B2, E, R).

%....
% search_column_position 
%....
% searches the empty position N in the column C of the board B

search_column_position(B,C,5) :- cell(B, C, 5, 'e').

search_column_position(B,C,L) :-
    player_mark(_, M),
    in_board(C, NL),
    NL > 0,
    L is NL - 1,
    cell(B, C, L, 'e'),
	cell(B, C, NL, M), !.


%.......................................
% win
%.......................................

win(B, M) :-
    setof([C, L], (in_board(C, L), win2(B, M, C, L)), _).

win2(B, M, C, L) :- 
    C >= 0,
    L >= 0,
    C < 7,
    L < 6,
    cell(B, C, L, M),
    (
        win3(B, M, C, L, 1, 0, 1) ; 
        win3(B, M, C, L, 1, -1, 1) ;
        win3(B, M, C, L, 1, 1, 1) ;
        win3(B, M, C, L, 0, 1, 1) 
    ), !.

win3(_, _, _, _, _, _, N) :-
    N >= 4.

win3(B, M, C, L, DC, DL, N) :- 
    NC is C + DC,
    NL is L + DL,
    in_board(NC, NL),
    cell(B, NC, NL, M),
    NN is N + 1,
    win3(B, M, NC, NL, DC, DL, NN), !
    . 
