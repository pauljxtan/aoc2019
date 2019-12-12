defmodule Aoc2019.Day6 do
  @behaviour DaySolution

  def solve_part1(), do: get_orbits() |> build_tree() |> count_all_descendants()
  def solve_part2(), do: :not_implemented

  def get_orbits(),
    do:
      File.read!("inputs/input_day6")
      |> String.split("\n")
      |> Enum.map(fn s -> s |> String.split(")") |> List.to_tuple() end)
      |> List.delete_at(-1)

  # Key = parent, value = list of children
  def build_tree(orbits),
    do:
      orbits
      |> Enum.reduce(Map.new(), fn {orbitee, orbitor}, map ->
        map |> Map.put(orbitee, Map.get(map, orbitee, []) ++ [orbitor])
      end)

  def count_all_descendants(tree),
    do:
      tree
      |> Map.keys()
      |> Enum.map(fn parent -> tree |> count_descendants(parent) end)
      |> Enum.sum()

  def count_descendants(tree, parent),
    do:
      if(parent not in Map.keys(tree),
        do: 0,
        else:
          tree
          |> Map.get(parent)
          |> Enum.map(fn child -> 1 + count_descendants(tree, child) end)
          |> Enum.sum()
      )
end
