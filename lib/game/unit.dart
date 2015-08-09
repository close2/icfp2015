part of game;

final Matrix2 clockwiseRotationMatrix = new Matrix2.rotation(PI / 3);
final Matrix2 counterClockwiseRotationMatrix = new Matrix2.rotation(- PI / 3);

class Unit {
  List<Point> members;
  Point pivot;

  // move all members so that the unit coordiantes are correct to start on the board
  void moveToStartPos(int width) {
    var first = members.first;

    var minX = members.fold(first.x, (prev, m) => min(prev, m.x));
    var maxX = members.fold(first.x, (prev, m) => max(prev, m.x));

    var unitWidth = maxX - minX + 1;
    var startX = (width - unitWidth) ~/ 2; // this would be the startX if minX of unit was 0
    var offsetX = startX - minX;

    var offsetY = members.fold(first.y, (prev, m) => min(prev, m.y));

    if (offsetX != 0 || offsetY != 0) {
      members = members.map((m) => new Point(m.x - offsetX, m.y - offsetY)).toList(growable: false);
      pivot = new Point(pivot.x - offsetX, pivot.y - offsetY);
    }
  }

  Point _movePoint(Point p, String command) {
    int x = p.x;
    int y = p.y;
    switch(command) {
      case '←':
        return new Point(x - 1, y);
      case '→':
        return new Point(x + 1, y);
      case '↙':
        return new Point(y.isEven ? x - 1 : x, y + 1);
      case '↘':
        return new Point(y.isEven ? x : x + 1, y + 1);
      default:
        return p;
    }
  }


  /// converts a point into a gridPosition
  /// rotates the direction vector from pivot to the point with a rotation matrix
  /// finally converts the newly calculated position back to a hexagon grid position.
  Point _rotatePoint(Point p, Point pivot, String command) {
    int x = p.x;
    int y = p.y;
    var gridP = hexGridToPos(p);
    log.info('P (${x}, ${y}) became (${gridP.x}, ${gridP.y})');

    int pivotX = pivot.x;
    int pivotY = pivot.y;

    var gridPivot = hexGridToPos(pivot);
    log.info('GridPivot (${pivotX}, ${pivotY}) became (${gridPivot.x}, ${gridPivot.y})');

    var dir = new Vector2((gridP.x - gridPivot.x).toDouble(), (gridP.y - gridPivot.y).toDouble()); // directional vector from pivot to p
    log.info('Dir Vecotor: (${dir.x}, ${dir.y})');

    Vector2 newDir;
    switch(command) {
      case '↺':
        newDir = counterClockwiseRotationMatrix.transform(dir);
        break;
      case '↻':
        newDir = clockwiseRotationMatrix.transform(dir);
        break;
      default:
        newDir = dir;
    }
    log.info('Rotated Dir Vector: (${newDir.x}, ${newDir.y})');
    var newGridP = new Point(gridPivot.x + newDir.x, gridPivot.y + newDir.y);
    Point<int> newP = posToHexGrid(newGridP);

    log.info('new Grid: (${newGridP.x}, ${newGridP.y}) P: (${newP.x}, ${newP.y})');

    return newP;
  }

  Unit();

  Unit.fromUnit(Unit otherUnit, {String command: null}) {
    switch(command) {
      case '←':
      case '→':
      case '↙':
      case '↘':
        pivot = _movePoint(otherUnit.pivot, command);
        members = otherUnit.members.map((p) => _movePoint(p, command)).toList(growable: false);
        break;
      case '↺':
      case '↻':
        pivot = otherUnit.pivot;
        members = otherUnit.members.map((p) => _rotatePoint(p, pivot, command)).toList(growable: false);
        break;
      default:
        pivot = otherUnit.pivot;
        members = otherUnit.members.toList(growable: false);
    }
  }
}

