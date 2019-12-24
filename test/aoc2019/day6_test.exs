defmodule Aoc2019.Day6Test do
  use ExUnit.Case

  test "part 1" do
    tree =
      ([{"COM", "B"}, {"B", "C"}, {"C", "D"}, {"D", "E"}, {"E", "F"}, {"B", "G"}, {"G", "H"}] ++
         [{"D", "I"}, {"E", "J"}, {"J", "K"}, {"K", "L"}])
      |> Aoc2019.Day6.build_tree()

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

    assert ["COM", "B", "G", "H", "C", "D", "I", "E", "J", "K", "L", "F"]
           |> Enum.map(fn node ->
             tree |> Aoc2019.Day6.count_descendants(node) |> (fn {count, _cache} -> count end).()
           end) == [11, 10, 1, 0, 7, 6, 0, 4, 2, 1, 0, 0]

    assert tree |> Aoc2019.Day6.count_all_descendants() == 42

    assert Aoc2019.Day6.solve_part1() == 253_104
  end

  test "part 2" do
    orbits =
      [{"COM", "B"}, {"B", "C"}, {"C", "D"}, {"D", "E"}, {"E", "F"}, {"B", "G"}, {"G", "H"}] ++
        [{"D", "I"}, {"E", "J"}, {"J", "K"}, {"K", "L"}, {"K", "YOU"}, {"I", "SAN"}]

    tree = orbits |> Aoc2019.Day6.build_tree()

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

    assert tree |> Aoc2019.Day6.get_ancestors("COM") == []
    assert tree |> Aoc2019.Day6.get_ancestors("B") == ["COM"]
    assert tree |> Aoc2019.Day6.get_ancestors("G") == ["B", "COM"]
    assert tree |> Aoc2019.Day6.get_ancestors("H") == ["G", "B", "COM"]
    assert tree |> Aoc2019.Day6.get_ancestors("C") == ["B", "COM"]
    assert tree |> Aoc2019.Day6.get_ancestors("D") == ["C", "B", "COM"]
    assert tree |> Aoc2019.Day6.get_ancestors("I") == ["D", "C", "B", "COM"]
    assert tree |> Aoc2019.Day6.get_ancestors("E") == ["D", "C", "B", "COM"]
    assert tree |> Aoc2019.Day6.get_ancestors("J") == ["E", "D", "C", "B", "COM"]
    assert tree |> Aoc2019.Day6.get_ancestors("K") == ["J", "E", "D", "C", "B", "COM"]
    assert tree |> Aoc2019.Day6.get_ancestors("L") == ["K", "J", "E", "D", "C", "B", "COM"]
    assert tree |> Aoc2019.Day6.get_ancestors("F") == ["E", "D", "C", "B", "COM"]

    assert tree |> Aoc2019.Day6.min_orbital_transfers("YOU", "SAN") == 4

    assert Aoc2019.Day6.solve_part2() == 499
  end
end
