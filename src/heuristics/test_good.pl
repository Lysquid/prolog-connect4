?- consult(good).
?- consult('../ai').
?- consult('../test_boards').

% tests the good heuristic on different board configurations
% where its value has been calculated by hand
test :-

    good_heuristic([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e
    ], x, 0, 2),


    good_heuristic([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, x, e, e, e
    ], x, 7, 2),

    good_heuristic([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        x, e, e, e, e, e, e
    ], x, 3, 2),

    good_heuristic([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, x
    ], x, 3, 2),

    good_heuristic([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, o, e, e, e,
        e, e, e, x, e, e, e
    ], x, -3, 2),

    good_heuristic([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        x, e, e, x, e, e, e
    ], x, 10, 1),

    good_heuristic([
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        e, e, e, e, e, e, e,
        x, e, e, x, e, e, e
    ], x, 12, 2),

    test_board1(B),
    good_heuristic(B, x, 28, 2)
    .


% times a minmax evalution with the good heuristic on a empty board
% (used to try to optimize the speed of the heuristic)
time :-
    statistics(runtime, [Start|_]),
    empty_board(B),
	minmax(good_heuristic, 4, B, x, S, U),
    statistics(runtime, [End|_]),
    Runtime is End - Start,
    format('Runtime: ~3d ms (Move: ~d, Utility: ~2f)', [Runtime, S, U])
    .

