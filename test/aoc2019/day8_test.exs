defmodule Aoc2019.Day8Test do
  use ExUnit.Case

  test "part 1" do
    assert Aoc2019.Day8.solve_part1() == 1088
  end

  test "part 2" do
    layers = [[0, 2, 2, 2], [1, 1, 2, 2], [2, 2, 1, 2], [0, 0, 0, 0]]

    assert layers |> Aoc2019.Day8.pixel_layer(0) == [0, 1, 2, 0]
    assert layers |> Aoc2019.Day8.pixel_layer(1) == [2, 1, 2, 0]
    assert layers |> Aoc2019.Day8.pixel_layer(2) == [2, 2, 1, 0]
    assert layers |> Aoc2019.Day8.pixel_layer(3) == [2, 2, 2, 0]

    assert layers |> Aoc2019.Day8.pixel_layer(0) |> Aoc2019.Day8.colour_of_pixel() == 0
    assert layers |> Aoc2019.Day8.pixel_layer(1) |> Aoc2019.Day8.colour_of_pixel() == 1
    assert layers |> Aoc2019.Day8.pixel_layer(2) |> Aoc2019.Day8.colour_of_pixel() == 1
    assert layers |> Aoc2019.Day8.pixel_layer(3) |> Aoc2019.Day8.colour_of_pixel() == 0

    assert Aoc2019.Day8.solve_part2() == [
             [1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0],
             [1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0],
             [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0],
             [1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0],
             [1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0],
             [1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0]
           ]
  end
end
