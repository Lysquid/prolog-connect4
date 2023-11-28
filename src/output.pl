%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output_players :- 
    nl,
    player(1, V1),
    write('Player 1 is '),   %%% either human or computer
    write(V1),

    nl,
    player(2, V2),
    write('Player 2 is '),   %%% either human or computer
    write(V2), 
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

output_winner(B) :-
    write('No winner.')
    .

output_interline(0) :-
    write('┌───┬───┬───┬───┬───┬───┬───┐'),
    nl.

output_interline(6) :-
    write('└───┴───┴───┴───┴───┴───┴───┘'),
    nl.

output_interline(X) :-
    write('├───┼───┼───┼───┼───┼───┼───┤'),
    nl.

output_lines(B,6).

output_lines(B,X) :-
    write('│'),
    output_square(B,0,X),
    write('│'),
    output_square(B,1,X),
    write('│'),
    output_square(B,2,X),
    write('│'),
    output_square(B,3,X),
    write('│'),
    output_square(B,4,X),
    write('│'),
    output_square(B,5,X),
    write('│'),
    output_square(B,6,X),
    write('│'),
    nl,
    X1 is X+1,
    output_interline(X1),
    output_lines(B,X1)
    .

output_header :-
    write('  1   2   3   4   5   6   7'),
    nl
    .

output_square(B,C,L) :-
    cell(B,C,L,M),
    write(' '),
    output_square2(M),
    write(' '),
    !
    .

output_square2(E) :-
    blank_mark(E),
    write(' '), !              %%% if square is empty, output the square number
    .

output_square2(M) :-
    write(M), !              %%% if square is marked, output the mark
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
    write('Square '),
    write(S),
    write(', utility: '),
    write(U), !
    .

output_value(D,S,U) :- 
    true
    .


