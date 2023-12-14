?- consult('../board').
?- consult('../facts').

bad_heuristic(B, M, S, P) :-
    score(B, M, 0, 0, S, P).

score(_, _, 7, 5, 0, _).

score(B, M, 7, L, S, P) :- 
    NL is L + 1,
    score(B, M, 0, NL, S, P).

score(B, M, C, L, S, P) :- 
    score2(B, M, C, L, NS, P),
    NC is C + 1,
    score(B, M, NC, L, NNS, P),
    S is NS + NNS.

score2(B, M, C, L, S, _):- 
    cell(B, C, L, V),
    not(inverse_mark(M, V)),
    not(blank_mark(V)),
    S is (30-(C-3)*(C-3)-L*3)/10.

score2(B, M, C, L, S, _):- 
    cell(B, C, L, V),
    inverse_mark(M, V),
    not(blank_mark(V)),
    S is -(30-(C-3)*(C-3)-L*3)/10.

score2(_, _, _, _, S, _):- 
    S is 0.

