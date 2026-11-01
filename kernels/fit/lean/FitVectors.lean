import Fit

/-- Prints `value dvalue` for each test vector; the C++ oracle prints the same. -/
def vectors : List (Float × Float × Float × Float) :=
  [ (1.0, 0.5, 2.0, 0.25), (0.5, 1.0, 2.0, 0.25), (0.5, 0.5, 1.0, 1.0)
  , (3.0, 0.25, 0.5, 0.125), (-0.5, -1.0, 4.0, 0.5), (0.0, 0.0, 1.0, 1.0) ]

def main : IO Unit := do
  for (d, d0, a, w) in vectors do
    IO.println s!"{Fit.value d d0 a w} {Fit.dvalue d d0 a w}"
