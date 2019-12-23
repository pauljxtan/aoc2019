defmodule Aoc2019.Day11 do
  import Utils

  @behaviour DaySolution

  @add_mem_multiplier 10

  def solve_part1(), do: get_program() |> paint(:black) |> map_size()
  def solve_part2(), do: get_program() |> paint(:white) |> format_str()

  def get_program(), do: load_delim_ints("inputs/input_day11", ",")

  def paint(program, init_colour),
    do:
      program
      # WLOG, start at (0, 0)
      |> eval_intcode_more_mem(
        0,
        if(init_colour == :black, do: 0, else: 1),
        [],
        0,
        {0, 0},
        :up,
        Map.new()
      )

  def format_str(panels) do
    # For convenience, shift all positions start at (0, 0)
    x_min = panels |> Map.keys() |> Enum.map(fn {x, _} -> x end) |> Enum.min()
    y_min = panels |> Map.keys() |> Enum.map(fn {_, y} -> y end) |> Enum.min()

    panels =
      panels
      |> Enum.map(fn {{x, y}, colour} -> {{x - x_min, y - y_min}, colour} end)
      |> Map.new()

    x_max = panels |> Map.keys() |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    y_max = panels |> Map.keys() |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    # Note that we're still using the coordinate system with (0, 0) at the top left
    # x is columns increasing right, y is rows increasing down
    for y <- 0..y_max,
        do:
          for(
            x <- 0..x_max,
            do: if(panels |> Map.get({x, y}, :black) == :black, do: ".", else: "#")
          )
          |> Enum.join()
  end

  defp eval_intcode_more_mem(program, idx, input, outputs, rel_base, position, direction, panels),
    do:
      program
      |> add_memory(length(program) * @add_mem_multiplier)
      |> eval_intcode(idx, input, outputs, rel_base, position, direction, panels)

  defp add_memory(program, add_len), do: program ++ List.duplicate(0, add_len)

  defp eval_intcode(program, idx, input, outputs, rel_base, position, direction, panels) do
    {position, direction, panels, input, outputs} =
      if length(outputs) == 2,
        do: do_robot_action(position, direction, panels, outputs),
        else: {position, direction, panels, input, outputs}

    {opcode, mode1, mode2, mode3} = parse_modevals(program |> Enum.at(idx))
    params = program |> Enum.slice(idx + 1, 3)

    [i, j, k] =
      case length(params) do
        1 -> params ++ [0, 0]
        2 -> params ++ [0]
        3 -> params
      end

    [x, y, _z] =
      [{i, mode1}, {j, mode2}, {k, mode3}]
      |> Enum.map(fn {n, m} ->
        case m do
          0 -> program |> Enum.at(n)
          1 -> n
          2 -> program |> Enum.at(rel_base + n)
        end
      end)

    # NOTE this part is not entirely clear in the description
    i = if mode1 == 2, do: rel_base + i, else: i
    k = if mode3 == 2, do: rel_base + k, else: k

    case opcode do
      99 ->
        panels

      o when o in [1, 2] ->
        program
        |> List.replace_at(
          k,
          case opcode do
            1 -> x + y
            2 -> x * y
          end
        )
        |> eval_intcode(idx + 4, input, outputs, rel_base, position, direction, panels)

      3 ->
        program
        |> List.replace_at(i, input)
        |> eval_intcode(idx + 2, input, outputs, rel_base, position, direction, panels)

      4 ->
        program
        |> eval_intcode(idx + 2, input, outputs ++ [x], rel_base, position, direction, panels)

      o when o in [5, 6] ->
        if (case o do
              5 -> x != 0
              6 -> x == 0
            end) do
          program |> eval_intcode(y, input, outputs, rel_base, position, direction, panels)
        else
          program |> eval_intcode(idx + 3, input, outputs, rel_base, position, direction, panels)
        end

      o when o in [7, 8] ->
        if (case o do
              7 -> x < y
              8 -> x == y
            end) do
          program
          |> List.replace_at(k, 1)
          |> eval_intcode(idx + 4, input, outputs, rel_base, position, direction, panels)
        else
          program
          |> List.replace_at(k, 0)
          |> eval_intcode(idx + 4, input, outputs, rel_base, position, direction, panels)
        end

      9 ->
        program
        |> eval_intcode(idx + 2, input, outputs, rel_base + x, position, direction, panels)
    end
  end

  defp do_robot_action(position, direction, panels, outputs) do
    colour = if outputs |> Enum.at(-2) == 0, do: :black, else: :white
    turn = if outputs |> Enum.at(-1) == 0, do: :ccw, else: :cw

    # Paint the current panel
    # Any panel that is a key in this map has been painted at least once
    panels = panels |> Map.put(position, colour)

    # Turn the robot
    next_direction =
      case turn do
        :ccw ->
          case direction do
            :up -> :left
            :left -> :down
            :down -> :right
            :right -> :up
          end

        :cw ->
          case direction do
            :up -> :right
            :right -> :down
            :down -> :left
            :left -> :up
          end
      end

    {x, y} = position

    # Move forward one panel
    next_position =
      case next_direction do
        :up -> {x, y - 1}
        :down -> {x, y + 1}
        :left -> {x - 1, y}
        :right -> {x + 1, y}
      end

    next_colour = panels |> Map.get(next_position, :black)

    {next_position, next_direction, panels, if(next_colour == :black, do: 0, else: 1), []}
  end

  defp parse_modevals(modevals) do
    modevals = modevals |> Integer.to_string() |> String.pad_leading(5, "0")
    opcode = modevals |> String.slice(-2..-1) |> String.to_integer()

    [mode1, mode2, mode3] =
      -3..-5 |> Enum.map(fn i -> modevals |> String.at(i) |> String.to_integer() end)

    {opcode, mode1, mode2, mode3}
  end
end
