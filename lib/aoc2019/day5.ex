defmodule Aoc2019.Day5 do
  import Utils
  import Intcode

  @behaviour DaySolution

  def solve_part1(), do: get_program() |> eval_intcode(0, 1, []) |> Enum.at(-1)
  def solve_part2(), do: get_program() |> eval_intcode(0, 5, []) |> Enum.at(-1)

  def get_program(), do: load_delim_ints("inputs/input_day5", ",")
end
