defmodule Intcode do
  def add_memory(program, multiplier),
    do: program ++ List.duplicate(0, length(program) * multiplier)

  def eval(program, params) do
    params =
      if params.robot_mode and length(params.outputs) == 2,
        do: do_robot_action(params),
        else: params

    params =
      if params.arcade_mode and length(params.outputs) == 3,
        do: do_arcade_action(params),
        else: params

    [opcode: opcode, mode1: mode1, mode2: mode2, mode3: mode3] =
      program
      |> Enum.at(params.idx)
      |> Integer.to_string()
      |> String.pad_leading(5, "0")
      |> parse_modevals()

    pars = program |> Enum.slice(params.idx + 1, 3)

    [i, j, k] =
      case length(pars) do
        0 -> [0, 0, 0]
        1 -> pars ++ [0, 0]
        2 -> pars ++ [0]
        3 -> pars
      end

    [x, y, _z] =
      [{i, mode1}, {j, mode2}, {k, mode3}]
      |> Enum.map(fn {h, mode} ->
        case mode do
          0 -> program |> Enum.at(h)
          1 -> h
          2 -> program |> Enum.at(params.rel_base + h)
        end
      end)

    # NOTE this part is not entirely clear in the description
    i = if mode1 == 2, do: params.rel_base + i, else: i
    k = if mode3 == 2, do: params.rel_base + k, else: k

    case opcode do
      99 ->
        cond do
          params.robot_mode ->
            params.robot_panels

          params.arcade_mode ->
            params.arcade_tiles

          params.loop_mode ->
            :end

          true ->
            case params.return_val do
              :program -> program
              :outputs -> params.outputs
            end
        end

      o when o in [1, 2] ->
        program
        |> List.replace_at(
          k,
          case opcode do
            1 -> x + y
            2 -> x * y
          end
        )
        |> eval(%{params | idx: params.idx + 4})

      3 ->
        # Use all inputs once until the last input, which is then used for the rest of the program
        # We can think of this as a stream with the last element repeated infinitely
        [input | rest] = params.inputs

        program
        |> List.replace_at(i, input)
        |> eval(%{params | idx: params.idx + 2, inputs: if(rest != [], do: rest, else: [input])})

      4 ->
        if params.loop_mode,
          do: {program, x, params.idx + 2},
          else: program |> eval(%{params | idx: params.idx + 2, outputs: params.outputs ++ [x]})

      o when o in [5, 6] ->
        if (case o do
              5 -> x != 0
              6 -> x == 0
            end),
           do: program |> eval(%{params | idx: y}),
           else: program |> eval(%{params | idx: params.idx + 3})

      o when o in [7, 8] ->
        if (case o do
              7 -> x < y
              8 -> x == y
            end),
           do: program |> List.replace_at(k, 1) |> eval(%{params | idx: params.idx + 4}),
           else: program |> List.replace_at(k, 0) |> eval(%{params | idx: params.idx + 4})

      9 ->
        program
        |> eval(%{params | idx: params.idx + 2, rel_base: params.rel_base + x})
    end
  end

  defp parse_modevals(modevals),
    do:
      [opcode: modevals |> String.slice(-2..-1) |> String.to_integer()]
      |> Keyword.merge(
        [:mode1, :mode2, :mode3]
        |> Enum.zip(
          -3..-5
          |> Enum.map(fn i -> modevals |> String.at(i) |> String.to_integer() end)
        )
      )

  defp do_robot_action(params) do
    # Paint the current panel
    # Any panel that is a key in this map has been painted at least once
    updated_panels =
      params.robot_panels
      |> Map.put(
        params.robot_position,
        case params.outputs |> Enum.at(-2) do
          0 -> :black
          1 -> :white
        end
      )

    # Turn the robot
    next_direction =
      case (case params.outputs |> Enum.at(-1) do
              0 -> :ccw
              1 -> :cw
            end) do
        :ccw ->
          case params.robot_direction do
            :up -> :left
            :left -> :down
            :down -> :right
            :right -> :up
          end

        :cw ->
          case params.robot_direction do
            :up -> :right
            :right -> :down
            :down -> :left
            :left -> :up
          end
      end

    {x, y} = params.robot_position

    # Move forward one panel
    next_position =
      case next_direction do
        :up -> {x, y - 1}
        :down -> {x, y + 1}
        :left -> {x - 1, y}
        :right -> {x + 1, y}
      end

    next_colour = updated_panels |> Map.get(next_position, :black)

    %{
      params
      | robot_position: next_position,
        robot_direction: next_direction,
        robot_panels: updated_panels,
        inputs: [
          case next_colour do
            :black -> 0
            :white -> 1
          end
        ],
        outputs: []
    }
  end

  defp do_arcade_action(params) do
    [x, y, tile_id] = params.outputs

    %{
      params
      | outputs: [], arcade_tiles:
          params.arcade_tiles
          |> Map.put(
            {x, y},
            case tile_id do
              0 -> :empty
              1 -> :wall
              2 -> :block
              3 -> :horizontal_paddle
              4 -> :ball
            end
          )
    }
  end
end
