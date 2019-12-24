defmodule Aoc2019.Day1 do
  @behaviour DaySolution

  def solve_part1(), do: modules() |> total_fuel(false)
  def solve_part2(), do: modules() |> total_fuel(true)

  defp modules(), do: Utils.load_delim_ints("inputs/input_day1", "\n")

  def total_fuel(masses, recursive \\ false),
    do:
      masses
      |> Enum.reduce(0, fn mass, acc ->
        acc + if recursive, do: fuel_req_recur(0, mass), else: fuel_req(mass)
      end)

  defp fuel_req(mass), do: trunc(mass / 3) - 2

  defp fuel_req_recur(total, mass) do
    fuel = fuel_req(mass)
    if fuel > 0, do: fuel_req_recur(total + fuel, fuel), else: total
  end
end
