?- consult(board).
?- consult(facts).

% heuristic1(B, V).

% heuristic(B, M, V) :- setof([C, L], (in_board(C, L), win2(B, M, C, L)), _).

heuristic1(B, M, S) :-
    streak_sum(B, M, 0, 0, S).

streak_sum(B, M, 7, 5, 0).

streak_sum(B, M, 7, L, S) :- 
    NL is L + 1,
    streak_sum(B, M, 0, NL, S).

streak_sum(B, M, C, L, S) :- 
    streak(B, M, C, L, NS),
    NC is C + 1,
    streak_sum(B, M, NC, L, NNS),
    S is NS + NNS.


streak(B, M, C, L, S) :- 
    inverse_mark(M, IM),
    streak_val(B, M, C, L, 1, 0, S1),
    streak_val(B, M, C, L, 1, -1, S2),
    streak_val(B, M, C, L, 1, 1, S3),
    streak_val(B, M, C, L, 0, 1, S4),
    streak_val(B, IM, C, L, 1, 0, S5),
    streak_val(B, IM, C, L, 1, -1, S6),
    streak_val(B, IM, C, L, 1, 1, S7),
    streak_val(B, IM, C, L, 0, 1, S8),
    S is S1 + S2 + S3 + S4 - S5 - S6 - S7 - S8. 

streak_val(B, M, C, L, DC, DL, NS) :-
    (streak_nb(B, M, C, L, DC, DL, S, 0) ->
        NS is S;
        NS is 0
    ).

streak_nb(B, M, C, L, DC, DL, 0, 4).

streak_nb(B, M, C, L, DC, DL, 0, N) :-
    cell(B, C, L, V),
    inverse_mark(V, M), !.

streak_nb(B, M, C, L, DC, DL, T, N) :-
    in_board(C, L),
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
