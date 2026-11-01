// Test oracle only, never part of the guest: the formula of FitForm
// (FitForm.cpp lines 151 and 178, power = 2) on the same vectors as
// kernels/fit/lean/FitVectors.lean.
#include <cmath>
#include <cstdio>
int main() {
  const double v[][4] = {{1.0, 0.5, 2.0, 0.25}, {0.5, 1.0, 2.0, 0.25}, {0.5, 0.5, 1.0, 1.0},
                         {3.0, 0.25, 0.5, 0.125}, {-0.5, -1.0, 4.0, 0.5}, {0.0, 0.0, 1.0, 1.0}};
  const int power = 2;
  for (const auto &s : v) {
    const double d = s[0], d0 = s[1], a = s[2], w = s[3];
    double val = 0, g = 0;
    if (d > d0) {
      val = a * w * std::pow(d - d0, power);
      g = std::pow(d - d0, power - 1) * power * a * w;
    }
    std::printf("%.6f %.6f\n", val, g);
  }
}
