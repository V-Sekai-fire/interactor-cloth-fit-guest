# What is denied, and why

## CPU compute

No solver, kernel fallback, thread pool or oracle for the cloth-fit stage runs on the CPU inside this guest.

Why: heavy compute for this stage runs on the GPU through ggml-rd, with kernels written in Lean and lowered through Slang to SPIR-V. A CPU path would be a second implementation of the same maths that can drift from the first, and it would hide a missing kernel behind a slow success.

Denied in `guest/` and `kernels/`:

- a ggml CPU backend (`ggml_backend_cpu`, `GGML_BACKEND_CPU`);
- threads and task libraries (`std::thread`, `std::async`, `pthread_create`, `tbb::`, `omp `, `#pragma omp`);
- a dense or sparse CPU solver (`Eigen::`, `SimplicialLDLT`, `SparseLU`, `polysolve`);
- a CPU fallback switch (`cpu_fallback`, `CPU_FALLBACK`, `use_cpu`).

`tools/check_no_cpu.sh` enforces this and fails by file and line. The PolyFEM code in `sinew-mocap/solve` may run on the CPU outside this repository as a test oracle; it never enters the guest.
