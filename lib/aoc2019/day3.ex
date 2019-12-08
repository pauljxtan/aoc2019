defmodule Aoc2019.Day3 do
  @behaviour DaySolution

  def solve_part1(), do: paths() |> part1()
  def solve_part2(), do: paths() |> part2()

  defp paths(), do: load("inputs/input_day3")

  defp load(filepath),
    do:
      File.read!(filepath)
      |> String.split("\n")
      |> Enum.map(fn path -> path |> String.split(",") end)
      |> Enum.take(2)

  defp part1(paths), do: paths |> closest_intersection_by_dist()
  defp part2(paths), do: paths |> closest_intersection_by_steps()

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

  defp intersections(paths) do
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
