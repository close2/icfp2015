library engine;

import 'dart:math' show Point, max;
import 'game.dart';

import 'package:logging/logging.dart' show Logger;

final Logger log = new Logger('engine');

class BoardState {
  int score;
  int ls_old; // lines cleared with previous unit
  int sourceIndex;
  Unit currentUnit;
  Board board;

  BoardState(this.score, this.sourceIndex, this.currentUnit, this.board, [this.ls_old = 0]);
}

class Board {
  final width;
  final height;

  List<int> cells;

  Board(this.width, this.height) {
    cells = new List(width * height);
  }

  Board.fromBoard(Board otherBoard) {
    width = otherBoard.width;
    height = otherBoard.height;
    cells = otherBoard.cells.toList();
  }

  int getCell(int x, int y) => cells[x * width + y];
  void setCell(int x, int y, int val) {
    cells[x * width + y] = val;
  }
}

bool isUnitPlacementValid(Board board, Unit unit) {
  // FIXME
  return true;
}

BoardState startState(Problem problem) {
  var desc = problem.description;
  var board = new Board(desc.width, desc.height);

  for (var cell in desc.filled) board.setCell(cell.x, cell.y, -1);

  var firstIndex = problem.unitIndexes.first;
  var firstUnit = problem.description.units[firstIndex];
  var bs = new BoardState(0, firstIndex, new Unit.fromUnit(firstUnit), board);
  if (!isUnitPlacementValid(board, bs.currentUnit)) {
    bs.currentUnit = null;
  }
  return bs;
}

BoardState executeCommandsFromStart(Problem problem, String commands,
    {bool reuseBoard: false}) {
  var state = startState(problem);
  for (int i = 0; i < commands.length; i++) state =
      executeCommand(problem, state, commands[i], reuseBoard: reuseBoard);
  return state;
}

BoardState executeCommand(Problem problem, BoardState prevState, String command,
    {bool reuseBoard: false}) {
  var board = prevState.board;
  if (!reuseBoard) board = new Board.fromBoard(board);

  var oldCurrentUnit = prevState.currentUnit;
  if (oldCurrentUnit == null) {
    // previous error
    return new BoardState(0, prevState.sourceIndex, null, board);
  }

  Unit newCurrentUnit = new Unit.fromUnit(oldCurrentUnit, command: command);

  return new BoardState(0, 0, newCurrentUnit, board, 0);
}
