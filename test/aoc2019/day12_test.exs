defmodule Aoc2019.Day12Test do
  use ExUnit.Case

  @positions [{-1, 0, 2}, {2, -10, -7}, {4, -8, 8}, {3, 5, -1}]
  @velocities [{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}]
  @moons {@positions, @velocities}

  test "part 1" do
    assert @moons |> Aoc2019.Day12.iterate(0) == @moons

    assert @moons |> Aoc2019.Day12.iterate(1) ==
             {[{2, -1, 1}, {3, -7, -4}, {1, -7, 5}, {2, 2, 0}],
              [{3, -1, -1}, {1, 3, 3}, {-3, 1, -3}, {-1, -3, 1}]}

    assert @moons |> Aoc2019.Day12.iterate(2) ==
             {[{5, -3, -1}, {1, -2, 2}, {1, -4, -1}, {1, -4, 2}],
              [{3, -2, -2}, {-2, 5, 6}, {0, 3, -6}, {-1, -6, 2}]}

    assert @moons |> Aoc2019.Day12.iterate(3) ==
             {[{5, -6, -1}, {0, 0, 6}, {2, 1, -5}, {1, -8, 2}],
              [{0, -3, 0}, {-1, 2, 4}, {1, 5, -4}, {0, -4, 0}]}

    assert @moons |> Aoc2019.Day12.iterate(4) ==
             {[{2, -8, 0}, {2, 1, 7}, {2, 3, -6}, {2, -9, 1}],
              [{-3, -2, 1}, {2, 1, 1}, {0, 2, -1}, {1, -1, -1}]}

    assert @moons |> Aoc2019.Day12.iterate(5) ==
             {[{-1, -9, 2}, {4, 1, 5}, {2, 2, -4}, {3, -7, -1}],
              [{-3, -1, 2}, {2, 0, -2}, {0, -1, 2}, {1, 2, -2}]}

    assert @moons |> Aoc2019.Day12.iterate(6) ==
             {[{-1, -7, 3}, {3, 0, 0}, {3, -2, 1}, {3, -4, -2}],
              [{0, 2, 1}, {-1, -1, -5}, {1, -4, 5}, {0, 3, -1}]}

    assert @moons |> Aoc2019.Day12.iterate(7) ==
             {[{2, -2, 1}, {1, -4, -4}, {3, -7, 5}, {2, 0, 0}],
              [{3, 5, -2}, {-2, -4, -4}, {0, -5, 4}, {-1, 4, 2}]}

    assert @moons |> Aoc2019.Day12.iterate(8) ==
             {[{5, 2, -2}, {2, -7, -5}, {0, -9, 6}, {1, 1, 3}],
              [{3, 4, -3}, {1, -3, -1}, {-3, -2, 1}, {-1, 1, 3}]}

    assert @moons |> Aoc2019.Day12.iterate(9) ==
             {[{5, 3, -4}, {2, -9, -3}, {0, -8, 4}, {1, 1, 5}],
              [{0, 1, -2}, {0, -2, 2}, {0, 1, -2}, {0, 0, 2}]}

    assert @moons |> Aoc2019.Day12.iterate(10) ==
             {[{2, 1, -3}, {1, -8, 0}, {3, -6, 1}, {2, 0, 4}],
              [{-3, -2, 1}, {-1, 1, 3}, {3, 2, -3}, {1, -1, -1}]}

    assert @moons |> Aoc2019.Day12.iterate(10) |> Aoc2019.Day12.total_energy() ==
             179

    assert Aoc2019.Day12.solve_part1() == 8625
  end

  test "part 2" do
    assert @moons |> Aoc2019.Day12.get_period() == 2772

    assert {[{-8, -10, 0}, {5, 5, 10}, {2, -7, 3}, {9, -8, -3}], @velocities}
           |> Aoc2019.Day12.get_period() == 4_686_774_924

    assert Aoc2019.Day12.solve_part2() == 332_477_126_821_644
  end
end
