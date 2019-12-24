defmodule Aoc2019.Day3Test do
  use ExUnit.Case

  @path1 [
    ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"],
    ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"]
  ]

  @path2 [
    ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"],
    ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"]
  ]

  test "part 1" do
    assert Aoc2019.Day3.closest_intersection_by_dist(@path1) == 159
    assert Aoc2019.Day3.closest_intersection_by_dist(@path2) == 135
    assert Aoc2019.Day3.solve_part1() == 557
  end

  test "part 2" do
    assert Aoc2019.Day3.closest_intersection_by_steps(@path1) == 610
    assert Aoc2019.Day3.closest_intersection_by_steps(@path2) == 410
    assert Aoc2019.Day3.solve_part2() == 56410
  end
end
