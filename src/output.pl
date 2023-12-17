?- consult(board).

% called at the start of a game to confirm what both players are
output_players :- 
    player(1, V1),
    player_char(1, Char1),
    writef('Player 1 (%w) is %w', [Char1, V1]), nl,   %%% either human or computer
    player(2, V2),
    player_char(2, Char2),
    writef('Player 2 (%w) is %w', [Char2, V2]), nl, nl,   %%% either human or computer
    !
    .

% called at the end of the game, write will be called if player 1 won
output_winner(B) :-
    win(B,x),
    player_char(1, Char),
    writef('%w wins.', [Char]),
    !
    .

% called at the end of the game, write will be called if player 2 won
output_winner(B) :-
    win(B,o),
    player_char(2, Char),
    writef('%w wins.', [Char]),
    !
    .

% called at the end of the game if the board fills up with no winner
output_winner(_) :-
    write('No winner.')
    .

% writes the top of the board.
output_interline(0) :-
    write('┌───┬───┬───┬───┬───┬───┬───┐'),
    nl.

% writes the bottom of the board.
output_interline(6) :-
    write('└───┴───┴───┴───┴───┴───┴───┘'),
    nl.

% writes the middle of the board
output_interline(_) :-
    write('├───┼───┼───┼───┼───┼───┼───┤'),
    nl.

% stops once we have gone through the entire board
output_lines(_,6).

% calls a function that will output each cell of the line. Then draws the interline and calls itself rot he next line 
output_lines(B,C) :-
    output_cell(B, 0, C),
    C1 is C+1,
    output_interline(C1),
    output_lines(B,C1)
    .

% draws a header so that the user knows what numbers to put
output_header :-
    write('  1   2   3   4   5   6   7'), nl
    . 

% called when you reach the end of a line
output_cell(_,7,_) :-
    write('│'),
    nl,
    !
    .

% finds the content of the cell then calls a function that draws it. Then moves on to the next cell
output_cell(B,C,L) :-
    cell(B,C,L,M),
    write('│ '),
    output_cell2(M),
    write(' '),
    C1 is C+1,
    output_cell(B,C1,L),
    !
    .

% draws a blank square
output_cell2(E) :-
    blank_mark(E),
    write(' '), !              %%% if square is empty, output the square number
    .

% draws the piece based on which player has the piece
output_cell2(Mark) :-
    player_mark(Player, Mark),
    player_char(Player, Char),
    write(Char), !              %%% if square is marked, output the mark
    .

% draws the board starting with the header then a repeated call.
output_board(B) :-
    output_header,
    output_interline(0),
    output_lines(B,0),
    output_header, nl.
