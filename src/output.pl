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


output_board(B) :-
    nl,
    nl,
    output_square(B,1),
    write('|'),
    output_square(B,2),
    write('|'),
    output_square(B,3),
    nl,
    write('-----------'),
    nl,
    output_square(B,4),
    write('|'),
    output_square(B,5),
    write('|'),
    output_square(B,6),
    nl,
    write('-----------'),
    nl,
    output_square(B,7),
    write('|'),
    output_square(B,8),
    write('|'),
    output_square(B,9), !
    .

output_board :-
    board(B),
    output_board(B), !
    .

output_square(B,S) :-
    square(B,S,M),
    write(' '), 
    output_square2(S,M),  
    write(' '), !
    .

output_square2(S, E) :- 
    blank_mark(E),
    write(S), !              %%% if square is empty, output the square number
    .

output_square2(S, M) :- 
    write(M), !              %%% if square is marked, output the mark
    .

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


