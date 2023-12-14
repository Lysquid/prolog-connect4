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


%.......................................
% game_over
%.......................................
% determines when the game is over


game_over(P, B) :-
    opponent_mark(P, M),   %%% game is over if opponent wins
    win(B, M)
    .

game_over(_, B) :-
    column_is_full(B, _)    %%% game is over if opponent wins
    .  


%.......................................
% make_move
%.......................................
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
    nl,
    nl,
    writef('Player %w move?', [P]), nl,
    read(Col), nl,
    Move is Col-1,
    not(column_is_full(B, Move)),
    % blank_mark(E),
    !
    . 

get_move(human, P, B, Move) :-
    nl,
    nl,
    write('Please enter a valid column.'),
    get_move(human, P, B, Move).

get_move(Ai, P, B, Move) :-
    nl,
    nl,
    writef('Computer (%w) is thinking about next move...', [Ai]), nl, nl,
    player_mark(P, M),
    ai_move(Ai, B, M, Move),
    legal_move(B, Move).

legal_move(B, Move) :-
    not(column_is_full(B, Move)).

legal_move(_, _) :-
    writef('The column is full, computer loses'),
    false.


ai_move(random_ai, Board, Mark, Move) :-
    possible_moves(Board, Moves),
    random_member(Move, Moves),
    Col is Move+1,
    writef('Computer places %w in column %w.', [Mark, Col]), nl.

ai_move(Heuristic, Board, Mark, Move) :-
    minmax(Heuristic, 4, Board, Mark, Move, Utility),
    Col is Move+1,
    writef('Computer places %w in column %w (utility: %w).', [Mark, Col, Utility]), nl.

ai_move(_, _, _, _) :-
    write('Comupter failed to provied a move, and loses.'), nl,
    false.
