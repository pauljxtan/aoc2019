defmodule Aoc2019.Day5 do
  import Utils

  @behaviour DaySolution

  def solve_part1(), do: get_program() |> eval_intcode(0, 1, []) |> Enum.at(-1)
  def solve_part2(), do: get_program() |> eval_intcode(0, 5, []) |> Enum.at(-1)

  def get_program(), do: load_delim_ints("inputs/input_day5", ",")

  def eval_intcode(program, idx, input, outputs) do
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
        outputs

      o when o in [1, 2] ->
        program
        |> List.replace_at(
          k,
          case opcode do
            1 -> x + y
            2 -> x * y
          end
        )
        |> eval_intcode(idx + 4, input, outputs)

      3 ->
        program |> List.replace_at(i, input) |> eval_intcode(idx + 2, input, outputs)

      4 ->
        program |> eval_intcode(idx + 2, input, outputs ++ [x])

      o when o in [5, 6] ->
        if (case o do
              5 -> x != 0
              6 -> x == 0
            end) do
          program |> eval_intcode(y, input, outputs)
        else
          program |> eval_intcode(idx + 3, input, outputs)
        end

      o when o in [7, 8] ->
        if (case o do
              7 -> x < y
              8 -> x == y
            end) do
          program |> List.replace_at(k, 1) |> eval_intcode(idx + 4, input, outputs)
        else
          program |> List.replace_at(k, 0) |> eval_intcode(idx + 4, input, outputs)
        end
    end
  end

  def parse_modevals(modevals) do
    modevals = modevals |> Integer.to_string() |> String.pad_leading(5, "0")
    opcode = modevals |> String.slice(-2..-1) |> String.to_integer()

    [mode1, mode2, mode3] =
      -3..-5 |> Enum.map(fn i -> modevals |> String.at(i) |> String.to_integer() end)

    {opcode, mode1, mode2, mode3}
  end
end
