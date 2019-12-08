defmodule Aoc2019Test do
  use ExUnit.Case
  doctest Aoc2019

  alias Aoc2019.Day1
  alias Aoc2019.Day2
  alias Aoc2019.Day3
  alias Aoc2019.Day4

  @day3_path1 [
    ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"],
    ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"]
  ]
  @day3_path2 [
    ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"],
    ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"]
  ]

  test "day 1" do
    # Part 1 (non-recursive)
    assert Day1.total_fuel([12], false) == 2
    assert Day1.total_fuel([14], false) == 2
    assert Day1.total_fuel([1969], false) == 654
    assert Day1.total_fuel([100_756], false) == 33583
    assert Day1.total_fuel([12, 14, 1969, 100_756], false) == 2 + 2 + 654 + 33583

    # Part 2 (recursive)
    assert Day1.total_fuel([14], true) == 2
    assert Day1.total_fuel([1969], true) == 966
    assert Day1.total_fuel([100_756], true) == 50346
    assert Day1.total_fuel([14, 1969, 100_756], true) == 2 + 966 + 50346

    assert Day1.solve_part1() == 3_405_721
    assert Day1.solve_part2() == 5_105_716
  end

  test "day 2" do
    # Part 1
    assert Day2.eval_intcode([1, 0, 0, 0, 99]) == [2, 0, 0, 0, 99]
    assert Day2.eval_intcode([2, 3, 0, 3, 99]) == [2, 3, 0, 6, 99]
    assert Day2.eval_intcode([2, 4, 4, 5, 99, 0]) == [2, 4, 4, 5, 99, 9801]
    assert Day2.eval_intcode([1, 1, 1, 4, 99, 5, 6, 0, 99]) == [30, 1, 1, 4, 2, 5, 6, 0, 99]

    assert Day2.solve_part1() == 4_138_658
    # Too lazy to define a smaller test program, so we'll just test part 2 on the actual input
    assert Day2.solve_part2() == 7264
  end

  test "day 3" do
    # Part 1
    assert Day3.closest_intersection_by_dist(@day3_path1) == 159
    assert Day3.closest_intersection_by_dist(@day3_path2) == 135

    # Part 2
    assert Day3.closest_intersection_by_steps(@day3_path1) == 610
    assert Day3.closest_intersection_by_steps(@day3_path2) == 410

    assert Day3.solve_part1() == 557
    assert Day3.solve_part2() == 56410
  end

  test "day 4" do
    # Part 1
    assert Day4.part1_elems(123, 234) == [
             133,
             144,
             155,
             166,
             177,
             188,
             199,
             222,
             223,
             224,
             225,
             226,
             227,
             228,
             229,
             233
           ]

    assert Day4.part1(123, 234) == 16

    # Part 2
    assert Day4.part2_elems(123, 234) == [
             133,
             144,
             155,
             166,
             177,
             188,
             199,
             223,
             224,
             225,
             226,
             227,
             228,
             229,
             233
           ]

    assert Day4.part2(123, 234) == 15

    assert Day4.solve_part1() == 1099
    assert Day4.solve_part2() == 710
  end
end
