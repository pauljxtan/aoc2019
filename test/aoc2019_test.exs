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
    assert day1_part1_solve() == 3405721
  end

  test "day 1, part 2" do
    assert day1_part2([14]) == 2
    assert day1_part2([1969]) == 966
    assert day1_part2([100_756]) == 50346
    assert day1_part2([14, 1969, 100_756]) == 2 + 966 + 50346
    assert day1_part2_solve() == 5105716
  end
end
