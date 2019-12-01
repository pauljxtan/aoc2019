defmodule Aoc2019 do
  @moduledoc """
  Advent of Code 2019. https://adventofcode.com/2019/
  """
  def solutions,
    do: %{
      {1, 1} => Aoc2019.day1_part1_solve(),
      {1, 2} => Aoc2019.day1_part2_solve()
    }

  def day1_part1_solve(),
    do:
      load_modules()
      |> day1_part1()

  def day1_part2_solve(),
    do:
      load_modules()
      |> day1_part2()

  def load_modules(),
    do:
      File.read!("inputs/input_day1")
      |> String.split("\n")
      |> Enum.map(&Integer.parse/1)
      |> Enum.reduce([], fn result, modules ->
        modules ++
          case result do
            {n, _} -> [n]
            :error -> []
          end
      end)

  def day1_part1(modules),
    do: modules |> Enum.reduce(0, fn mass, acc -> acc + fuel_req(mass) end)

  def day1_part2(modules),
    do: modules |> Enum.reduce(0, fn mass, acc -> acc + fuel_req_recur(0, mass) end)

  defp fuel_req(mass), do: trunc(mass / 3) - 2

  defp fuel_req_recur(total_fuel, mass) do
    fuel = fuel_req(mass)
    if fuel > 0, do: fuel_req_recur(total_fuel + fuel, fuel), else: total_fuel
  end
end
