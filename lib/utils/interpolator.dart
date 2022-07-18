import 'dart:math';

abstract class Interpolator {
  num interpolate(num x);
}

class FocusedInterpolator extends Interpolator {
  num min;
  num max;
  double scale;

  FocusedInterpolator(this.min, this.max, this.scale) : super();

  @override
  num interpolate(num x) {
    if (x < 0) {
      x = -x;
    }
    double ratio = 1 / (pow(x / scale, 3) + 1);
    return ratio * (max - min) + min;
  }
}

class MagneticInterpolator extends Interpolator {
  double assimilate;
  double slope;

  MagneticInterpolator(this.assimilate, this.slope) : super();

  @override
  num interpolate(num x) {
    bool negative = false;
    if (x < 0) {
      x = -x;
      negative = true;
    }

    double ratio = (x - assimilate) / (1 - assimilate);

    if (ratio < 0) {
      ratio = 0;
    }
    if (ratio > 1) {
      ratio = 1;
    }

    num linear = (x - 1) * slope + 1;
    num value = pow(x, 3) * (1 - ratio) + linear * ratio;

    if (negative) {
      value = -value;
    }

    return value;
  }
}
