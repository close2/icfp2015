import 'dart:math' show Point;

import 'package:icfp2015/game/game.dart';
import 'package:logging/logging.dart' show Logger, Level, LogRecord;

void main() {
  // Set up logger.
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  var u = new Unit();

  u.pivot = new Point(1, 4);

  List<Point> ms = new List();
  ms.add(new Point(0, 6));
  ms.add(new Point(2, 4));
  ms.add(new Point(3, 4));
  ms.add(new Point(4, 3));
  ms.add(new Point(3, 7));

  u.members = ms;

  print('U: ');
  u.members.forEach((p) => print(' ${p.x}, ${p.y}'));

  var u2 = new Unit.fromUnit(u, command: '↺');
  print('U2: ');
  u2.members.forEach((p) => print(' ${p.x}, ${p.y}'));

  var u3 = new Unit.fromUnit(u, command: '↻');
  print('U3: ');
  u3.members.forEach((p) => print(' ${p.x}, ${p.y}'));

  u3 = new Unit.fromUnit(u3, command: '↻');
  u3 = new Unit.fromUnit(u3, command: '↻');
  u3 = new Unit.fromUnit(u3, command: '↻');
  u3 = new Unit.fromUnit(u3, command: '↻');
  u3 = new Unit.fromUnit(u3, command: '↻');
  print('U3 rotated 6 times: ');
  u3.members.forEach((p) => print(' ${p.x}, ${p.y}'));


}