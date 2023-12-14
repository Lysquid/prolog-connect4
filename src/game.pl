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
    write('Player '),
    write(P),
    write(' move? '), nl,
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

make_move2(computer1, P, B, B2) :-
    nl,
    nl,
    write('Computer (random) is thinking about next move...'),
    player_mark(P, M),
    randomai(B,S,M),
    move(B,S,M,B2),
    
    nl,
    nl,
    write('Computer places '),
    write(M),
    write(' in square '),
    S1 is S+1,
    write(S1),
    write('.').

make_move2(computer2, P, B, B2) :-
    nl,
    nl,
    write('Computer (minmax) is thinking about next move...'),
    nl,
    player_mark(P, M),
    minmax(computer2,4,B,M,S,U),
    move(B,S,M,B2),
    nl,
    write('Computer places '),
    write(M),
    write(' in square '),
    S1 is S+1,
    write(S1),
    write(' (utility: '),
    write(U),
    write(')'),
    write('.')
    . 

make_move2(computer3, P, B, B2) :-
    nl,
    nl,
    write('Computer (minmax) is thinking about next move...'),
    nl,
    player_mark(P, M),
    minmax(computer3,4,B,M,S,U),
    move(B,S,M,B2),
    nl,
    write('Computer places '),
    write(M),
    write(' in square '),
    S1 is S+1,
    write(S1),
    write(' (utility: '),
    write(U),
    write(')'),
    write('.')
    .

make_move2(computer4, P, B, B2) :-
    nl,
    nl,
    write('Computer (minmax) is thinking about next move...'),
    nl,
    player_mark(P, M),
    minmax(computer4,4,B,M,S,U),
    move(B,S,M,B2),
    nl,
    write('Computer places '),
    write(M),
    write(' in square '),
    S1 is S+1,
    write(S1),
    write(' (utility: '),
    write(U),
    write(')'),
    write('.').
