defmodule Aoc2019.Day9 do
  @behaviour DaySolution

  def solve_part1(),
    do:
      get_program()
      |> Intcode.add_memory(10)
      |> Intcode.eval(%IntcodeParams{inputs: [1]})
      |> Enum.at(0)

  def solve_part2(),
    do:
      get_program()
      |> Intcode.add_memory(10)
      |> Intcode.eval(%IntcodeParams{inputs: [2]})
      |> Enum.at(0)

  defp get_program(), do: Utils.load_delim_ints("inputs/input_day9", ",")
end
