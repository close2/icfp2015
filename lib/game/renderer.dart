library gameRenderer;

import 'dart:html';
import 'dart:math' show PI;

import 'game.dart';

class GameDisplay {
  CanvasElement canvas;

  Problem problem;

  String commands;
  int commandIndex;

  GameDisplay(this.canvas) {
    commandIndex = null;
  }

  void requestRedraw() {
    window.requestAnimationFrame(draw);
  }

  void start() {
    requestRedraw();
  }

  void draw([_]) {
    var context = canvas.context2D;
    var width = canvas.width;
    var height = canvas.height;

    context.clearRect(0, 0, width, height);
    if (commandIndex == null) {
      context.fillText("Waiting for commands", 0, 50);
      context
        ..beginPath()
        ..arc(100, 100, 30, 0, PI * 2)
        ..fill()
        ..closePath();
    } else {
      //drawElements(context);
    }
    requestRedraw();
  }
}
