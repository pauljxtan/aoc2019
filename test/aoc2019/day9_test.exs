defmodule Aoc2019.Day9Test do
  use ExUnit.Case

  test "part 1" do
    assert Aoc2019.Day9.solve_part1() == 3_989_758_265
  end

  # TODO optimize
  @tag timeout: :infinity
  @tag :skip
  test "part 2" do
    assert Aoc2019.Day9.solve_part2() == 76791
  end
end
