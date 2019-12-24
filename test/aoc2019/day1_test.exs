defmodule Aoc2019.Day1Test do
  use ExUnit.Case

  test "part 1" do
    assert Aoc2019.Day1.total_fuel([12], false) == 2
    assert Aoc2019.Day1.total_fuel([14], false) == 2
    assert Aoc2019.Day1.total_fuel([1969], false) == 654
    assert Aoc2019.Day1.total_fuel([100_756], false) == 33583
    assert Aoc2019.Day1.total_fuel([12, 14, 1969, 100_756], false) == 2 + 2 + 654 + 33583
    assert Aoc2019.Day1.solve_part1() == 3_405_721
  end

  test "part 2" do
    assert Aoc2019.Day1.total_fuel([14], true) == 2
    assert Aoc2019.Day1.total_fuel([1969], true) == 966
    assert Aoc2019.Day1.total_fuel([100_756], true) == 50346
    assert Aoc2019.Day1.total_fuel([14, 1969, 100_756], true) == 2 + 966 + 50346
    assert Aoc2019.Day1.solve_part2() == 5_105_716
  end
end
