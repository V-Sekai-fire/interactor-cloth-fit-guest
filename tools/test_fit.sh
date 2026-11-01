#!/bin/sh
# Lean spec vs the PolyFEM formula, and the Slang kernel compiles to valid SPIR-V.
# Needs lake, c++, slangc, spirv-val. Run from the repository root.
set -e
t=$(mktemp -d)
c++ -O1 -o "$t/oracle" tools/fit_oracle.cpp
"$t/oracle" > "$t/cpp.txt"
(cd kernels/fit/lean && lake build >/dev/null && lake exe fit_vectors) > "$t/lean.txt"
paste "$t/cpp.txt" "$t/lean.txt" | awk '{ n++; if ($1-$3 > 1e-6 || $3-$1 > 1e-6 || $2-$4 > 1e-6 || $4-$2 > 1e-6) { print "MISMATCH line " n ": " $0; bad=1 } } END { if (bad) exit 1; print "lean == c++ oracle on " n " vectors" }'
# control: a wrong spec must be caught
sed 's/^0.0/0.0/' "$t/lean.txt" | awk 'NR==1{$1=$1+1}1' > "$t/wrong.txt"
if paste "$t/cpp.txt" "$t/wrong.txt" | awk '{ if ($1-$3 > 1e-6 || $3-$1 > 1e-6) exit 1 }'; then echo "control failed: a wrong value passed"; exit 1; fi
echo "control ok: a wrong value is caught"
slangc kernels/fit/slang/fit_energy.slang -target spirv -entry main -stage compute -o "$t/fit_energy.spv"
spirv-val "$t/fit_energy.spv" && echo "fit_energy.spv valid ($(wc -c < "$t/fit_energy.spv") bytes)"
rm -rf "$t"
