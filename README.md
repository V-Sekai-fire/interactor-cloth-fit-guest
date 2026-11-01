# interactor-cloth-fit-guest

The cloth-fit stage as a godot-sandbox guest whose compute runs on the GPU: a garment is retargeted onto a new body without intersections.

## What it is for

It takes the SIGGRAPH 2025 garment-retargeting method (`sinew-mocap/solve`, `core/cloth-fit`, a trimmed PolyFEM fork) and rebuilds its solver as kernels authored in Lean, lowered through Slang to SPIR-V, and driven from a riscv64 guest through `contract-ggml-rd` and `contract-guest-runtime`.

## No CPU path, no fallback

There is no CPU solver in this repository and none may be added, and nothing falls back: a missing GPU, kernel or buffer crashes the guest with a named error, as in Erlang. See [BLOCKLIST.md](BLOCKLIST.md). The reference for what the kernels must compute is the PolyFEM code in `core/cloth-fit`, run outside the guest as a test oracle only.

## Status

Scaffold. The guest, the kernels and the Lean specifications are not written yet. The first kernels to write, from `core/cloth-fit/src/polyfem/garment/GarmentNLProblem.cpp` and `solver/forms`, are the garment energy terms and their gradient; the contact barrier follows.

## Build

The guest builds against `repository-riscv64-sysroot` (`pixi run verify` and `pixi run smoke` there) and the sibling checkouts `contract-guest-runtime`, `contract-ggml-rd` and `contract-guest-common`. Build with `-DDOUBLE_PRECISION=ON` and check `llvm-objdump -s -j .sandbox_variant` reads `SBXV 28000000`.

## Check

    sh tools/check_no_cpu.sh --self-test
    sh tools/check_no_cpu.sh

## Licence

MIT. See [LICENSE](LICENSE). The cloth-fit method is by Huang et al. (SIGGRAPH 2025); see `CITATION.cff`.
