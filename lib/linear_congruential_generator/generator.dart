library linearCongruentialGenerator;

Iterable randoms(int seed, int modulus, int multiplier, int increment) sync* {
  int random = seed;
  yield random;
  while (true) {
    random = (random * multiplier + increment) % modulus;
    yield random;
  }
}