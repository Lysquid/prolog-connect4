example_board([
    e, e, e, e, e, e, e,
    e, e, e, e, x, e, e,
    e, e, x, x, o, e, e,
    e, e, x, x, o, e, e,
    e, x, o, o, o, e, e,
    e, x, o, x, e, o, x
]).

empty_board([
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e
]).

in_board(C, L) :-
    between(0, 6, C),
    between(0, 5, L).
    
cell(B, C, L, M) :- 
    I is L * 7 + C,
    nth0(I, B, M).

win(B, M) :- setof([C, L], (in_board(C, L), win2(B, M, C, L)), _).

win2(B, M, C, L) :- 
    C >= 0,
    L >= 0,
    C < 7,
    L < 6,
    cell(B, C, L, M),
    (
        win3(B, M, C, L, 1, 0, 1) ; 
        win3(B, M, C, L, 1, -1, 1) ;
        win3(B, M, C, L, 1, 1, 1) ;
        win3(B, M, C, L, 0, 1, 1) 
    ), !.

win3(_, _, _, _, _, _, N) :- N >= 4.
win3(B, M, C, L, DC, DL, N) :- 
    NC is C + DC,
    NL is L + DL,
    in_board(NC, NL),
    cell(B, NC, NL, M),
    NN is N + 1,
    win3(B, M, NC, NL, DC, DL, NN), !
    .
