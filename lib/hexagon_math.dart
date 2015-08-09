library hexagonMath;

import 'dart:math';
import 'package:logging/logging.dart' show Logger;

final Logger log = new Logger('hexagonMath');

// simply assume a hexagon has a border length of 2
// i.e. R == 2

// http://blog.ruslans.com/2011/02/hexagonal-grid-math.html

// H = √3 * R
// W = 2 * R
// S = 1½ R

const _R = 2;
final _H = _R * sqrt(3);
final _H2 = (_R * sqrt(3))/2;
final _S = 1.5 * _R;
final _W = 2 * _R;


Point<double> hexGridToPos(Point<int> p) {
  double x = p.x * _S;
  double y = p.y * _H + (p.x % 2) * _H2;
  return new Point(x, y);
}

Point<int> posToHexGrid(Point<double> pos) {
  double hexX = pos.x / _S;
  int x = hexX.round();
  double hexY = (pos.y - (x % 2) * _H2) / _H;
  int y = hexY.round();
  log.info('Converted pos (${pos.x}, ${pos.y}) to ($hexX, $hexY) → ($x, $y)');
  return new Point(x, y);
}