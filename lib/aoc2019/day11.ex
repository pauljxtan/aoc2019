defmodule Aoc2019.Day11 do
  import Utils
  import Intcode

  @behaviour DaySolution

  def solve_part1(), do: get_program() |> paint(:black) |> map_size()
  def solve_part2(), do: get_program() |> paint(:white) |> format_str()

  def get_program(), do: load_delim_ints("inputs/input_day11", ",")

  def paint(program, init_colour),
    do:
      program
      |> add_memory(10)
      # WLOG, start at (0, 0)
      |> eval_intcode(
        0,
        case init_colour do
          :black -> 0
          :white -> 1
        end,
        [],
        false,
        0,
        {{0, 0}, :up, Map.new()}
      )

  def format_str(panels) do
    # For convenience, shift all positions start at (0, 0)
    x_min = panels |> Map.keys() |> Enum.map(fn {x, _} -> x end) |> Enum.min()
    y_min = panels |> Map.keys() |> Enum.map(fn {_, y} -> y end) |> Enum.min()

    panels =
      panels
      |> Enum.map(fn {{x, y}, colour} -> {{x - x_min, y - y_min}, colour} end)
      |> Map.new()

    x_max = panels |> Map.keys() |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    y_max = panels |> Map.keys() |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    # Note that we're still using the coordinate system with (0, 0) at the top left
    # x is columns increasing right, y is rows increasing down
    for y <- 0..y_max,
        do:
          for(
            x <- 0..x_max,
            do:
              case panels |> Map.get({x, y}, :black) do
                :black -> "."
                :white -> "#"
              end
          )
          |> Enum.join()
  end
end
