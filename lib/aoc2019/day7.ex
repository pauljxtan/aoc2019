defmodule Aoc2019.Day7 do
  import Utils
  import Intcode

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
    [output_A] = program |> eval_intcode(0, [phase_A, 0], [], false)
    [output_B] = program |> eval_intcode(0, [phase_B, output_A], [],  false)
    [output_C] = program |> eval_intcode(0, [phase_C, output_B], [],  false)
    [output_D] = program |> eval_intcode(0, [phase_D, output_C], [],  false)
    [output_E] = program |> eval_intcode(0, [phase_E, output_D], [],  false)
    output_E
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

    # TODO try to refactor this to use the helper too
    case program_E
         |> eval_intcode(idx_E, if(first, do: [phase_E, output_D], else: [output_D]), [], true) do
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
         |> eval_intcode(
           idx,
           if(first, do: [phase, input], else: [input]),
           [],
           true
         ) do
      {program, output, idx} -> {program, output, idx}
      :end -> {nil, prev_out, nil}
    end
  end
end
