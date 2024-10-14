# Prolog Connect 4

[Connect 4](https://en.wikipedia.org/wiki/Connect_Four) game in [Prolog](https://en.wikipedia.org/wiki/Prolog), with an AI using the [minimax algorithm](https://en.wikipedia.org/wiki/Minimax). It was made by 7 people for a class on logic-based AI.

```
Computer ○ (good_heuristic) is thinking...

Computer ○ plays in column 5 (utility: 1).

  1   2   3   4   5   6   7
┌───┬───┬───┬───┬───┬───┬───┐
│   │   │   │   │ ○ │   │   │
├───┼───┼───┼───┼───┼───┼───┤
│   │   │ ○ │   │ ● │   │   │
├───┼───┼───┼───┼───┼───┼───┤
│   │   │ ● │   │ ○ │   │   │
├───┼───┼───┼───┼───┼───┼───┤
│ ● │   │ ○ │ ○ │ ● │   │   │
├───┼───┼───┼───┼───┼───┼───┤
│ ○ │   │ ● │ ● │ ○ │   │   │
├───┼───┼───┼───┼───┼───┼───┤
│ ● │   │ ○ │ ○ │ ● │   │   │
└───┴───┴───┴───┴───┴───┴───┘
  1   2   3   4   5   6   7

Player ● move?
```

## Prolog

Prolog is a logic programming language, which is very different from the programming languages we are used to. The programmer declares a set of facts and rules, and the Prolog engine then explores all the possibilities to find the satisfying combinations. As there is not really any control flow structure, the code is mostly composed of recursive rules/functions.

## Minimax algorithm

For a given state of the board, the minimax algorithm explores all the possibilities of the following moves, which correspond to a BFS search of a tree. Prolog, by its recursive nature, is a well suited language for this algorithm.

As the search space grows exponentially, it is not possible to explore all the moves until the end of the game. Therefore, the algorithm stops at a maximum depth and computes a score for each possible board, with a function called an heuristic. The algorithm then assumes that:

- when it plays, it will choose the move resulting in the best score (max)
- when its opponent plays, it will choose the move resulting in the worst score (min)

This way, it can rewind the possible moves to determine which move played now will maximize its score in the future. Crafting a good heuristic is crucial to achieve good performance, so we thought of multiple ones and ran a tournament to find the best one.

To improve the speed of the algorithm, we implemented techniques such as alpha-beta pruning. In the end, our algorithm can explore 4 or 5 moves ahead while providing an answer within a reasonable delay.

## Run the game

Install [SWI-Prolog](https://www.swi-prolog.org/Download.html) and run these commands:

```sh
cd src
swipl main.pl
run.
```
