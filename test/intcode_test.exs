defmodule IntcodeTest do
  use ExUnit.Case

  test "intcode" do
    params = %IntcodeParams{return_val: :program}

    assert [1, 0, 0, 0, 99] |> Intcode.eval(params) == [2, 0, 0, 0, 99]
    assert [2, 3, 0, 3, 99] |> Intcode.eval(params) == [2, 3, 0, 6, 99]
    assert [2, 4, 4, 5, 99, 0] |> Intcode.eval(params) == [2, 4, 4, 5, 99, 9801]
    assert [1, 1, 1, 4, 99, 5, 6, 0, 99] |> Intcode.eval(params) == [30, 1, 1, 4, 2, 5, 6, 0, 99]

    assert [1, 2, 3] |> Intcode.add_memory(3) == [1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    params = %IntcodeParams{inputs: [1]}

    assert [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
           |> Intcode.add_memory(10)
           |> Intcode.eval(params) ==
             [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]

    assert [1102, 34_915_192, 34_915_192, 7, 4, 7, 99, 0]
           |> Intcode.add_memory(10)
           |> Intcode.eval(params) == [1_219_070_632_396_864]

    assert [104, 1_125_899_906_842_624, 99]
           |> Intcode.add_memory(10)
           |> Intcode.eval(params) == [1_125_899_906_842_624]
  end
end
