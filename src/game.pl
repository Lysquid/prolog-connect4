?- consult(facts).
?- consult(output).
?- consult(board).
?- consult(ai).

play(P) :-
    board(B), !,
    output_board(B), !,
    not(game_over(P, B)), !, 
    make_move(P, B), !,
    next_player(P, P2), !,
    play(P2), !
    .



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
make_move(P, B) :-
    player(P, Type),
    get_move(Type, P, B, Move),
    player_mark(P, M),
    move(B, Move, M, B2),
    retract( board(_) ),
    asserta( board(B2) )
    .

get_move(human, P, B, Move) :-
    player_char(P, Char),
    writef('Player %w move?', [Char]), nl, nl,
    read(Col), nl,
    Move is Col-1,
    not(column_is_full(B, Move)),
    % blank_mark(E),
    !
    . 

get_move(human, P, B, Move) :-
    write('Please enter a valid column.'), nl, nl,
    get_move(human, P, B, Move).

get_move(Ai, P, B, Move) :-
    player_char(P, Char),
    writef('Computer %w (%w) is thinking...', [Char, Ai]), nl, nl,
    ai_move(Ai, B, P, Move),
    legal_move(B, P, Move).

legal_move(B, _, Move) :-
    not(column_is_full(B, Move)).

legal_move(_, Player, _) :-
    player_char(Player, Char),
    writef('The column is full, computer %w loses', [Char]), nl, nl,
    false.


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
