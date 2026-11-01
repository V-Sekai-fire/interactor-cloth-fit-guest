// The garment fit term per SDF sample (kernels/fit/lean/Fit/FitEnergy.lean).
// Double precision: the guest is built with DOUBLE_PRECISION=ON and the
// solver state is double.
struct FitParams {
  uint n;
};
[[vk::binding(0, 0)]]
ConstantBuffer<FitParams> params;
// per sample: d, d0, area, weight
[[vk::binding(1, 0)]]
StructuredBuffer<double4> samples;
// per sample: value, dvalue/dd
[[vk::binding(2, 0)]]
RWStructuredBuffer<double2> outv;

[shader("compute")] [numthreads(64, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID) {
  uint i = tid.x;
  if (i >= params.n) { return; }
  double4 s = samples[i];
  double r = s.x - s.y;
  if (r > 0.0) {
    outv[i] = double2(s.z * s.w * r * r, 2.0 * s.z * s.w * r);
  } else {
    outv[i] = double2(0.0, 0.0);
  }
}
