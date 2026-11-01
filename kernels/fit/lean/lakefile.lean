import Lake
open Lake DSL

package Fit where

-- Pinned in a V-Sekai-fire repo, the same commit interactor-curvenet uses.
require LeanSlang from git
  "https://github.com/V-Sekai-fire/contract-lean-slang.git" @ "60532aef8ed70cc669ecab481182d0636c9e1ac3"

lean_lib Fit

lean_exe fit_vectors where
  root := `FitVectors

lean_exe emit_fit where
  root := `EmitFit
