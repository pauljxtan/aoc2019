defmodule Aoc2019 do
  @moduledoc """
  Advent of Code 2019. https://adventofcode.com/2019/
  """
  @solver_lookup %{
    {1, 1} => &Aoc2019.Day1.solve_part1/0,
    {1, 2} => &Aoc2019.Day1.solve_part2/0,
    {2, 1} => &Aoc2019.Day2.solve_part1/0,
    {2, 2} => &Aoc2019.Day2.solve_part2/0,
    {3, 1} => &Aoc2019.Day3.solve_part1/0,
    {3, 2} => &Aoc2019.Day3.solve_part2/0,
    {4, 1} => &Aoc2019.Day4.solve_part1/0,
    {4, 2} => &Aoc2019.Day4.solve_part2/0,
    {5, 1} => &Aoc2019.Day5.solve_part1/0,
    {5, 2} => &Aoc2019.Day5.solve_part2/0,
    {6, 1} => &Aoc2019.Day6.solve_part1/0,
    {6, 2} => &Aoc2019.Day6.solve_part2/0,
    {7, 1} => &Aoc2019.Day7.solve_part1/0,
    {7, 2} => &Aoc2019.Day7.solve_part2/0
  }

  def implemented(), do: @solver_lookup |> Map.keys()

  def solution(day, part), do: @solver_lookup[{day, part}].()
end
