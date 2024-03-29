?- consult('../board').
?- consult('../facts').

good_heuristic(B, M, S, P) :-
    streak_sum(B, M, 0, 0, S, P).

% streak_sum walks the board and calculate the heuristic at each position, 
% and sums the heuristics to get the heuristic for all the board

streak_sum(_, _, 7, 5, 0, _).

streak_sum(B, M, 7, L, S, P) :- 
    NL is L + 1,
    streak_sum(B, M, 0, NL, S, P).

streak_sum(B, M, C, L, S, P) :- 
    streak(B, M, C, L, NS, P),
    NC is C + 1,
    streak_sum(B, M, NC, L, NNS, P), !,
    S is NS + NNS.


% given a position C, L calculates the streak in each direction for the mark M 
% and the oppsotite mark IM and sums up all directions minus the IM score in all directions

streak(B, M, C, L, S, P) :- 
    inverse_mark(M, IM),
    streak_val(B, M, C, L, 1, 0, S1, P),
    streak_val(B, M, C, L, 1, -1, S2, P),
    streak_val(B, M, C, L, 1, 1, S3, P),
    streak_val(B, M, C, L, 0, 1, S4, P),
    streak_val(B, IM, C, L, 1, 0, S5, P),
    streak_val(B, IM, C, L, 1, -1, S6, P),
    streak_val(B, IM, C, L, 1, 1, S7, P),
    streak_val(B, IM, C, L, 0, 1, S8, P),
    S is S1 + S2 + S3 + S4 - S5 - S6 - S7 - S8.


% given a position and a direction, calculates the heuristic of the mark M

streak_val(_, _, C, L, DC, DL, 0, _) :-
    C1 is C + 3*DC,
    L1 is L + 3*DL,
    not(in_board(C1, L1)).

streak_val(B, M, C, L, DC, DL, S, P) :-
    streak_nb(B, M, C, L, DC, DL, S2, 0),
    S is S2**P.   % the streak length to the power of a constant P

streak_val(_, _, _, _, _, _, 0, _).


% walks the board in the direction given, stops if length 4 is reached or an inverse mark is found

streak_nb(_, _, _, _, _, _, 0, 4).

streak_nb(B, M, C, L, DC, DL, T, N) :-
    cell(B, C, L, V),
    not(inverse_mark(M, V)),
    NC is C + DC,
    NL is L + DL,
    NN is N+1,
    streak_nb(B, M, NC, NL, DC, DL, NT, NN),
    streak_nb2(B, M, C, L, T, NT).

% if the cell is ours, we add 1 to the streak length
streak_nb2(B, M, C, L, T, NT) :-
    cell(B, C, L, M),
    T is NT+1.

% if the cell is empty, we continue withoud adding 1
streak_nb2(B, _, C, L, NT, NT) :-
    cell(B, C, L, V),
    blank_mark(V).
