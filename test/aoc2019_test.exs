defmodule Aoc2019Test do
  use ExUnit.Case
  doctest Aoc2019

  alias Aoc2019.{Day1, Day2, Day3, Day4, Day5, Day6, Day7, Day8}

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
    path1 = [
      ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"],
      ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"]
    ]

    path2 = [
      ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"],
      ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"]
    ]

    # Part 1
    assert Day3.closest_intersection_by_dist(path1) == 159
    assert Day3.closest_intersection_by_dist(path2) == 135

    # Part 2
    assert Day3.closest_intersection_by_steps(path1) == 610
    assert Day3.closest_intersection_by_steps(path2) == 410

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

  test "day 5" do
    program = Day5.get_program()

    # Part 1
    assert program |> Day5.eval_intcode(0, 1, []) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 11_193_703]

    # Part 2
    assert program |> Day5.eval_intcode(0, 5, []) == [12_410_607]
  end

  test "day 6" do
    # Part 1

    orbits = [
      {"COM", "B"},
      {"B", "C"},
      {"C", "D"},
      {"D", "E"},
      {"E", "F"},
      {"B", "G"},
      {"G", "H"},
      {"D", "I"},
      {"E", "J"},
      {"J", "K"},
      {"K", "L"}
    ]

    tree = orbits |> Day6.build_tree()

    assert tree == %{
             "B" => ["C", "G"],
             "C" => ["D"],
             "COM" => ["B"],
             "D" => ["E", "I"],
             "E" => ["F", "J"],
             "G" => ["H"],
             "J" => ["K"],
             "K" => ["L"]
           }

    assert tree |> Day6.count_descendants("COM") == 11
    assert tree |> Day6.count_descendants("B") == 10
    assert tree |> Day6.count_descendants("G") == 1
    assert tree |> Day6.count_descendants("H") == 0
    assert tree |> Day6.count_descendants("C") == 7
    assert tree |> Day6.count_descendants("D") == 6
    assert tree |> Day6.count_descendants("I") == 0
    assert tree |> Day6.count_descendants("E") == 4
    assert tree |> Day6.count_descendants("J") == 2
    assert tree |> Day6.count_descendants("K") == 1
    assert tree |> Day6.count_descendants("L") == 0
    assert tree |> Day6.count_descendants("F") == 0

    assert tree |> Day6.count_all_descendants() == 42

    # Part 2

    orbits = [
      {"COM", "B"},
      {"B", "C"},
      {"C", "D"},
      {"D", "E"},
      {"E", "F"},
      {"B", "G"},
      {"G", "H"},
      {"D", "I"},
      {"E", "J"},
      {"J", "K"},
      {"K", "L"},
      {"K", "YOU"},
      {"I", "SAN"}
    ]

    tree = orbits |> Day6.build_tree()

    assert tree == %{
             "B" => ["C", "G"],
             "C" => ["D"],
             "COM" => ["B"],
             "D" => ["E", "I"],
             "E" => ["F", "J"],
             "G" => ["H"],
             "I" => ["SAN"],
             "J" => ["K"],
             "K" => ["L", "YOU"]
           }

    assert tree |> Day6.get_ancestors("COM") == []
    assert tree |> Day6.get_ancestors("B") == ["COM"]
    assert tree |> Day6.get_ancestors("G") == ["B", "COM"]
    assert tree |> Day6.get_ancestors("H") == ["G", "B", "COM"]
    assert tree |> Day6.get_ancestors("C") == ["B", "COM"]
    assert tree |> Day6.get_ancestors("D") == ["C", "B", "COM"]
    assert tree |> Day6.get_ancestors("I") == ["D", "C", "B", "COM"]
    assert tree |> Day6.get_ancestors("E") == ["D", "C", "B", "COM"]
    assert tree |> Day6.get_ancestors("J") == ["E", "D", "C", "B", "COM"]
    assert tree |> Day6.get_ancestors("K") == ["J", "E", "D", "C", "B", "COM"]
    assert tree |> Day6.get_ancestors("L") == ["K", "J", "E", "D", "C", "B", "COM"]
    assert tree |> Day6.get_ancestors("F") == ["E", "D", "C", "B", "COM"]

    assert tree |> Day6.min_orbital_transfers("YOU", "SAN") == 4

    assert Day6.solve_part1() == 253_104
    assert Day6.solve_part2() == 499
  end

  test "day 7" do
    # Part 1

    program_1 = [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0]

    program_2 =
      [3, 23, 3, 24, 1002, 24, 10, 24, 1002, 23, -1, 23, 101, 5, 23, 23, 1, 24, 23, 23, 4, 23] ++
        [99, 0, 0]

    program_3 =
      [3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007, 31, 0, 33, 1002, 33, 7, 33, 1, 33] ++
        [31, 31, 1, 32, 31, 31, 4, 31, 99, 0, 0, 0]

    assert program_1 |> Day7.compute_amplifiers([4, 3, 2, 1, 0]) == 43210
    assert program_2 |> Day7.compute_amplifiers([0, 1, 2, 3, 4]) == 54321
    assert program_3 |> Day7.compute_amplifiers([1, 0, 4, 3, 2]) == 65210

    assert program_1 |> Day7.get_max_signal() == 43210
    assert program_2 |> Day7.get_max_signal() == 54321
    assert program_3 |> Day7.get_max_signal() == 65210

    # Part 2

    program_1 =
      [3, 26, 1001, 26, -4, 26, 3, 27, 1002, 27, 2, 27, 1, 27, 26, 27, 4, 27, 1001, 28, -1, 28] ++
        [1005, 28, 6, 99, 0, 0, 5]

    program_2 =
      [3, 52, 1001, 52, -5, 52, 3, 53, 1, 52, 56, 54, 1007, 54, 5, 55, 1005, 55, 26, 1001, 54] ++
        [-5, 54, 1105, 1, 12, 1, 53, 54, 53, 1008, 54, 0, 55, 1001, 55, 1, 55, 2, 53, 55, 53, 4] ++
        [53, 1001, 56, -1, 56, 1005, 56, 6, 99, 0, 0, 0, 0, 10]

    assert program_1
           |> List.duplicate(5)
           |> Day7.compute_amplifiers_loop([9, 8, 7, 6, 5]) ==
             139_629_729

    assert program_2
           |> List.duplicate(5)
           |> Day7.compute_amplifiers_loop([9, 7, 8, 5, 6]) ==
             18216

    assert Day7.solve_part1() == 437_860
    assert Day7.solve_part2() == 49_810_599
  end

  test "day 8" do
    # Part 1 - straightforward, don't bother with unit tests

    # Part 2

    layers = [[0, 2, 2, 2], [1, 1, 2, 2], [2, 2, 1, 2], [0, 0, 0, 0]]

    assert layers |> Day8.pixel_layer(0) == [0, 1, 2, 0]
    assert layers |> Day8.pixel_layer(1) == [2, 1, 2, 0]
    assert layers |> Day8.pixel_layer(2) == [2, 2, 1, 0]
    assert layers |> Day8.pixel_layer(3) == [2, 2, 2, 0]

    assert layers |> Day8.pixel_layer(0) |> Day8.colour_of_pixel() == 0
    assert layers |> Day8.pixel_layer(1) |> Day8.colour_of_pixel() == 1
    assert layers |> Day8.pixel_layer(2) |> Day8.colour_of_pixel() == 1
    assert layers |> Day8.pixel_layer(3) |> Day8.colour_of_pixel() == 0

    assert Day8.solve_part1() == 1088

    assert Day8.solve_part2() == [
             [1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0],
             [1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0],
             [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0],
             [1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0],
             [1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0],
             [1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0]
           ]
  end
end
