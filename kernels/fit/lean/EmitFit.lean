import LeanSlang
import Fit

/-- `lake exe emit_fit <dir>` writes the fit kernel as `<dir>/fit_energy.slang`. -/
def main (args : List String) : IO UInt32 := do
  let outDir := args.headD "."
  IO.FS.createDirAll outDir
  let path := outDir ++ "/fit_energy.slang"
  IO.FS.writeFile path (LeanSlang.emit Fit.FitShader.shader ++ "\n")
  IO.println s!"wrote {path}"
  return 0
