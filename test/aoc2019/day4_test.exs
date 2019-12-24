defmodule Aoc2019.Day4Test do
  use ExUnit.Case

  test "part 1" do
    assert Aoc2019.Day4.part1_elems(123, 234) ==
             [133, 144, 155, 166, 177, 188, 199, 222, 223, 224, 225, 226, 227, 228, 229, 233]

    assert Aoc2019.Day4.part1(123, 234) == 16
    assert Aoc2019.Day4.solve_part1() == 1099
  end

  test "part 2" do
    assert Aoc2019.Day4.part2_elems(123, 234) ==
             [133, 144, 155, 166, 177, 188, 199, 223, 224, 225, 226, 227, 228, 229, 233]

    assert Aoc2019.Day4.part2(123, 234) == 15
    assert Aoc2019.Day4.solve_part2() == 710
  end
end
