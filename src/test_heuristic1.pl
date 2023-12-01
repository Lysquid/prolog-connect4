?- consult(heuristic1).
?- consult(ai).

test :-

    heuristic1([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e
    ], x, 0, 2),


    heuristic1([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, x, e, e, e
    ], x, 7, 2),

    heuristic1([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        x, e, e, e, e, e, e
    ], x, 3, 2),

    heuristic1([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, x
    ], x, 3, 2),

    heuristic1([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, o, e, e, e,
        e, e, e, x, e, e, e
    ], x, -3, 2),

    heuristic1([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        x, e, e, x, e, e, e
    ], x, 10, 1),

    heuristic1([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        x, e, e, x, e, e, e
    ], x, 12, 2),

    example_board(B),
    heuristic1(B, x, 28, 2)
    .


time :-
    statistics(runtime, [Start|_]),
    empty_board(B),
	minmax(4, B, x, S, U),
    statistics(runtime, [End|_]),
    Runtime is End - Start,
    format('Runtime: ~3d ms (Move: ~d, Utility: ~2f)', [Runtime, S, U])
    .

