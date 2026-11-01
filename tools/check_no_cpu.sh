#!/bin/sh
# Fails when guest/ or kernels/ names a CPU compute path (BLOCKLIST.md).
# Usage: check_no_cpu.sh [--self-test] [root]
PAT='ggml_backend_cpu|GGML_BACKEND_CPU|std::thread|std::async|pthread_create|tbb::|#pragma omp|Eigen::|SimplicialLDLT|SparseLU|polysolve|cpu_fallback|CPU_FALLBACK|use_cpu'
scan() { grep -rnE "$PAT" "$1/guest" "$1/kernels" 2>/dev/null; }
if [ "$1" = "--self-test" ]; then
  t=$(mktemp -d) || exit 2
  mkdir -p "$t/guest" "$t/kernels"
  echo 'int main(){ return 0; }' > "$t/guest/ok.cpp"
  if scan "$t" >/dev/null; then echo "self-test: clean tree reported a hit"; rm -rf "$t"; exit 1; fi
  echo 'std::thread t;' > "$t/guest/bad.cpp"
  if ! scan "$t" >/dev/null; then echo "self-test: planted std::thread was not caught"; rm -rf "$t"; exit 1; fi
  rm -rf "$t"; echo "self-test ok: clean passes, planted CPU path fails"; exit 0
fi
root=${1:-$(dirname "$0")/..}
hits=$(scan "$root")
if [ -n "$hits" ]; then echo "$hits"; echo "CPU compute path found (BLOCKLIST.md)"; exit 1; fi
echo "no CPU compute path in guest/ or kernels/"
