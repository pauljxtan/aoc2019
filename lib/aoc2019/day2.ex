defmodule Aoc2019.Day2 do
  import Utils

  @behaviour DaySolution

  def solve_part1(), do: get_program() |> part1()
  def solve_part2(), do: get_program() |> part2(19_690_720)

  defp get_program(), do: load_delim_ints("inputs/input_day2", ",")

  defp part1(program),
    do: program |> List.replace_at(1, 12) |> List.replace_at(2, 2) |> eval_intcode() |> Enum.at(0)

  defp part2(program, target) do
    # Brute-force all noun-verb pairs: 100*100 = 10000
    # TODO use stream for lazy eval
    {noun, verb, _} =
      for(
        noun <- 0..99,
        verb <- 0..99,
        do:
          {noun, verb,
           program
           |> List.replace_at(1, noun)
           |> List.replace_at(2, verb)
           |> eval_intcode()
           |> Enum.at(0)}
      )
      |> Enum.find(fn {_, _, result} -> result == target end)

    100 * noun + verb
  end

  def eval_intcode(program, idx \\ 0) do
    opcode = program |> Enum.at(idx)

    case opcode do
      99 ->
        program

      _ ->
        [i, j, k] = program |> Enum.slice(idx + 1, 3)
        [x, y] = [i, j] |> Enum.map(fn k -> program |> Enum.at(k) end)

        result =
          case opcode do
            1 -> x + y
            2 -> x * y
          end

        program |> List.replace_at(k, result) |> eval_intcode(idx + 4)
    end
  end
end