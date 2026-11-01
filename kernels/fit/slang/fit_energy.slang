struct FitParams {
  uint n;
};

[[vk::binding(0, 0)]]
ConstantBuffer<FitParams> params;
[[vk::binding(1, 0)]]
StructuredBuffer<double4> samples;
[[vk::binding(2, 0)]]
RWStructuredBuffer<double2> outv;

[shader("compute")] [numthreads(64, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID) {
  uint i = tid.x;
  if ((i >= params.n)) {
    return;
  }
  double4 s = samples[i];
  double r = (s.x - s.y);
  if ((r > 0.0L)) {
    outv[i] = double2((((s.z * s.w) * r) * r), (((2.0L * s.z) * s.w) * r));
  } else {
    outv[i] = double2(0.0L, 0.0L);
  }
}
