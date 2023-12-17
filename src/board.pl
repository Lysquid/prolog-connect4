?- consult(facts).

% get the cell in column C and line L of board B
cell(B, C, L, M) :- 
    I is L * 7 + C,
    nth0(I, B, M).


% set the cell to mark M in column C and line L of board B and copy it to B2
set_cell(B, C, L, E, B2) :- 
    I is L * 7 + C,
    nth0(I, B, _, R),
    nth0(I, B2, E, R).


% checks wether a coordinate (column and line) is within the bounds of the board
in_board(C, L) :-
    between(0, 6, C),
    between(0, 5, L).


% checks if the input column C of the board B is full
column_is_full(B,C) :-
	not(nth0(C, B, 'e')), !
	.

% finds all the possible moves (where the column are not full)
possible_moves(B, L) :-
    findall(C, (in_board(C, 0), not(column_is_full(B, C))), L).


% applies a move on the given board
% (put mark M in position N of column C on board B and return the resulting board B2)
move(B, C, M, B2) :-
	not(column_is_full(B,C)),
	search_column_position(B,C,L),
    set_cell(B, C, L, M, B2).


% searches the empty position N in the column C of the board B
search_column_position(B,C,5) :-
    cell(B, C, 5, 'e').

search_column_position(B,C,L) :-
    player_mark(_, M),
    in_board(C, NL),
    NL > 0,
    L is NL - 1,
    cell(B, C, L, 'e'),
	cell(B, C, NL, M), !.


% checks if their is a winning position for mark M on the board B
win(B, M) :-
    bagof([C, L], (in_board(C, L), win2(B, M, C, L)), _).

% for each coordinates of the board, checks winning position in the 4 directions
win2(B, M, C, L) :- 
    cell(B, C, L, M),
    (
        win3(B, M, C, L, 1, 0, 1) ; 
        win3(B, M, C, L, 1, -1, 1) ;
        win3(B, M, C, L, 1, 1, 1) ;
        win3(B, M, C, L, 0, 1, 1) 
    ), !.

win3(_, _, _, _, _, _, N) :-
    N >= 4.

% recursively checks for alignement of 4 pieces of the same mark
win3(B, M, C, L, DC, DL, N) :- 
    NC is C + DC,
    NL is L + DL,
    in_board(NC, NL),
    cell(B, NC, NL, M),
    NN is N + 1,
    win3(B, M, NC, NL, DC, DL, NN), !
    . 
