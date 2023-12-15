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


?- consult(facts).
?- consult(output).
?- consult(board).
?- consult(game).


run :-
    hello,          %%% Display welcome message, initialize game
    play(1),        %%% Play the game starting with player 1
    goodbye         %%% Display end of game message
    .

run :-
    goodbye
    .


hello :-
    initialize,
    nl,
    write('Welcome to Connect4.'), nl, nl,
    read_players,
    output_players
    .

initialize :-
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
    write('Game over: '), nl, nl,
    output_winner(B), nl, nl,
    retract(board(_)),
    retract(player(_,_)),
    read_play_again(V), !,
    V == 'y', 
    !,
    run
    .

read_play_again(V) :-
    write('Play again (y/n)? '), nl,
    read(V), nl,
    (V == 'y' ; V == 'n'), !
    .

read_play_again(V) :-
    write('Please enter y or n.'), nl, nl,
    read_play_again(V)
    .


read_players :-
    write('Number of human players? '), nl,
    read(N), nl,
    set_players(N)
    .

set_players(0) :- 
    set_ai(1),
 	set_ai(2), !
    .

set_players(1) :-
    write('Is human playing first? (y/n)'), nl,
    read(First), nl,
    human_playing(First), !
    .

set_players(2) :- 
    asserta( player(1, human) ),
    asserta( player(2, human) ), !
    .

set_players(_) :-
    write('Please enter 0, 1, or 2.'), nl, nl,
    read_players, !
    .


human_playing(y) :- 
    asserta( player(1, human) ),
    set_ai(2), !
	.

human_playing(n) :- 
    asserta( player(2, human) ),
	set_ai(1), !
	.

human_playing(_) :-
    write('Please enter y or n.'), nl, nl,
    set_players(1)
    .

set_ai(N) :-
	write('Please choose a computer AI:'), nl,
    write('1. random (no minmax)'), nl,
    write('2. good heuristic'), nl,
    write('3. bad heuristic'), nl,
    write('4. no heuristic'), nl,
	read(Ai), nl,
    ai_playing(N, Ai).

ai_playing(N, 1) :- asserta( player(N, random_ai)).
ai_playing(N, 2) :- asserta( player(N, good_heuristic)).
ai_playing(N, 3) :- asserta( player(N, bad_heuristic)).
ai_playing(N, 4) :- asserta( player(N, no_heuristic)).

ai_playing(N, _) :-
    write('Please enter a valid number.'), nl, nl,
    set_ai(N).

