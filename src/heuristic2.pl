?- consult(board).
?- consult(facts).

heuristic2(B, M, S, P) :-
    score(B, M, 0, 0, S, P).
score(B, M, 7, 5, 0, P).

score(B, M, 7, L, S, P) :- 
    NL is L + 1,
    score(B, M, 0, NL, S, P).

score(B, M, C, L, S, P) :- 
    score2(B, M, C, L, NS, P),
    NC is C + 1,
    score(B, M, NC, L, NNS, P),
    S is NS + NNS.
score2(B, M, C, L, S, P):- 
    cell(B, C, L, V),
    not(inverse_mark(M, V)),
    not(blank_mark(V)),
    S is (30-(C-3)*(C-3)-L*3)/10.
score2(B, M, C, L, S, P):- 
    S is 0.

