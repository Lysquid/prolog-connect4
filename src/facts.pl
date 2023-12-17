% creates a blank board
initialize_board([
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e,
    e, e, e, e, e, e, e
]).

% determines the next player after the given player
next_player(1, 2).
next_player(2, 1).

% determines the opposite of the given mark
inverse_mark('x', 'o').
inverse_mark('o', 'x').

% the mark for the given player
player_mark(1, 'x').
player_mark(2, 'o').

% the character to use to render the player pieces
player_char(1, '○').
player_char(2, '●').

% shorthand for the inverse mark of the given player
opponent_mark(1, 'o').
opponent_mark(2, 'x').

% the mark used in an empty square
blank_mark('e').

maximizing('x').   % the player playing x is always trying to maximize the utility of the board position
minimizing('o').   % the player playing o is always trying to minimize the utility of the board position

% map corner squares to board squares
corner_square(1, 1).    
corner_square(2, 3).
corner_square(3, 7).
corner_square(4, 9).
