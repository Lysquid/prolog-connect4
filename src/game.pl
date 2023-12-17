?- consult(facts).
?- consult(output).
?- consult(board).
?- consult(ai).

% play a game recursively (turn of player P)
play(B, PlayerNo, P1, P2, EndBoard) :-
    output_board(B),
    make_move(PlayerNo, P1, B, B2),
    next_turn(B2, PlayerNo, P1, P2, EndBoard).

next_turn(B, PlayerNo, P1, P2, EndBoard) :-
    next_player(PlayerNo, NextPlayerNo),
    not(game_over(NextPlayerNo, B)), 
    play(B, NextPlayerNo, P2, P1, EndBoard).

next_turn(B, _, _, _, B).

% determines when the game is over
game_over(P, B) :-
    opponent_mark(P, M),   %%% game is over if opponent wins
    win(B, M)
    .

game_over(_, B) :-
    column_is_full(B, _)    %%% game is over if opponent wins
    .  


% requests next move from human/computer, 
% then applies that move to the given board
make_move(P, Type, B, B2) :-
    get_move(Type, P, B, Move),
    player_mark(P, M),
    move(B, Move, M, B2).


% asks the move of the player
get_move(human, P, B, Move) :-
    player_char(P, Char),
    writef('Player %w move?', [Char]), nl, nl,
    read(Col), nl,
    Move is Col-1,
    not(column_is_full(B, Move)), !
    . 

get_move(human, P, B, Move) :-
    write('Please enter a valid column.'), nl, nl,
    get_move(human, P, B, Move).

get_move(Ai, P, B, Move) :-
    player_char(P, Char),
    writef('Computer %w (%w) is thinking...', [Char, Ai]), nl, nl,
    ai_move(Ai, B, P, Move),
    legal_move(B, P, Move).


% checks if an AI move is legal, stops the game if no
legal_move(B, _, Move) :-
    not(column_is_full(B, Move)).

legal_move(_, Player, _) :-
    player_char(Player, Char),
    writef('The column is full, computer %w loses', [Char]), nl, nl,
    false.


% computes the move an AI
ai_move(random_ai, Board, Player, Move) :-
    possible_moves(Board, Moves),
    random_member(Move, Moves),
    Col is Move+1,
    player_char(Player, Char),
    writef('Computer %w plays in column %w.', [Char, Col]), nl, nl.

ai_move(Heuristic, Board, Player, Move) :-
    player_mark(Player, Mark),
    minmax(Heuristic, 4, Board, Mark, Move, Utility),
    Col is Move+1,
    player_char(Player, Char),
    writef('Computer %w plays in column %w (utility: %w).', [Char, Col, Utility]), nl, nl.

ai_move(_, _, Player, _) :-
    player_char(Player, Char),
    writef('Comupter %w failed to provied a move, and loses.', [Char]), nl, nl,
    false.
