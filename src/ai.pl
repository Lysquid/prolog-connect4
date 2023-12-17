?- consult(board).
?- consult(facts).
?- consult(heuristics/good).
?- consult(heuristics/bad).
?- consult(heuristics/no).


% computes the utility with the right heuristic
utility(good_heuristic, B, U) :- good_heuristic(B, x, U, 2).
utility(less_good_heuristic, B, U) :- good_heuristic(B, x, U, 1).
utility(bad_heuristic, B, U) :- bad_heuristic(B, x, U, 2).
utility(no_heuristic, B, U) :- no_heuristic(B, x, U, 2).


% minmax algorithm
minmax(Heuristic, D, B, M, S, U) :-
    Al is -inf,
    Be is inf,
    minmax2(Heuristic, D, B, M, S, U, Al, Be).

% a player is winning
minmax2(_, D, B, _, S, U, _, _) :- 
    win(B, AnyMark),
    minmax2_win(AnyMark, D, S, U).

% reaches bottom depth
minmax2(Heuristic, 0, B, _, _, U, _, _) :-
    utility(Heuristic, B, U).

% recursive general case
minmax2(Heuristic,D, B, M, S, U, Al, Be) :- 
    D2 is D - 1,
    possible_moves(B, Moves),
    best(Heuristic,D2, B, M, Moves, S, U, Al, Be), !.

% reaches the end of the game (no more possible moves)
minmax2(Heuristic, _, B, _, _, U, _, _) :-
    utility(Heuristic, B, U).


% when someone is winning, we give the board a very big utility instead of evaluating the heuristic
% we add the depth to play first the fastest winning moves
minmax2_win(M, D, _, U) :-
    minimizing(M),
    U is -100 - D.

minmax2_win(M, D, _, U) :-
    maximizing(M),
    U is 100 + D.



%.......................................
% best
%.......................................
% determines the best move in a given list of moves by recursively calling minimax
%
% Un seul coup possible -> on évalue ce coup avec minmax2.
best(Heuristic,D,B,M,[S1],S,U,Al,Be) :- 
    move(B, S1, M, B2),
    inverse_mark(M, M2),
    !,
    minmax2(Heuristic,D, B2, M2, _, U, Al, Be),
    S1 = S, !.

% Plusieurs coups possible -> On évalue le premier coup avec minmax2 puis on
% appel récursivement best sur les coups restant avant de les comparer avec le
% coup que l'on vient d'évaluer
best(Heuristic,D,B,M,[S1 | T],S,U,Al,Be) :- 
    move(B, S1, M, B2),
    inverse_mark(M, M2),
    !,
    minmax2(Heuristic,D, B2, M2, _, U1, Al, Be),
    prune_or_continue_best(Heuristic,D, B, M, S1, U1, T, S, U, Al, Be).

% Prédicat de debug fait uniquement pour être utilisé avec trace
prune(_, _, _).

prune_or_continue_best(_, _, _, M, S1, U1, _, S, U, Al, _) :- %Alpha prune
    minimizing(M),
    Al > U1,
    prune(M, Al, U1),
    S = S1,
    U = U1.

prune_or_continue_best(_, _, _, M, S1, U1, _, S, U, _, Be) :-  %Beta prune
    maximizing(M),
    Be < U1,
    prune(M, Be, U1),
    S = S1,
    U = U1.

prune_or_continue_best(Heuristic, D, B, M, S1, U1, T, S, U, Al, Be) :- %continue
    maximizing(M),
    NAl is max(Al, U1),
    best(Heuristic,D, B, M, T, S2, U2, NAl, Be),
    better(M, S1, U1, S2, U2, S, U).

prune_or_continue_best(Heuristic,D, B, M, S1, U1, T, S, U, Al, Be) :- %continue
    minimizing(M),
    NBe is min(Be, U1),
    best(Heuristic,D, B, M, T, S2, U2, Al, NBe),
    better(M, S1, U1, S2, U2, S, U).

%.......................................
% better
%.......................................
% Est vrai si et seulement si (S, U) représentent le meilleur coup entre 
% (S1, U1) et (S2, U2)
better(M, S1, U1, _S2, U2, S, U) :-
    maximizing(M),
    U1 > U2,
    S = S1,
    U = U1, !.

better(M, S1, U1, _S2, U2, S, U) :-
    minimizing(M),
    U1 < U2,
    S = S1,
    U = U1, !.

better(M, S1, U1, S2, U2, S, U) :- %random
    U1 == U2,
    R is random(10),
    better2(M, R, S1, U1, S2, U2, S, U).

better(_, _S1, _U1, S2, U2, S, U) :- %otherwise
    S = S2,
    U = U2, !.

better2(_, R, S1, U1, _, _, S, U) :- %random
    R < 5,
    S = S1,
    U = U1, !.

better2(_, _, _, _, S2, U2, S, U) :- %random
    S = S2,
    U = U2, !.
