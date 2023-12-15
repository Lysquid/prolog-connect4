%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

?- consult(board).

output_players :- 
    player(1, V1),
    player_char(1, Char1),
    writef('Player 1 (%w) is %w', [Char1, V1]), nl,   %%% either human or computer
    player(2, V2),
    player_char(2, Char2),
    writef('Player 2 (%w) is %w', [Char2, V2]), nl, nl,   %%% either human or computer
    !
    .


output_winner(B) :-
    win(B,x),
    player_char(1, Char),
    writef('%w wins.', [Char]),
    !
    .

output_winner(B) :-
    win(B,o),
    player_char(2, Char),
    writef('%w wins.', [Char]),
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
    write('  1   2   3   4   5   6   7'), nl
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

output_cell2(Mark) :-
    player_mark(Player, Mark),
    player_char(Player, Char),
    write(Char), !              %%% if square is marked, output the mark
    .

output_board(B) :-
    output_header,
    output_interline(0),
    output_lines(B,0),
    output_header, nl.
