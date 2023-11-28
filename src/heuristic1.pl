?- consult(board).
?- consult(facts).

% heuristic1(B, V).

win(B, M) :- setof([C, L], (in_board(C, L), win2(B, M, C, L)), _).

streak(B, M, C, L, S) :- 
    C >= 0,
    L >= 0,
    C < 7,
    L < 6,
    cell(B, C, L, M),
    (
        streakLength(B, M, C, L, 1, 0, 1) ; 
        streakLength(B, M, C, L, 1, -1, 1) ;
        streakLength(B, M, C, L, 1, 1, 1) ;
        streakLength(B, M, C, L, 0, 1, 1) 
    ), !.

validStart(B, M, C, L, DC, DL) :-
    NC is C - DC,
    NL is L - DL,
    (
        not(in_board(NC, NL));
        not(cell(B, NC, NL, M))    
    ).

% last cell is free
streakLength(B, M, C, L, DC, DL, 0) :-     
    NC is C + DC,
    NL is L + DL,
    in_board(NC, NL),
    cell(B, NC, NL, V),
    blank_mark(V),
    !.

streakLength(B, M, C, L, DC, DL, N) :-
    NC is C + DC,
    NL is L + DL,
    in_board(NC, NL),
    cell(B, NC ,NL, M),
    streakLength(B, M, NC, NL, DC, DL, NN),
    N is NN + 1.
