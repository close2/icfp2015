library game;

import 'dart:math' show Point, min, max, PI;
import 'package:icfp2015/linear_congruential_generator/generator.dart';
import 'package:icfp2015/hexagon_math.dart';

import 'package:vector_math/vector_math.dart';

import 'engine.dart';

import 'package:logging/logging.dart' show Logger;

part "problem.dart";
part "unit.dart";

final Logger log = new Logger('game');


class Game {
  final Problem problem;
  String _commands;
  BoardState boardState;

  Game(this.problem) {
    boardState = startState(problem);
    _commands = '';
  }

  BoardState addCommand(String c) {
    _commands += c;
    boardState = executeCommand(problem, boardState, c, reuseBoard: true);
    return boardState;
  }

  void setCommands(String commands) {
    _commands = commands;
    executeCommandsFromStart(problem, commands, reuseBoard: true);
  }
}