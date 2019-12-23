defmodule Aoc2019.Day7 do
  import Utils

  @behaviour DaySolution

  def solve_part1(), do: get_program() |> get_max_signal()
  def solve_part2(), do: get_program() |> get_max_signal_loop()

  defp get_program(), do: load_delim_ints("inputs/input_day7", ",")

  def get_max_signal(program),
    # Number of permutations = 5! = 120
    do:
      [0, 1, 2, 3, 4]
      |> permutations()
      |> Enum.map(fn phase_seq -> program |> compute_amplifiers(phase_seq) end)
      |> Enum.max()

  defp get_max_signal_loop(program),
    do:
      [5, 6, 7, 8, 9]
      |> permutations()
      |> Enum.map(fn phase_seq ->
        program
        |> List.duplicate(5)
        |> compute_amplifiers_loop(phase_seq)
      end)
      |> Enum.max()

  def compute_amplifiers(program, [phase_A, phase_B, phase_C, phase_D, phase_E]) do
    output_A = program |> eval_intcode(0, [phase_A, 0], [])
    output_B = program |> eval_intcode(0, [phase_B, output_A], [])
    output_C = program |> eval_intcode(0, [phase_C, output_B], [])
    output_D = program |> eval_intcode(0, [phase_D, output_C], [])
    _output_E = program |> eval_intcode(0, [phase_E, output_D], [])
  end

  def compute_amplifiers_loop(
        [program_A, program_B, program_C, program_D, program_E],
        [phase_A, phase_B, phase_C, phase_D, phase_E],
        [idx_A, idx_B, idx_C, idx_D, idx_E] \\ [0, 0, 0, 0, 0],
        [prev_out_A, prev_out_B, prev_out_C, prev_out_D, prev_out_E] \\ [0, 0, 0, 0, 0],
        first \\ true
      ) do
    {program_A, output_A, idx_A} =
      compute_amplifiers_loop_helper(program_A, idx_A, first, phase_A, prev_out_E, prev_out_A)

    {program_B, output_B, idx_B} =
      compute_amplifiers_loop_helper(program_B, idx_B, first, phase_B, output_A, prev_out_B)

    {program_C, output_C, idx_C} =
      compute_amplifiers_loop_helper(program_C, idx_C, first, phase_C, output_B, prev_out_C)

    {program_D, output_D, idx_D} =
      compute_amplifiers_loop_helper(program_D, idx_D, first, phase_D, output_C, prev_out_D)

    case program_E
         |> eval_intcode_loop(idx_E, if(first, do: [phase_E, output_D], else: [output_D]), []) do
      {program_E, output_E, idx_E} ->
        [program_A, program_B, program_C, program_D, program_E]
        |> compute_amplifiers_loop(
          [phase_A, phase_B, phase_C, phase_D, phase_E],
          [idx_A, idx_B, idx_C, idx_D, idx_E],
          [output_A, output_B, output_C, output_D, output_E],
          false
        )

      :end ->
        prev_out_E
    end
  end

  defp compute_amplifiers_loop_helper(program, idx, first, phase, input, prev_out) do
    case program
         |> eval_intcode_loop(
           idx,
           if(first, do: [phase, input], else: [input]),
           []
         ) do
      {program, output, idx} -> {program, output, idx}
      :end -> {nil, prev_out, nil}
    end
  end

  defp eval_intcode(program, idx, inputs, outputs, loop_mode \\ false) do
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
      |> Enum.map(fn {n, m} -> if m == 0, do: program |> Enum.at(n), else: n end)

    case opcode do
      99 ->
        if not loop_mode do
          [output] = outputs
          output
        else
          :end
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
        |> eval_intcode(idx + 4, inputs, outputs, loop_mode)

      3 ->
        [input | inputs_remaining] = inputs
        inputs_remaining = if inputs_remaining != [], do: inputs_remaining, else: [input]

        program
        |> List.replace_at(i, input)
        |> eval_intcode(idx + 2, inputs_remaining, outputs, loop_mode)

      4 ->
        if not loop_mode do
          program |> eval_intcode(idx + 2, inputs, outputs ++ [x], loop_mode)
        else
          {program, x, idx + 2}
        end

      o when o in [5, 6] ->
        if (case o do
              5 -> x != 0
              6 -> x == 0
            end) do
          program |> eval_intcode(y, inputs, outputs, loop_mode)
        else
          program |> eval_intcode(idx + 3, inputs, outputs, loop_mode)
        end

      o when o in [7, 8] ->
        if (case o do
              7 -> x < y
              8 -> x == y
            end) do
          program |> List.replace_at(k, 1) |> eval_intcode(idx + 4, inputs, outputs, loop_mode)
        else
          program |> List.replace_at(k, 0) |> eval_intcode(idx + 4, inputs, outputs, loop_mode)
        end
    end
  end

  defp eval_intcode_loop(program, idx, inputs, outputs),
    do: eval_intcode(program, idx, inputs, outputs, true)

  defp parse_modevals(modevals) do
    modevals = modevals |> Integer.to_string() |> String.pad_leading(5, "0")
    opcode = modevals |> String.slice(-2..-1) |> String.to_integer()

    [mode1, mode2, mode3] =
      -3..-5 |> Enum.map(fn i -> modevals |> String.at(i) |> String.to_integer() end)

    {opcode, mode1, mode2, mode3}
  end
end
