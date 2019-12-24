defmodule Aoc2019.Day6 do
  @behaviour DaySolution

  def solve_part1(), do: get_orbits() |> build_tree() |> count_all_descendants()
  def solve_part2(), do: get_orbits() |> build_tree() |> min_orbital_transfers("YOU", "SAN")

  defp get_orbits(),
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
      # Memoize
      |> Enum.reduce({%{}, 0}, fn parent, {cache, total} ->
        {count, cache} = tree |> count_descendants(parent, cache)
        {cache, total + count}
      end)
      |> (fn {_cache, total} -> total end).()

  def count_descendants(tree, parent, cache \\ %{}) do
    case cache |> Map.get(parent, nil) do
      nil ->
        if parent not in Map.keys(tree)  do
          {0, cache}
        else
          count =
            tree
            |> Map.get(parent)
            |> Enum.map(fn child ->
              {child_count, _cache} = count_descendants(tree, child, cache)
              1 + child_count
            end)
            |> Enum.sum()

          {count, cache |> Map.put(parent, count)}
        end
      count -> {count, cache}
    end
  end

  def min_orbital_transfers(tree, node1, node2) do
    [node1_ancestors, node2_ancestors] =
      [node1, node2] |> Enum.map(fn node -> tree |> get_ancestors(node) end)

    # Find common ancestors -> add up steps to common ancestor from each node -> take minimum
    MapSet.new(node1_ancestors)
    |> MapSet.intersection(MapSet.new(node2_ancestors))
    |> Enum.map(fn common_ancestor ->
      [node1_ancestors, node2_ancestors]
      |> Enum.map(fn ancestors ->
        ancestors |> Enum.find_index(fn ancestor -> ancestor == common_ancestor end)
      end)
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  def get_ancestors(tree, node) do
    parent =
      tree
      |> Enum.find(fn {_, children} -> node in children end)
      |> (fn result ->
            case result do
              nil -> nil
              {parent, _} -> parent
            end
          end).()

    if parent == nil, do: [], else: [parent] ++ get_ancestors(tree, parent)
  end
end
