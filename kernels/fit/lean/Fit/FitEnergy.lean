/-!
# `Fit.FitEnergy`: the garment fit term, per SDF sample

Specification of the per-sample term of `FitForm` in `sinew-mocap/solve`
`core/cloth-fit/src/polyfem/solver/forms/garment_forms/FitForm.cpp`
(`value_unweighted` line 151, `first_derivative_unweighted` line 178), with
`power = 2`.

For one sample with signed distance `d` to the avatar, rest distance `d0`,
the face area `a` and the quadrature weight `w`:

    value = a * w * (d - d0)^2        if d > d0, else 0
    dvalue/dd = 2 * a * w * (d - d0)  if d > d0, else 0

The gradient with respect to a vertex is `dvalue/dd` times the SDF gradient
times the sample's barycentric weight; that chain stays in the guest.
-/
namespace Fit

def value (d d0 a w : Float) : Float :=
  if d > d0 then a * w * (d - d0) * (d - d0) else 0.0

def dvalue (d d0 a w : Float) : Float :=
  if d > d0 then 2.0 * a * w * (d - d0) else 0.0

end Fit
