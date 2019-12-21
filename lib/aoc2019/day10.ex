defmodule Aoc2019.Day10 do
  @behaviour DaySolution

  def solve_part1(),
    do: input_map() |> parse_asteroids() |> best_location() |> (fn {_, count} -> count end).()

  def solve_part2() do
    {station_coord, _} = input_map() |> parse_asteroids() |> best_location()

    input_map() |> parse_asteroids()
    |> vaporization_order(station_coord)
    |> Enum.at(199)
    |> (fn {x, y} -> x * 100 + y end).()
  end

  def input_map(),
    do:
      File.read!("inputs/input_day10")
      |> String.split("\n")
      |> List.delete_at(-1)

  def best_location(asteroids),
    do:
      asteroids
      |> Enum.map(fn source -> {source, asteroids |> count_detectable_v2(source)} end)
      |> Enum.max_by(fn {_, detectable} -> detectable end)

  def vaporization_order(asteroids, station_coord),
    do:
      asteroids
      |> group_by_angle(station_coord)
      |> Enum.map(fn {_, grp} -> grp end)
      |> vaporization_order_helper([])

  defp vaporization_order_helper([], order), do: order

  defp vaporization_order_helper(groups, order) do
    {grps, acc} =
      groups
      |> Enum.reduce({[], []}, fn grp, {grps, acc} ->
        if length(grp) > 0 do
          [head | tail] = grp
          {grps ++ [tail], acc ++ [head]}
        else
          {grps, acc}
        end
      end)

    vaporization_order_helper(grps, order ++ acc)
  end

  def parse_asteroids(map),
    do:
      for(
        y <- 0..(length(map) - 1),
        x <- 0..((Enum.at(map, 0) |> String.length()) - 1),
        do: {{x, y}, if(map |> Enum.at(y) |> String.at(x) == "#", do: true, else: false)}
      )
      |> Enum.filter(fn {_, has_asteroid} -> has_asteroid end)
      |> Enum.map(fn {coord, _} -> coord end)
      |> Enum.sort()

  # This method counts unique angles b/w the source and other asteroids
  def count_detectable_v2(asteroids, source),
    do:
      asteroids
      |> Enum.filter(&(&1 != source))
      |> Enum.map(fn asteroid -> angle(source, asteroid) end)
      |> Enum.uniq()
      |> Enum.count()

  def group_by_angle(asteroids, source),
    do:
      asteroids
      |> Enum.filter(&(&1 != source))
      |> Enum.reduce(%{}, fn ast, acc ->
        ang = angle(source, ast)
        acc |> Map.put(ang, Map.get(acc, ang, []) ++ [ast])
      end)
      # Sort each group by increasing distance from source
      |> Enum.map(fn {ang, grp} -> {ang, grp |> Enum.sort_by(fn ast -> dist(source, ast) end)} end)
      # Add 2 pi to angles less than -pi/2 so that they start from -pi/2 rad (pointing up)
      |> Enum.map(fn {ang, grp} ->
        {if(ang < -:math.pi() / 2, do: ang + 2 * :math.pi(), else: ang), grp}
      end)
      # Sort in clockwise order
      |> Enum.sort_by(fn {ang, _} -> ang end)

  defp angle({x1, y1}, {x2, y2}), do: :math.atan2(y2 - y1, x2 - x1)
  defp dist({x1, y1}, {x2, y2}), do: :math.sqrt(:math.pow(y2 - y1, 2) + :math.pow(x2 - x1, 2))

  # ----------------------------------------------------------------------------------------------
  # The code below was my first attempt using line equations
  # For larger maps (e.g. the final example and real input) the results were off by a few
  # asteroids, and I haven't been able to figure out why

  # defp count_detectable(source, asteroids),
  # do: source |> detectable_asteroids(asteroids) |> length()

  # defp detectable_asteroids(source, asteroids),
  # do:
  # asteroids
  # |> Enum.filter(&(&1 != source))
  # |> Enum.filter(fn candidate ->
  # source
  # |> blocking_coords(candidate)
  # |> Enum.all?(fn blocker -> blocker not in asteroids end)
  # end)

  ## Vertical (infinite slope)
  # defp blocking_coords({x, y1}, {x, y2}), do: domain(y1, y2) |> Enum.map(fn y -> {x, y} end)

  # defp blocking_coords({x1, y1}, {x2, y2}) do
  # m = (y2 - y1) / (x2 - x1)
  # b = y1 - m * x1

  # domain(x1, x2)
  # |> Enum.map(fn x -> {x, m * x + b} end)
  # |> Enum.filter(fn {x, y} -> round(x) == x and round(y) == y end)
  # |> Enum.map(fn {x, y} -> {round(x), round(y)} end)
  # end

  # defp domain(x1, x2) when abs(x1 - x2) <= 1, do: []
  # defp domain(x1, x2) when x1 < x2, do: (x1 + 1)..(x2 - 1)
  # defp domain(x1, x2), do: (x2 + 1)..(x1 - 1)
end
