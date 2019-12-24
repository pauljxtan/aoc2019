defmodule Aoc2019.Day12 do
  import Utils

  @behaviour DaySolution

  def solve_part1() do
    positions = get_moons()
    velocities = List.duplicate({0, 0, 0}, length(positions))
    {positions, velocities} |> iterate(1000) |> total_energy()
  end

  def solve_part2() do
    positions = get_moons()
    velocities = List.duplicate({0, 0, 0}, length(positions))
    {positions, velocities} |> get_period
  end

  def iterate(moons, n_steps) when n_steps < 1, do: moons

  def iterate(moons, n_steps), do: iterate(step(moons), n_steps - 1)

  def total_energy({positions, velocities}),
    do: positions |> Enum.zip(velocities) |> Enum.map(&energy/1) |> Enum.sum()

  # Find period separately for each dimension, then find lowest common multiple
  def get_period({positions, velocities}),
    do:
      [:x, :y, :z]
      |> Enum.map(fn dimension -> {positions, velocities} |> get_period_dim(dimension) end)
      |> lowest_common_multiple()

  defp get_period_dim({positions_init, velocities_init}, dimension),
    do:
      Stream.iterate(1, fn step -> step + 1 end)
      |> Enum.reduce_while({positions_init, velocities_init}, fn step, {positions, velocities} ->
        {positions, velocities} = step({positions, velocities})

        if {positions, velocities} |> extract_dimension(dimension) ==
             {positions_init, velocities_init} |> extract_dimension(dimension),
           do: {:halt, step},
           else: {:cont, {positions, velocities}}
      end)

  defp extract_dimension({positions, velocities}, dimension) do
    [positions, velocities]
    |> Enum.map(fn posvels ->
      posvels
      |> Enum.map(fn posvel ->
        posvel
        |> Tuple.to_list()
        |> Enum.at(
          case dimension do
            :x -> 0
            :y -> 1
            :z -> 2
          end
        )
      end)
    end)
  end

  defp get_moons(),
    do:
      File.read!("inputs/input_day12")
      |> String.replace("x=", "")
      |> String.replace("y=", "")
      |> String.replace("z=", "")
      |> String.replace("<", "")
      |> String.replace(">", "")
      |> String.split("\n")
      |> List.delete_at(-1)
      |> Enum.map(fn line ->
        line
        |> String.split(",")
        |> Enum.map(fn s -> s |> String.trim() |> Integer.parse() end)
        |> Enum.map(fn {x, _} -> x end)
      end)
      |> Enum.map(&List.to_tuple/1)

  defp energy({position, velocity}),
    do:
      [position, velocity]
      |> Enum.map(fn tuple ->
        tuple |> Tuple.to_list() |> Enum.map(fn x -> abs(x) end) |> Enum.sum()
      end)
      |> Enum.reduce(1, fn e, total -> total * e end)

  defp step({positions, velocities}) do
    n = length(positions)

    velocities =
      0..(n - 2)
      |> Enum.flat_map(fn i -> (i + 1)..(n - 1) |> Enum.map(fn j -> {i, j} end) end)
      |> Enum.reduce(velocities, fn {i, j}, velocities ->
        {dx, dy, dz} = velocity_delta(positions |> Enum.at(i), positions |> Enum.at(j))

        velocities
        |> List.update_at(i, fn {x, y, z} -> {x + dx, y + dy, z + dz} end)
        |> List.update_at(j, fn {x, y, z} -> {x - dx, y - dy, z - dz} end)
      end)

    positions =
      positions
      |> Enum.zip(velocities)
      |> Enum.map(fn {{x, y, z}, {vx, vy, vz}} -> {x + vx, y + vy, z + vz} end)

    {positions, velocities}
  end

  defp velocity_delta(position1, position2),
    do:
      Tuple.to_list(position1)
      |> Enum.zip(Tuple.to_list(position2))
      |> Enum.map(fn {x1, x2} -> if x1 == x2, do: 0, else: round((x2 - x1) / abs(x2 - x1)) end)
      |> List.to_tuple()
end
