defmodule Aoc2019 do
  @moduledoc """
  Advent of Code 2019. https://adventofcode.com/2019/
  """
  def solutions,
    do: %{
      {1, 1} => Aoc2019.day1_part1_solve(),
      {1, 2} => Aoc2019.day1_part2_solve(),
      {2, 1} => Aoc2019.day2_part1_solve()
    }

  def day1_part1_solve(),
    do:
      load_delim_input("inputs/input_day1", "\n")
      |> day1_part1()

  def day1_part2_solve(),
    do:
      load_delim_input("inputs/input_day1", "\n")
      |> day1_part2()

  def day2_part1_solve(),
    do:
      load_delim_input("inputs/input_day2", ",")
      |> day2_part1()

  def load_delim_input(filepath, delim),
    do:
      File.read!(filepath)
      |> String.split(delim)
      |> Enum.map(&Integer.parse/1)
      |> Enum.reduce([], fn result, modules ->
        modules ++
          case result do
            {n, _} -> [n]
            :error -> []
          end
      end)

  # -- Day 1

  def day1_part1(modules),
    do: modules |> Enum.reduce(0, fn mass, acc -> acc + fuel_req(mass) end)

  def day1_part2(modules),
    do: modules |> Enum.reduce(0, fn mass, acc -> acc + fuel_req_recur(0, mass) end)

  defp fuel_req(mass), do: trunc(mass / 3) - 2

  defp fuel_req_recur(total_fuel, mass) do
    fuel = fuel_req(mass)
    if fuel > 0, do: fuel_req_recur(total_fuel + fuel, fuel), else: total_fuel
  end

  # -- Day 2

  def day2_part1(program),
    do: program |> List.replace_at(1, 12) |> List.replace_at(2, 2) |> eval_intcode() |> Enum.at(0)

  def eval_intcode(program, idx \\ 0) do
    opcode = program |> Enum.at(idx)

    case opcode do
      99 ->
        program

      _ ->
        [i, j, k] = program |> Enum.slice(idx + 1, 3)
        [x, y] = [i, j] |> Enum.map(fn k -> program |> Enum.at(k) end)

        result =
          case opcode do
            1 -> x + y
            2 -> x * y
          end

        program |> List.replace_at(k, result) |> eval_intcode(idx + 4)
    end
  end
end
