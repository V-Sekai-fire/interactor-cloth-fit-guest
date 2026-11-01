import LeanSlang

/-!
# `Fit.FitShader`: `Fit.FitEnergy` as a Slang compute kernel

The same term as `Fit.value` and `Fit.dvalue`, written in the LeanSlang AST
and emitted by `lake exe emit_fit`. `kernels/fit/slang/fit_energy.slang` is
that output; `tools/test_fit.sh` regenerates it and fails when the committed
file differs.

## Bindings (set 0)

    0  ConstantBuffer<FitParams>        n
    1  StructuredBuffer<double4>        samples   d, d0, area, weight
    2  RWStructuredBuffer<double2>      outv      value, dvalue/dd
-/
namespace Fit.FitShader
open LeanSlang

private def d1 : SlangType := .scalar .double
private def d2 : SlangType := .vec .double 2
private def d4 : SlangType := .vec .double 4
private def u1 : SlangType := .scalar .uint

private def paramsStruct : SlangStructDecl :=
  { name := "FitParams"
  , fields := [ ⟨"n", u1, Semantic.none, none, none, .qIn⟩ ] }

private def globals : List SlangBinding :=
  [ ⟨"params",  .const "FitParams", Semantic.none, some 0, some 0, .qIn⟩
  , ⟨"samples", .roBuf d4,          Semantic.none, some 1, some 0, .qIn⟩
  , ⟨"outv",    .rwBuf d2,          Semantic.none, some 2, some 0, .qIn⟩ ]

private def mainEntry : SlangFunctionDecl :=
  { attrs  := [.shaderCompute, .numthreads 64 1 1]
  , name   := "main"
  , params := [⟨"tid", .vec .uint 3, .svDispatchThreadId, none, none, .qIn⟩]
  , body   :=
      let i   := SlangExpr.var "i"
      let s   := SlangExpr.var "s"
      let r   := SlangExpr.var "r"
      let lit (v : Float) := SlangExpr.litDoubleExact v
      let out := SlangExpr.index (.var "outv") i
      [ .declInit u1 "i" (.member (.var "tid") "x")
      , .ifThen (.bin ">=" i (.member (.var "params") "n")) [.ret none] []
      , .declInit d4 "s" (.index (.var "samples") i)
      , .declInit d1 "r" (.bin "-" (.member s "x") (.member s "y"))
      , .ifThen (.bin ">" r (lit 0.0))
          [ .assign out (.call "double2"
              [ .bin "*" (.bin "*" (.bin "*" (.member s "z") (.member s "w")) r) r
              , .bin "*" (.bin "*" (.bin "*" (lit 2.0) (.member s "z")) (.member s "w")) r ]) ]
          [ .assign out (.call "double2" [lit 0.0, lit 0.0]) ] ] }

def shader : SlangShaderModule :=
  { structs := [paramsStruct], groupShared := [], globals := globals
  , functions := [mainEntry] }

example : shader.entryPointNames = ["main"] := by native_decide

end Fit.FitShader
