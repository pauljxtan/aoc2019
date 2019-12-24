defmodule Aoc2019.Day5 do
  @behaviour DaySolution

  def solve_part1(), do: get_program() |> Intcode.eval(%IntcodeParams{inputs: [1]}) |> Enum.at(-1)
  def solve_part2(), do: get_program() |> Intcode.eval(%IntcodeParams{inputs: [5]}) |> Enum.at(-1)

  defp get_program(), do: Utils.load_delim_ints("inputs/input_day5", ",")
end
