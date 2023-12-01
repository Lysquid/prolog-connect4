?- consult(board).
?- consult(facts).

heuristic1(B, M, S, P) :-
    streak_sum(B, M, 0, 0, S, P).

streak_sum(B, M, 7, 5, 0, P).

streak_sum(B, M, 7, L, S, P) :- 
    NL is L + 1,
    streak_sum(B, M, 0, NL, S, P).

streak_sum(B, M, C, L, S, P) :- 
    streak(B, M, C, L, NS, P),
    NC is C + 1,
    streak_sum(B, M, NC, L, NNS, P),
    S is NS + NNS.


streak(B, M, C, L, S, P) :- 
    inverse_mark(M, IM),
    streak_val(B, M, C, L, 1, 0, S1),
    streak_val(B, M, C, L, 1, -1, S2),
    streak_val(B, M, C, L, 1, 1, S3),
    streak_val(B, M, C, L, 0, 1, S4),
    streak_val(B, IM, C, L, 1, 0, S5),
    streak_val(B, IM, C, L, 1, -1, S6),
    streak_val(B, IM, C, L, 1, 1, S7),
    streak_val(B, IM, C, L, 0, 1, S8),
    S is S1**P + S2**P + S3**P + S4**P - S5**P - S6**P - S7**P - S8**P. 

streak_val(B, M, C, L, DC, DL, NS) :-
    (streak_nb(B, M, C, L, DC, DL, S, 0) ->
        NS is S;
        NS is 0
    ).

streak_nb(B, M, C, L, DC, DL, 0, 4).

streak_nb(B, M, C, L, DC, DL, T, N) :-
    in_board(C, L),
    cell(B, C, L, V),
    not(inverse_mark(M, V)),
    NC is C + DC,
    NL is L + DL,
    NN is N+1,
    streak_nb(B, M, NC, NL, DC, DL, NT, NN),
    streak_nb2(B, M, C, L, T, NT).

streak_nb2(B, M, C, L, T, NT) :-
    cell(B, C, L, M),
    T is NT+1.

streak_nb2(B, M, C, L, NT, NT) :-
    cell(B, C, L, V),
    blank_mark(V).
