defmodule Aoc2019.Day10Test do
  use ExUnit.Case

  @map1 [".#..#", ".....", "#####", "....#", "...##"]

  @map2 [
    "......#.#.",
    "#..#.#....",
    "..#######.",
    ".#.#.###..",
    ".#..#.....",
    "..#....#.#",
    "#..#....#.",
    ".##.#..###",
    "##...#..#.",
    ".#....####"
  ]

  @map3 [
    "#.#...#.#.",
    ".###....#.",
    ".#....#...",
    "##.#.#.#.#",
    "....#.#.#.",
    ".##..###.#",
    "..#...##..",
    "..##....##",
    "......#...",
    ".####.###."
  ]

  @map4 [
    ".#..#..###",
    "####.###.#",
    "....###.#.",
    "..###.##.#",
    "##.##.#.#.",
    "....###..#",
    "..#.#..#.#",
    "#..#.#.###",
    ".##...##.#",
    ".....#.#.."
  ]

  @map5 [
    ".#..##.###...#######",
    "##.############..##.",
    ".#.######.########.#",
    ".###.#######.####.#.",
    "#####.##.#.##.###.##",
    "..#####..#.#########",
    "####################",
    "#.####....###.#.#.##",
    "##.#################",
    "#####.##.###..####..",
    "..######..##.#######",
    "####.##.####...##..#",
    ".#####..#.######.###",
    "##...#.##########...",
    "#.##########.#######",
    ".####.#.###.###.#.##",
    "....##.##.###..#####",
    ".#.#.###########.###",
    "#.#.#.#####.####.###",
    "###.##.####.##.#..##"
  ]

  test "part 1" do
    asteroids1 = @map1 |> Aoc2019.Day10.parse_asteroids()

    assert asteroids1 ==
             [{0, 2}, {1, 0}, {1, 2}, {2, 2}, {3, 2}, {3, 4}, {4, 0}, {4, 2}, {4, 3}, {4, 4}]

    assert asteroids1 |> Aoc2019.Day10.count_detectable({1, 0}) == 7
    assert asteroids1 |> Aoc2019.Day10.count_detectable({4, 0}) == 7
    assert asteroids1 |> Aoc2019.Day10.count_detectable({0, 2}) == 6
    assert asteroids1 |> Aoc2019.Day10.count_detectable({1, 2}) == 7
    assert asteroids1 |> Aoc2019.Day10.count_detectable({2, 2}) == 7
    assert asteroids1 |> Aoc2019.Day10.count_detectable({3, 2}) == 7
    assert asteroids1 |> Aoc2019.Day10.count_detectable({4, 2}) == 5
    assert asteroids1 |> Aoc2019.Day10.count_detectable({4, 3}) == 7
    assert asteroids1 |> Aoc2019.Day10.count_detectable({3, 4}) == 8
    assert asteroids1 |> Aoc2019.Day10.count_detectable({4, 4}) == 7

    assert @map1 |> Aoc2019.Day10.parse_asteroids() |> Aoc2019.Day10.best_location() ==
             {{3, 4}, 8}

    assert @map2 |> Aoc2019.Day10.parse_asteroids() |> Aoc2019.Day10.best_location() ==
             {{5, 8}, 33}

    assert @map3 |> Aoc2019.Day10.parse_asteroids() |> Aoc2019.Day10.best_location() ==
             {{1, 2}, 35}

    assert @map4 |> Aoc2019.Day10.parse_asteroids() |> Aoc2019.Day10.best_location() ==
             {{6, 3}, 41}

    assert @map5 |> Aoc2019.Day10.parse_asteroids() |> Aoc2019.Day10.best_location() ==
             {{11, 13}, 210}

    assert Aoc2019.Day10.solve_part1() == 299
  end

  test "part 2" do
    asteroids1 = @map1 |> Aoc2019.Day10.parse_asteroids()

    assert asteroids1 |> Aoc2019.Day10.group_by_angle({4, 2}) == [
             {-1.5707963267948966, [{4, 0}]},
             {1.5707963267948966, [{4, 3}, {4, 4}]},
             {2.0344439357957027, [{3, 4}]},
             {3.141592653589793, [{3, 2}, {2, 2}, {1, 2}, {0, 2}]},
             {3.7295952571373605, [{1, 0}]}
           ]

    vapor_order5 =
      @map5 |> Aoc2019.Day10.parse_asteroids() |> Aoc2019.Day10.vaporization_order({11, 13})

    assert vapor_order5 |> Enum.at(0) == {11, 12}
    assert vapor_order5 |> Enum.at(1) == {12, 1}
    assert vapor_order5 |> Enum.at(2) == {12, 2}
    assert vapor_order5 |> Enum.at(9) == {12, 8}
    assert vapor_order5 |> Enum.at(19) == {16, 0}
    assert vapor_order5 |> Enum.at(49) == {16, 9}
    assert vapor_order5 |> Enum.at(99) == {10, 16}
    assert vapor_order5 |> Enum.at(198) == {9, 6}
    assert vapor_order5 |> Enum.at(199) == {8, 2}
    assert vapor_order5 |> Enum.at(200) == {10, 9}
    assert vapor_order5 |> Enum.at(298) == {11, 1}

    assert Aoc2019.Day10.solve_part2() == 1419
  end
end
