%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Artificial Intelligence
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


% runs the game
run :-
    nl, write('Welcome to Connect4.'), nl, nl,
    game.

game :-
    initialize_board(Board),
    read_players(P1, P2),
    play(Board, 1, P1, P2, EndBoard),       %%% Play the game starting with player 1
    game_end(EndBoard),
    play_again. 


% creates a blank board
initialize_board([
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e
]).

% displays end of game message
game_end(B) :-
    output_board(B),
    write('Game over: '),
    output_winner(B), nl, nl. 

% asks wether to play again
play_again() :-
    write('Play again (y/n)? '), nl,
    read(V), nl,
    play_again2(V).

play_again2(y) :-
    game.
    
play_again2(n).

play_again2(_) :-
    write('Enter y or n.').
    

% reads the number of human players
read_players(P1, P2) :-
    write('Number of human players? '), nl,
    read(N), nl,
    set_players(N, P1, P2),
    output_players(P1, P2)
    .

% sets the type of players depending on the number of humans players
set_players(0, P1, P2) :- 
    set_ai(1, P1),
 	set_ai(2, P2), !
    .

set_players(1, P1, P2) :-
    write('Is human playing first? (y/n)'), nl,
    read(First), nl,
    human_playing(First, P1, P2), !
    .

set_players(2, human, human).

set_players(_, P1, P2) :-
    write('Please enter 0, 1, or 2.'), nl, nl,
    read_players(P1, P2), !
    .

% case when the human is playing first
human_playing(y, human, Ai) :- 
    set_ai(2, Ai).

% case when the human is playing second
human_playing(n, Ai, human) :- 
	set_ai(1, Ai).

human_playing(_, P1, P2) :-
    write('Please enter y or n.'), nl, nl,
    set_players(1, P1, P2).


% choice of the compter AI
set_ai(_, Ai) :-
	write('Please choose a computer AI:'), nl,
    write('1. random (no minmax)'), nl,
    write('2. good heuristic'), nl,
    write('3. bad heuristic'), nl,
    write('4. no heuristic'), nl,
    write('5. less good heuristic'), nl,
	read(AiNum), nl,
    ai_playing(AiNum, Ai).

ai_playing(1, random_ai).
ai_playing(2, good_heuristic).
ai_playing(3, bad_heuristic).
ai_playing(4, no_heuristic).
ai_playing(5, less_good_heuristic).

ai_playing(N, Ai) :-
    write('Please enter a valid number.'), nl, nl,
    set_ai(N, Ai).

