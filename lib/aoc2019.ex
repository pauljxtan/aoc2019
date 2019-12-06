defmodule Aoc2019 do
  @moduledoc """
  Advent of Code 2019. https://adventofcode.com/2019/
  """
  def solutions,
    do: %{
      {1, 1} => Aoc2019.day1_part1_solve(),
      {1, 2} => Aoc2019.day1_part2_solve(),
      {2, 1} => Aoc2019.day2_part1_solve(),
      {2, 2} => Aoc2019.day2_part2_solve(),
      {3, 1} => Aoc2019.day3_part1_solve(),
      {3, 2} => Aoc2019.day3_part2_solve()
    }

  def day1_part1_solve(), do: load_day1() |> day1_part1()
  def day1_part2_solve(), do: load_day1() |> day1_part2()
  def day2_part1_solve(), do: load_day2() |> day2_part1()
  def day2_part2_solve(), do: load_day2() |> day2_part2()
  def day3_part1_solve(), do: load_day3() |> day3_part1()
  def day3_part2_solve(), do: load_day3() |> day3_part2()

  # -- Inputs

  defp load_day1(), do: load_delim_ints("inputs/input_day1", "\n")
  defp load_day2(), do: load_delim_ints("inputs/input_day2", ",")

  def load_day3(),
    do:
      File.read!("inputs/input_day3")
      |> String.split("\n")
      |> Enum.map(fn path -> path |> String.split(",") end)
      |> Enum.take(2)

  defp load_delim_ints(filepath, delim),
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

  def day2_part2(program) do
    # Brute-force all noun-verb pairs: 100*100 = 10000
    # TODO use stream for lazy eval
    {noun, verb, _} =
      for(
        noun <- 0..99,
        verb <- 0..99,
        do:
          {noun, verb,
           program
           |> List.replace_at(1, noun)
           |> List.replace_at(2, verb)
           |> eval_intcode()
           |> Enum.at(0)}
      )
      |> Enum.find(fn {_, _, result} -> result == 19_690_720 end)

    100 * noun + verb
  end

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

  # -- Day 3

  def day3_part1(paths), do: paths |> closest_intersection_by_dist()
  def day3_part2(paths), do: paths |> closest_intersection_by_steps()

  # Without loss of generality, we'll take the starting the point to be {0, 0}
  def closest_intersection_by_dist(paths),
    do:
      paths
      |> intersections()
      |> Enum.min_by(fn point -> point |> manhattan_dist({0, 0}) end)
      |> manhattan_dist({0, 0})

  def closest_intersection_by_steps(paths) do
    [points1, points2] = paths |> Enum.map(&points_on_path/1)

    paths
    |> intersections()
    |> Enum.map(fn point ->
      {Enum.find_index(points1, fn point1 -> point1 == point end) + 1,
       Enum.find_index(points2, fn point2 -> point2 == point end) + 1}
    end)
    |> Enum.map(fn {steps1, steps2} -> steps1 + steps2 end)
    |> Enum.min()
  end

  def intersections(paths) do
    [points1, points2] =
      paths |> Enum.map(&points_on_path/1) |> Enum.map(fn points -> points |> MapSet.new() end)

    points1 |> MapSet.intersection(points2)
  end

  defp points_on_path(path) do
    path
    |> parse_path()
    |> Enum.reduce([{0, 0}], fn {direction, steps}, acc ->
      {x, y} = acc |> List.last()

      acc ++
        (1..steps
         |> Enum.map(fn n ->
           case direction do
             :R -> {x + n, y}
             :L -> {x - n, y}
             :U -> {x, y + n}
             :D -> {x, y - n}
           end
         end))
    end)
    |> Enum.drop(1)
  end

  defp parse_path(path),
    do:
      path
      |> Enum.map(fn elem ->
        {String.to_atom(String.at(elem, 0)), String.to_integer(String.slice(elem, 1..-1))}
      end)

  defp manhattan_dist({x1, y1}, {x2, y2}), do: abs(y2 - y1) + abs(x2 - x1)
end
