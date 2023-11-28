%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST 381 -– Artificial Intelligence
%%% Blazanome
%%% Due December 15, 2023
%%% Source : https://gitea.blazanome.ynh.fr/Blazanome/puissance4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% A Prolog Implementation of Connect4
%%% using the minimax strategy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*

The following conventions are used in this program...

Single letter variables represent:

L - a list
N - a number, position, index, or counter
V - a value (usually a string)
A - an accumulator
H - the head of a list
T - the tail of a list

For this implementation, these single letter variables represent:

P - a player number (1 or 2)
B - the board (a 9 item list representing a 3x3 matrix)
    each "square" on the board can contain one of 3 values: x ,o, or e (for empty)
S - the number of a square on the board (1 - 9)
M - a mark on a square (x or o)
E - the mark used to represent an empty square ('e').
U - the utility value of a board position
R - a random number
D - the depth of the minimax search tree (for outputting utility values, and for debugging)

Variables with a numeric suffix represent a variable based on another variable.
(e.g. B2 is a new board position based on B)

For predicates, the last variable is usually the "return" value.
(e.g. opponent_mark(P,M), returns the opposing mark in variable M)

Predicates with a numeric suffix represent a "nested" predicate.

e.g. myrule2(...) is meant to be called from myrule(...) 
     and myrule3(...) is meant to be called from myrule2(...)


There are only two assertions that are used in this implementation

asserta( board(B) ) - the current board 
asserta( player(P, Type) ) - indicates which players are human/computer.

*/



run :-
    imports,
    hello,          %%% Display welcome message, initialize game
    play(1),        %%% Play the game starting with player 1
    goodbye         %%% Display end of game message
    .

imports :-
    consult(random),
    consult(facts),
    consult(output),
    consult(board),
    consult(list)
    .

run :-
    goodbye
    .


hello :-
    initialize,
%    cls,
    nl,
    nl,
    nl,
    write('Welcome to Connect4.'),
    read_players,
    output_players
    .

initialize :-
    random_seed,          %%% use current time to initialize random number generator
    blank_mark(E),
    asserta( board([
        E, E, E, E, E, E, E,
        E, E, E, E, E, E, E,
        E, E, E, E, E, E, E,
        E, E, E, E, E, E, E,
        E, E, E, E, E, E, E,
        E, E, E, E, E, E, E
    ]) ) %%% create a blank board
    .

goodbye :-
    board(B),
    nl,
    nl,
    write('Game over: '),
    output_winner(B),
    retract(board(_)),
    retract(player(_,_)),
    read_play_again(V), !,
    (V == 'Y' ; V == 'y'), 
    !,
    run
    .

read_play_again(V) :-
    nl,
    nl,
    write('Play again (Y/N)? '),
    read(V),
    (V == 'y' ; V == 'Y' ; V == 'n' ; V == 'N'), !
    .

read_play_again(V) :-
    nl,
    nl,
    write('Please enter Y or N.'),
    read_play_again(V)
    .


read_players :-
    nl,
    nl,
    write('Number of human players? '),
    read(N),
    set_players(N)
    .

set_players(0) :- 
    asserta( player(1, computer) ),
    asserta( player(2, computer) ), !
    .

set_players(1) :-
    nl,
    write('Is human playing X or O (X moves first)? '),
    read(M),
    human_playing(M), !
    .

set_players(2) :- 
    asserta( player(1, human) ),
    asserta( player(2, human) ), !
    .

set_players(N) :-
    nl,
    write('Please enter 0, 1, or 2.'),
    read_players
    .


human_playing(M) :- 
    (M == 'x' ; M == 'X'),
    asserta( player(1, human) ),
    asserta( player(2, computer) ), !
    .

human_playing(M) :- 
    (M == 'o' ; M == 'O'),
    asserta( player(1, computer) ),
    asserta( player(2, human) ), !
    .

human_playing(M) :-
    nl,
    write('Please enter X or O.'),
    set_players(1)
    .


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
%
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
%

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
    write(' move? '),
    read(S),

    blank_mark(E),
    % square(B, S, E),
    player_mark(P, M),
    % move(B, S, M, B2)   TODO
    !
    .

make_move2(human, P, B, B2) :-
    nl,
    nl,
    write('Please select a numbered square.'),
    make_move2(human,P,B,B2)
    .

make_move2(computer, P, B, B2) :-
    nl,
    nl,
    write('Computer is thinking about next move...'),
    player_mark(P, M),
    minimax(0, B, M, S, U),
    move(B,S,M,B2),

    nl,
    nl,
    write('Computer places '),
    write(M),
    write(' in square '),
    write(S),
    write('.')
    .


%.......................................
% moves
%.......................................
% retrieves a list of available moves (empty squares) on a board.
%

moves(B,L) :-
    not(win(B,x)),                %%% if either player already won, then there are no available moves
    not(win(B,o)),
    blank_mark(E),
    findall(N, square(B,N,E), L), 
    L \= []
    .

