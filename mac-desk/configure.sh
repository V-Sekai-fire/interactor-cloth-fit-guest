#!/bin/sh
# Configure and build PolyFEM_bin from the workspace's vendored cloth-fit, out of tree.
set -eu
export GIT_CONFIG_GLOBAL=/dev/null GIT_TERMINAL_PROMPT=0
SRC=/Users/ernest.lee/Documents/meshing-pen/3-interactor/garment-fit/vendor/cloth-fit
cmake -S "$SRC" -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
  -DPOLYSOLVE_WITH_CHOLMOD=OFF -DPOLYSOLVE_WITH_MKL=OFF -DUSE_BLOSC=OFF -DUSE_ZLIB=OFF \
  -DCMAKE_PREFIX_PATH="$CONDA_PREFIX" \
  -DCMAKE_CXX_COMPILER_LAUNCHER=$PWD/cxx_launcher.sh -DFIT_KERNELS_DIR=/Users/ernest.lee/Documents/meshing-pen/3-interactor/garment-fit/kernels/fit/cpp \
  -DFIT_SLANG_PRELUDE_DIR=/Users/ernest.lee/Documents/meshing-pen/2-contract/guest-runtime/guest/avbd/slang-rt
cmake --build build --target PolyFEM_bin
