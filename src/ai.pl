?- consult(board).
?- consult(utilities).
?- consult(facts).
?- consult(heurisitc1).

test_board( [
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, o, e, e, e, e, e,
    o, x, x, x, e, e, e
]
).
possible_moves(B, L) :- findall(C, (in_board(C, 0), column_is_not_full(B, C)), L).

minmax(D, B, M, S, U) :- Al is -inf, Be is inf, minmax2(D, B, M, S, U, Al, Be).


minmax2(D, B, M, S, U, Al, Be) :- 
    win(B, M),
    minmax2_win(M, D, S, U).

minmax2(D, B, M, S, U, Al, Be) :- 
    win(B, opponent_mark(M)),
    minmax2_win(M, D, S, U).

minmax2_win(M, D, S, U) :-
    minimizing(M),
    U is -100 - D.

minmax2_win(M, D, S, U) :-
    maximizing(M),
    U is 100 + D.

minmax2_lose(M, D, S, U) :-
    minimizing(M),
    U is 100 + D.

minmax2_lose(M, D, S, U) :-
    maximizing(M),
    U is -100 - D.

minmax2(0, B, M, S, U, Al, Be) :- utility(B, U).

minmax2(D, B, M, S, U, Al, Be) :- 
    D2 is D - 1,
    possible_moves(B, MVS),
    !,
    best(D2, B, M, MVS, S, U, Al, Be), !.

minmax2(_, B, _, _, U, _, _) :- utility(B, U).

%.......................................
% best
%.......................................
% determines the best move in a given list of moves by recursively calling minimax
%
best(D,B,M,[S1],S,U,Al,Be) :- 
    move(B, S1, M, B2),
    inverse_mark(M, M2),
    !,
    minmax2(D, B2, M2, _, U, Al, Be),
    S1 = S, !.

best(D,B,M,[S1 | T],S,U,Al,Be) :- 
    move(B, S1, M, B2),
    inverse_mark(M, M2),
    !,
    minmax2(D, B2, M2, _, U1, Al, Be),
    prune_or_continue_best(D, B, M, S1, U1, T, S, U, Al, Be).

prune_or_continue_best(D, B, M, S1, U1, T, S, U, Al, Be) :- %prune1
    minimizing(M),
    Al > U1,
    prune(M, Al, U1),
    S = S1,
    U = U1.

prune_or_continue_best(D, B, M, S1, U1, T, S, U, Al, Be) :-  %prune2
    maximizing(M),
    Be < U1,
    prune(M, Be, U1),
    S = S1,
    U = U1.

prune(_, _, _).

prune_or_continue_best(D, B, M, S1, U1, T, S, U, Al, Be) :- %continue
    maximizing(M),
    NAl is max(Al, U1),
    best(D, B, M, T, S2, U2, NAl, Be),
    better(M, S1, U1, S2, U2, S, U).

prune_or_continue_best(D, B, M, S1, U1, T, S, U, Al, Be) :- %continue
    minimizing(M),
    NBe is min(Be, U1),
    best(D, B, M, T, S2, U2, Al, NBe),
    better(M, S1, U1, S2, U2, S, U).

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

better2(M, R, S1, U1, S2, U2, S, U) :- %random
    R < 5,
    S = S1,
    U = U1, !.

better2(M, R, S1, U1, S2, U2, S, U) :- %random
    S = S2,
    U = U2, !.

better(M, _S1, _U1, S2, U2, S, U) :- %otherwise
    S = S2,
    U = U2, !.



utility(B, U) :- heuristic1(B, x, U).
