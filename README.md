# interactor-cloth-fit-guest

The cloth-fit stage as a godot-sandbox guest whose compute runs on the GPU: a garment is retargeted onto a new body without intersections.

## What it is for

It takes the SIGGRAPH 2025 garment-retargeting method (`sinew-mocap/solve`, `core/cloth-fit`, a trimmed PolyFEM fork) and rebuilds its solver as kernels authored in Lean, lowered through Slang to SPIR-V, and driven from a riscv64 guest through `contract-ggml-rd` and `contract-guest-runtime`.

## No CPU path, no fallback

There is no CPU solver in this repository and none may be added, and nothing falls back: a missing GPU, kernel or buffer crashes the guest with a named error, as in Erlang. See [BLOCKLIST.md](BLOCKLIST.md). The reference for what the kernels must compute is the PolyFEM code in `core/cloth-fit`, run outside the guest as a test oracle only.

## Status

Scaffold plus one kernel. `kernels/fit/` holds the per-sample garment fit term of `FitForm` (`value` and `dvalue/dd` at `power = 2`): a Lean specification, a LeanSlang shader module that emits the double-precision Slang compute kernel, and `tools/test_fit.sh`, which checks the Lean values against a C++ oracle of the PolyFEM formula on six vectors (with a planted wrong value that must be caught) and compiles the kernel to SPIR-V that `spirv-val` accepts. The Slang kernel is emitted from a Lean module through LeanSlang (`lake exe emit_fit`), and the test fails when the committed file differs from the emit. The kernel has not run on a GPU yet and the guest is not written. Next: the contact barrier, then the guest that dispatches these kernels through ggml-rd.

## Build

The guest builds against `repository-riscv64-sysroot` (`pixi run verify` and `pixi run smoke` there) and the sibling checkouts `contract-guest-runtime`, `contract-ggml-rd` and `contract-guest-common`. Build with `-DDOUBLE_PRECISION=ON` and check `llvm-objdump -s -j .sandbox_variant` reads `SBXV 28000000`.

## Check

    sh tools/check_no_cpu.sh --self-test
    sh tools/check_no_cpu.sh

## Licence

MIT. See [LICENSE](LICENSE). The cloth-fit method is by Huang et al. (SIGGRAPH 2025); see `CITATION.cff`.
