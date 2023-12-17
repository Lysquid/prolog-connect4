?- consult('../board').
?- consult('../facts').

% starts at one corner of the board
bad_heuristic(B, M, S, P) :-
    score(B, M, 0, 0, S, P).

% stops when it goes through all the board
score(_, _, 7, 5, 0, _).

%goes to the next line when reaches the end of a line
score(B, M, 7, L, S, P) :- 
    NL is L + 1,
    score(B, M, 0, NL, S, P).

% adds the score for the square and calls itself
score(B, M, C, L, S, P) :- 
    score2(B, M, C, L, NS, P),
    NC is C + 1,
    score(B, M, NC, L, NNS, P),
    S is NS + NNS.

% adds for every square controlled by x 
score2(B, M, C, L, S, _):- 
    cell(B, C, L, V),
    not(inverse_mark(M, V)),
    not(blank_mark(V)),
    S is (30-(C-3)*(C-3)-L*3)/10.

% substracts for every square controlled by o
score2(B, M, C, L, S, _):- 
    cell(B, C, L, V),
    inverse_mark(M, V),
    not(blank_mark(V)),
    S is -(30-(C-3)*(C-3)-L*3)/10.

% 0 otherwise
score2(_, _, _, _, S, _):- 
    S is 0.

