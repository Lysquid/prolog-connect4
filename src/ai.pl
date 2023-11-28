?- consult(board).
?- consult(utilities).
?- consult(facts).

possible_moves(B, L) :- findall(C, (in_board(C, 0), column_is_not_full(B, C)), L).

minmax(0, B, M, S, U) :- utility(B, U).
minmax(D, B, M, S, U) :- 
    D2 is D - 1,
    possible_moves(B, MVS),
    !,
    best(D2, B, M, MVS, S, U), !.

minmax(_, B, _, _, U) :- utility(B, U).

%.......................................
% best
%.......................................
% determines the best move in a given list of moves by recursively calling minimax
%
best(D,B,M,[S1],S,U) :- 
    move(B, S1, M, B2),
    inverse_mark(M, M2),
    !,
    minmax(D, B2, M2, _, U),
    S1 = S, !.

best(D,B,M,[S1 | T],S,U) :- 
    move(B, S1, M, B2),
    inverse_mark(M, M2),
    !,
    minmax(D, B2, M2, _, U1),
    best(D, B, M, T, S2, U2),
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



utility(B, U) :- 
    win(B, x),
    U = 100,
    !.

utility(B, U) :- 
    win(B, o),
    U = -100,
    !.

utility(_, 0).
