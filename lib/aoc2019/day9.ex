defmodule Aoc2019.Day9 do
  import Utils
  import Intcode

  @behaviour DaySolution

  def solve_part1(), do: get_program() |> add_memory(10) |> eval_intcode(0, 1, [], false, 0) |> Enum.at(0)
  def solve_part2(), do: get_program() |> add_memory(10) |> eval_intcode(0, 2, [], false, 0) |> Enum.at(0)

  defp get_program(), do: load_delim_ints("inputs/input_day9", ",")
end
