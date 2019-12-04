defmodule Aoc2019Test do
  use ExUnit.Case
  doctest Aoc2019
  import Aoc2019

  test "day 1, part 1" do
    assert day1_part1([12]) == 2
    assert day1_part1([14]) == 2
    assert day1_part1([1969]) == 654
    assert day1_part1([100_756]) == 33583
    assert day1_part1([12, 14, 1969, 100_756]) == 2 + 2 + 654 + 33583
    assert day1_part1_solve() == 3_405_721
  end

  test "day 1, part 2" do
    assert day1_part2([14]) == 2
    assert day1_part2([1969]) == 966
    assert day1_part2([100_756]) == 50346
    assert day1_part2([14, 1969, 100_756]) == 2 + 966 + 50346
    assert day1_part2_solve() == 5_105_716
  end

  test "day 2, part 1" do
    assert eval_intcode([1, 0, 0, 0, 99]) == [2, 0, 0, 0, 99]
    assert eval_intcode([2, 3, 0, 3, 99]) == [2, 3, 0, 6, 99]
    assert eval_intcode([2, 4, 4, 5, 99, 0]) == [2, 4, 4, 5, 99, 9801]
    assert eval_intcode([1, 1, 1, 4, 99, 5, 6, 0, 99]) == [30, 1, 1, 4, 2, 5, 6, 0, 99]
    assert day2_part1_solve() == 4_138_658
  end
end
