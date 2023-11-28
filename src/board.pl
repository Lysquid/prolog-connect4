example_board([
    e, e, e, e, e, e, e,
    e, e, e, e, x, e, e,
    e, e, x, x, o, e, e,
    e, e, o, x, o, e, e,
    e, x, o, o, o, e, e,
    e, x, o, x, x, o, x
]).

empty_board([
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e
]).

cell(B, C, L, M) :- 
    I is L * 7 + C,
    nth0(I, B, M).

win(B, M) :- win2(B, M, 0, 0).

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

win2(B, M, C, L) :- 
    C >= 0,
    L >= 0,
    C < 6,
    L < 6,
    NC is C + 1,
    win2(B, M, NC, L), !.

win2(B, M, C, L) :- 
    C >= 0,
    L >= 0,
    C = 6,
    L < 5,
    NL is L + 1,
    win2(B, M, 0, NL), !.

win3(_, _, _, _, _, _, N) :- N >= 4.
win3(B, M, C, L, DC, DL, N) :- 
    NC is C + DC,
    NL is L + DL,
    NC >= 0,
    NL >= 0,
    NC < 7,
    NL < 6,
    cell(B, NC, NL, M),
    NN is N + 1,
    win3(B, M, NC, NL, DC, DL, NN), !
    .
