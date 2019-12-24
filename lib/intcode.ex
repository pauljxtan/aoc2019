defmodule Intcode do
  def add_memory(program, multiplier),
    do: program ++ List.duplicate(0, length(program) * multiplier)

  # Day 2
  # def eval_intcode(program),
  # do: eval_intcode(program, 0, [0], [], false, 0, {false, nil, nil, nil}, :program)
  # do: eval(program, %IntcodeParams{return_val: :program})

  # Day 5
  # def eval_intcode(program, idx, input, outputs),
  # do: eval_intcode(program, idx, [input], outputs, false, 0, {false, nil, nil, nil}, :outputs)

  # Day 7
  def eval_intcode(program, idx, inputs, outputs, loop_mode),
    do:
      eval_intcode(program, idx, inputs, outputs, loop_mode, 0, {false, nil, nil, nil}, :outputs)

  # Day 9
  def eval_intcode(program, idx, input, outputs, loop_mode, rel_base),
    do:
      eval_intcode(
        program,
        idx,
        [input],
        outputs,
        loop_mode,
        rel_base,
        {false, nil, nil, nil},
        :outputs
      )

  # Day 11
  def eval_intcode(
        program,
        idx,
        input,
        outputs,
        loop_mode,
        rel_base,
        {robot_position, robot_direction, robot_panels}
      ),
      do:
        eval_intcode(
          program,
          idx,
          [input],
          outputs,
          loop_mode,
          rel_base,
          {true, robot_position, robot_direction, robot_panels},
          :outputs
        )

  def eval(program, params) do
    # TODO refactor this
    %IntcodeParams{
      idx: idx,
      inputs: inputs,
      outputs: outputs,
      loop_mode: loop_mode,
      rel_base: rel_base,
      return_val: return_val,
      robot_mode: robot_mode,
      robot_position: robot_position,
      robot_direction: robot_direction,
      robot_panels: robot_panels
    } = params

    {robot_position, robot_direction, robot_panels, inputs, outputs} =
      if robot_mode and length(outputs) == 2,
        do: do_robot_action(robot_position, robot_direction, robot_panels, outputs),
        else: {robot_position, robot_direction, robot_panels, inputs, outputs}

    params = %{
      params
      | robot_position: robot_position,
        robot_direction: robot_direction,
        robot_panels: robot_panels,
        inputs: inputs,
        outputs: outputs
    }

    {opcode, mode1, mode2, mode3} = parse_modevals(program |> Enum.at(idx))
    pars = program |> Enum.slice(idx + 1, 3)

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
          2 -> program |> Enum.at(rel_base + h)
        end
      end)

    # NOTE this part is not entirely clear in the description
    i = if mode1 == 2, do: rel_base + i, else: i
    k = if mode3 == 2, do: rel_base + k, else: k

    case opcode do
      99 ->
        cond do
          robot_mode ->
            robot_panels

          loop_mode ->
            :end

          true ->
            case return_val do
              :program -> program
              :outputs -> outputs
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
        |> eval(%{params | idx: idx + 4})

      3 ->
        # Use all inputs once until the last input, which is then used for the rest of the program
        # We can think of this as a stream with the last element repeated infinitely
        [input | rest] = inputs
        inputs = if rest != [], do: rest, else: [input]

        program
        |> List.replace_at(i, input)
        |> eval(%{params | idx: idx + 2, inputs: inputs})

      4 ->
        if loop_mode,
          do: {program, x, idx + 2},
          else: program |> eval(%{params | idx: idx + 2, outputs: outputs ++ [x]})

      o when o in [5, 6] ->
        if (case o do
              5 -> x != 0
              6 -> x == 0
            end),
           do: program |> eval(%{params | idx: y}),
           else: program |> eval(%{params | idx: idx + 3})

      o when o in [7, 8] ->
        if (case o do
              7 -> x < y
              8 -> x == y
            end),
           do: program |> List.replace_at(k, 1) |> eval(%{params | idx: idx + 4}),
           else: program |> List.replace_at(k, 0) |> eval(%{params | idx: idx + 4})

      9 ->
        program
        |> eval(%{params | idx: idx + 2, rel_base: rel_base + x})
    end
  end

  defp eval_intcode(
         program,
         idx,
         inputs,
         outputs,
         loop_mode,
         rel_base,
         {robot_mode, robot_position, robot_direction, robot_panels},
         return_val
       ) do
    {robot_position, robot_direction, robot_panels, inputs, outputs} =
      if robot_mode and length(outputs) == 2,
        do: do_robot_action(robot_position, robot_direction, robot_panels, outputs),
        else: {robot_position, robot_direction, robot_panels, inputs, outputs}

    {opcode, mode1, mode2, mode3} = parse_modevals(program |> Enum.at(idx))
    params = program |> Enum.slice(idx + 1, 3)

    [i, j, k] =
      case length(params) do
        0 -> [0, 0, 0]
        1 -> params ++ [0, 0]
        2 -> params ++ [0]
        3 -> params
      end

    [x, y, _z] =
      [{i, mode1}, {j, mode2}, {k, mode3}]
      |> Enum.map(fn {h, mode} ->
        case mode do
          0 -> program |> Enum.at(h)
          1 -> h
          2 -> program |> Enum.at(rel_base + h)
        end
      end)

    # NOTE this part is not entirely clear in the description
    i = if mode1 == 2, do: rel_base + i, else: i
    k = if mode3 == 2, do: rel_base + k, else: k

    case opcode do
      99 ->
        cond do
          robot_mode ->
            robot_panels

          loop_mode ->
            :end

          true ->
            case return_val do
              :program -> program
              :outputs -> outputs
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
        |> eval_intcode(
          idx + 4,
          inputs,
          outputs,
          loop_mode,
          rel_base,
          {robot_mode, robot_position, robot_direction, robot_panels},
          return_val
        )

      3 ->
        # Use all inputs once until the last input, which is then used for the rest of the program
        # We can think of this as a stream with the last element repeated infinitely
        [input | rest] = inputs
        inputs = if rest != [], do: rest, else: [input]

        program
        |> List.replace_at(i, input)
        |> eval_intcode(
          idx + 2,
          inputs,
          outputs,
          loop_mode,
          rel_base,
          {robot_mode, robot_position, robot_direction, robot_panels},
          return_val
        )

      4 ->
        if loop_mode,
          do: {program, x, idx + 2},
          else:
            program
            |> eval_intcode(
              idx + 2,
              inputs,
              outputs ++ [x],
              loop_mode,
              rel_base,
              {robot_mode, robot_position, robot_direction, robot_panels},
              return_val
            )

      o when o in [5, 6] ->
        if (case o do
              5 -> x != 0
              6 -> x == 0
            end),
           do:
             program
             |> eval_intcode(
               y,
               inputs,
               outputs,
               loop_mode,
               rel_base,
               {robot_mode, robot_position, robot_direction, robot_panels},
               return_val
             ),
           else:
             program
             |> eval_intcode(
               idx + 3,
               inputs,
               outputs,
               loop_mode,
               rel_base,
               {robot_mode, robot_position, robot_direction, robot_panels},
               return_val
             )

      o when o in [7, 8] ->
        if (case o do
              7 -> x < y
              8 -> x == y
            end),
           do:
             program
             |> List.replace_at(k, 1)
             |> eval_intcode(
               idx + 4,
               inputs,
               outputs,
               loop_mode,
               rel_base,
               {robot_mode, robot_position, robot_direction, robot_panels},
               return_val
             ),
           else:
             program
             |> List.replace_at(k, 0)
             |> eval_intcode(
               idx + 4,
               inputs,
               outputs,
               loop_mode,
               rel_base,
               {robot_mode, robot_position, robot_direction, robot_panels},
               return_val
             )

      9 ->
        program
        |> eval_intcode(
          idx + 2,
          inputs,
          outputs,
          loop_mode,
          rel_base + x,
          {robot_mode, robot_position, robot_direction, robot_panels},
          return_val
        )
    end
  end

  defp parse_modevals(modevals) do
    modevals = modevals |> Integer.to_string() |> String.pad_leading(5, "0")
    opcode = modevals |> String.slice(-2..-1) |> String.to_integer()

    [mode1, mode2, mode3] =
      -3..-5 |> Enum.map(fn i -> modevals |> String.at(i) |> String.to_integer() end)

    {opcode, mode1, mode2, mode3}
  end

  defp do_robot_action(position, direction, panels, outputs) do
    colour =
      case outputs |> Enum.at(-2) do
        0 -> :black
        1 -> :white
      end

    turn =
      case outputs |> Enum.at(-1) do
        0 -> :ccw
        1 -> :cw
      end

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

    input =
      case next_colour do
        :black -> 0
        :white -> 1
      end

    {next_position, next_direction, panels, [input], []}
  end
end
