part of game;

class ProblemDescription {
  var json;
  int id;

  List<Unit> units;
  int width;
  int height;

  List<Point> filled;

  int sourceLength;
  List<int> sourceSeeds;

  Point _toPoint(Map<String, int> pointJson) {
    return new Point(pointJson['x'], pointJson['y']);
  }

  ProblemDescription.fromJson(var probJson) {
    json = probJson;
    id = probJson['id'];
    width = probJson['width'];
    height = probJson['height'];
    units = probJson['units'].map((unitJson) {
      var unit = new Unit();
      unit.pivot = _toPoint(unitJson['pivot']);
      unit.members = unitJson['members'].map(_toPoint).toList();
      unit.moveToStartPos(width);
      return unit;
    }).toList();
    sourceLength = probJson['sourceLength'];
    sourceSeeds = probJson['sourceSeeds'];
    filled = probJson['filled'].map(_toPoint).toList();
  }
}

class Problem {
  final ProblemDescription description;
  final int seed;
  List<int> unitIndexes;

  Problem(this.description, this.seed) {
    // calculate unitIndexes:
    // The Source

    // The order of the units in the source will be determined using a pseudo-random sequence of numbers, starting with
    // a given seed. The unit identified by a random number is obtained by indexing (starting from 0) into the field
    // units, after computing the modulo of the number and the length of field units. So, for example, if the
    // configuration contains 5 units, then the number 0 will refer to the first unit, while the number 7 will refer the
    // 3rd one (because 7 mod 5 is 2, which refers to the 3rd element).

    // The pseudo-random sequence of numbers will be computed from a given seed using a linear congruential generator
    // with the following parameters:

    // modulus:	2³²
    // multiplier:	1103515245
    // increment:	12345
    // The random number associated with a seed consists of bits 30..16 of that seed, where bit 0 is the least
    // significant bit. For example, here are the first 10 outputs for the sequence starting with seed 17:
    // 0,24107,16552,12125,9427,13152,21440,3383,6873,16117.
    unitIndexes = randoms(seed, 2 << 32, 1103515245, 12345)
        .map((r) => (r >> 16) & (2 << 14 - 1)) // use only bits 30..16  (i.e. 14 bits)
        .map((r) => r % description.units.length)
        .take(description.sourceLength)
        .toList(growable: false);
  }
}
