defmodule Aoc2019.Day7 do
  import Utils

  @behaviour DaySolution

  def solve_part1(), do: get_program() |> get_max_signal()
  def solve_part2(), do: :not_implemented

  defp get_program(), do: load_delim_ints("inputs/input_day7", ",")

  def get_max_signal(program) do
    # Number of permutations of [0, 1, 2, 3, 4] = 5! = 120
    [0, 1, 2, 3, 4]
    |> permutations()
    |> Enum.map(fn phase_seq -> program |> compute_amplifiers(phase_seq) end)
    |> Enum.max()
  end

  defp permutations([]), do: [[]]

  defp permutations(xs),
    do: for(x <- xs, remaining <- permutations(xs -- [x]), do: [x | remaining])

  def compute_amplifiers(program, [phase_A, phase_B, phase_C, phase_D, phase_E]) do
    output_A = program |> eval_intcode(0, [phase_A, 0], [])
    output_B = program |> eval_intcode(0, [phase_B, output_A], [])
    output_C = program |> eval_intcode(0, [phase_C, output_B], [])
    output_D = program |> eval_intcode(0, [phase_D, output_C], [])
    _output_E = program |> eval_intcode(0, [phase_E, output_D], [])
  end

  defp eval_intcode(program, idx, inputs, outputs) do
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
      |> Enum.map(fn {n, m} -> if m == 0, do: program |> Enum.at(n), else: n end)

    case opcode do
      99 ->
        [output] = outputs
        output

      o when o in [1, 2] ->
        program
        |> List.replace_at(
          k,
          case opcode do
            1 -> x + y
            2 -> x * y
          end
        )
        |> eval_intcode(idx + 4, inputs, outputs)

      3 ->
        [input | inputs_remaining] = inputs
        program |> List.replace_at(i, input) |> eval_intcode(idx + 2, inputs_remaining, outputs)

      4 ->
        program |> eval_intcode(idx + 2, inputs, outputs ++ [x])

      o when o in [5, 6] ->
        if (case o do
              5 -> x != 0
              6 -> x == 0
            end) do
          program |> eval_intcode(y, inputs, outputs)
        else
          program |> eval_intcode(idx + 3, inputs, outputs)
        end

      o when o in [7, 8] ->
        if (case o do
              7 -> x < y
              8 -> x == y
            end) do
          program |> List.replace_at(k, 1) |> eval_intcode(idx + 4, inputs, outputs)
        else
          program |> List.replace_at(k, 0) |> eval_intcode(idx + 4, inputs, outputs)
        end
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
