import 'package:icfp2015/linear_congruential_generator/generator.dart';

void main() {
  randoms(17, 2<<32, 1103515245, 12345)
      .map((r) => (r >> 16) & ((2 << 14) - 1))
      .take(20)
      .forEach(print);
}
