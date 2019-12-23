defmodule Intcode do
  def add_memory(program, multiplier),
    do: program ++ List.duplicate(0, length(program) * multiplier)

  # Day 2
  def eval_intcode(program), do: eval_intcode(program, 0, [0], [], 0, false, :program)

  # Day 5
  def eval_intcode(program, idx, input, outputs),
    do: eval_intcode(program, idx, [input], outputs, 0, false, :outputs)

  # TODO it makes more chronological sense to have to have rel_base after loop_mode

  # Day 7
  def eval_intcode(program, idx, inputs, outputs, rel_base, loop_mode),
    do: eval_intcode(program, idx, inputs, outputs, rel_base, loop_mode, :outputs)

  # Day 9
  def eval_intcode(program, idx, input, outputs, rel_base),
    do: eval_intcode(program, idx, [input], outputs, rel_base, false, :outputs)

  def eval_intcode(program, idx, inputs, outputs, rel_base, loop_mode, return_val) do
    {opcode, mode1, mode2, mode3} = parse_modevals(program |> Enum.at(idx))
    params = program |> Enum.slice(idx + 1, 3)

    [i, j, k] =
      case length(params) do
        # TODO replace 0s with nils
        0 -> [0, 0, 0]
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
        if loop_mode do
            :end
        else
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
        |> eval_intcode(idx + 4, inputs, outputs, rel_base, loop_mode, return_val)

      3 ->
        # Use all inputs once until the last input, which is then used for the rest of the program
        # We can think of this as a stream with the last element repeated infinitely
        [input | rest] = inputs
        inputs = if rest != [], do: rest, else: [input]

        program
        |> List.replace_at(i, input)
        |> eval_intcode(idx + 2, inputs, outputs, rel_base, loop_mode, return_val)

      4 ->
        if loop_mode do
          {program, x, idx + 2}
        else
          program |> eval_intcode(idx + 2, inputs, outputs ++ [x], rel_base, loop_mode, return_val)
        end

      o when o in [5, 6] ->
        if (case o do
              5 -> x != 0
              6 -> x == 0
            end) do
          program |> eval_intcode(y, inputs, outputs, rel_base, loop_mode, return_val)
        else
          program |> eval_intcode(idx + 3, inputs, outputs, rel_base, loop_mode, return_val)
        end

      o when o in [7, 8] ->
        if (case o do
              7 -> x < y
              8 -> x == y
            end) do
          program
          |> List.replace_at(k, 1)
          |> eval_intcode(idx + 4, inputs, outputs, rel_base, loop_mode, return_val)
        else
          program
          |> List.replace_at(k, 0)
          |> eval_intcode(idx + 4, inputs, outputs, rel_base, loop_mode, return_val)
        end

      9 ->
        program |> eval_intcode(idx + 2, inputs, outputs, rel_base + x, loop_mode, return_val)
    end
  end

  defp parse_modevals(modevals) do
    modevals = modevals |> Integer.to_string() |> String.pad_leading(5, "0")
    opcode = modevals |> String.slice(-2..-1) |> String.to_integer()

    [mode1, mode2, mode3] =
      -3..-5 |> Enum.map(fn i -> modevals |> String.at(i) |> String.to_integer() end)

    {opcode, mode1, mode2, mode3}
  end
end