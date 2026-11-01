# What is denied, and why

## CPU compute

No solver, kernel fallback, thread pool or oracle for the cloth-fit stage runs on the CPU inside this guest.

Why: heavy compute for this stage runs on the GPU through ggml-rd, with kernels written in Lean and lowered through Slang to SPIR-V. A CPU path would be a second implementation of the same maths that can drift from the first, and it would hide a missing kernel behind a slow success.

Denied in `guest/` and `kernels/`:

- a ggml CPU backend (`ggml_backend_cpu`, `GGML_BACKEND_CPU`);
- threads and task libraries (`std::thread`, `std::async`, `pthread_create`, `tbb::`, `omp `, `#pragma omp`);
- a dense or sparse CPU solver (`Eigen::`, `SimplicialLDLT`, `SparseLU`, `polysolve`);
- a fallback of any kind (`fallback`, `cpu_fallback`, `CPU_FALLBACK`, `use_cpu`);
- swallowing a failure (`catch (...)`).

`tools/check_no_cpu.sh` enforces this and fails by file and line. The PolyFEM code in `sinew-mocap/solve` may run on the CPU outside this repository as a test oracle; it never enters the guest.

## Crash, do not fall back

The stage follows the Erlang policy: let it crash. When a kernel is missing, a pipeline fails to build, a buffer allocation fails, or the GPU is not there, the guest stops with an error that names the cause. It does not retry on another path, return a degraded result, or log and carry on. A supervisor above the guest decides whether to restart it. Code that handles an error only to hide it is denied the same as a CPU path.
