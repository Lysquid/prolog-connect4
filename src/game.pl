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
    game_over2(P, B)
    .

game_over2(P, B) :-
    opponent_mark(P, M),   %%% game is over if opponent wins
    win(B, M)
    .

% game_over2(P, B) :-
%     blank_mark(E),
%     not(square(B,S,E))     %%% game is over if opponent wins
%     .


%.......................................
% make_move
%.......................................
% requests next move from human/computer, 
% then applies that move to the given board

make_move(P, B) :-
    player(P, Type),
    make_move2(Type, P, B, B2),
    retract( board(_) ),
    asserta( board(B2) )
    .

make_move2(human, P, B, B2) :-
    nl,
    nl,
    writef('Player %w move?', [P]), nl,
    read(S1), nl,
    S is S1-1,
    % blank_mark(E),
    player_mark(P, M),
    move(B, S, M, B2),
    !
    . 

make_move2(human, P, B, B2) :-
    nl,
    nl,
    write('Please enter a valid number.'),
    make_move2(human,P,B,B2).

make_move2(Ai, P, B, B2) :-
    nl,
    nl,
    writef('Computer (%w) is thinking about next move...', [Ai]), nl,
    player_mark(P, M),
    ai_move(Ai,B,M,S,U),
    move(B,S,M,B2),
    nl,
    S1 is S+1,
    writef('Computer places %w in column %w (utility: %w).', [M, S1, U]), nl.


ai_move(random_ai, Board, _, Move, 0) :-
    possible_moves(Board, Moves),
    random_member(Move, Moves).

ai_move(Heuristic, Board, Mark, Move, Utility) :-
    minmax(Heuristic, 5, Board, Mark, Move, Utility).
