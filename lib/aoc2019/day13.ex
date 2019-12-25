defmodule Aoc2019.Day13 do
  @behaviour DaySolution

  def solve_part1(),
    do:
      get_program()
      |> Intcode.add_memory(10)
      |> Intcode.eval(%IntcodeParams{arcade_mode: true})
      |> Map.values()
      |> Enum.count(&(&1 == :block))

  def solve_part2(), do: :not_implemented

  def get_program(), do: Utils.load_delim_ints("inputs/input_day13", ",")
end
