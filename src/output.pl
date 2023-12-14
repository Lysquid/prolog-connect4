%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

?- consult(board).

output_players :- 
    nl,
    player(1, V1),
    writef('Player 1 is %w', [V1]), nl,   %%% either human or computer
    player(2, V2),
    writef('Player 2 is %w', [V2]), nl,   %%% either human or computer
    !
    .


output_winner(B) :-
    win(B,x),
    write('X wins.'),
    !
    .

output_winner(B) :-
    win(B,o),
    write('O wins.'),
    !
    .

output_winner(_) :-
    write('No winner.')
    .

output_interline(0) :-
    write('┌───┬───┬───┬───┬───┬───┬───┐'),
    nl.

output_interline(6) :-
    write('└───┴───┴───┴───┴───┴───┴───┘'),
    nl.

output_interline(_) :-
    write('├───┼───┼───┼───┼───┼───┼───┤'),
    nl.

output_lines(_,6).

output_lines(B,C) :-
    output_cell(B, 0, C),
    C1 is C+1,
    output_interline(C1),
    output_lines(B,C1)
    .

output_header :-
    write('  1   2   3   4   5   6   7'),
    nl
    .

output_cell(_,7,_) :-
    write('│'),
    nl,
    !
    .

output_cell(B,C,L) :-
    cell(B,C,L,M),
    write('│ '),
    output_cell2(M),
    write(' '),
    C1 is C+1,
    output_cell(B,C1,L),
    !
    .

output_cell2(E) :-
    blank_mark(E),
    write(' '), !              %%% if square is empty, output the square number
    .

output_cell2(x) :-
    write('○'), !              %%% if square is marked, output the mark
    .

output_cell2(o) :-
    write('●'), !              %%% if square is marked, output the mark
    .

output_board(B) :-
    nl,
    nl,
    output_header,
    output_interline(0),
    output_lines(B,0),
    output_header.


output_value(D,S,U) :-
    D == 1,
    nl,
    write('Square %S utility: %', [S, U]), nl, !
    . 

output_value(_,_,_).

