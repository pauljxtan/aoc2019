defmodule Mix.Tasks.Sols do
  use Mix.Task

  def run(args) do
    case args do
      [] ->
        IO.puts("Computing all solutions - this may take a while...")
        Aoc2019.implemented() |> Enum.each(fn {day, part} -> do_sol(day, part) end)

      [day, part] ->
        do_sol(String.to_integer(day), String.to_integer(part))
    end
  end

  defp do_sol(day, part),
    do:
      IO.puts(
        sol_str(
          day,
          part,
          case {day, part} do
            {8, 2} ->
              "LGYHB (run `Aoc2019.Day8.solve_part2()` for the full image)"

            {9, 2} ->
              "76791 (hard-coded here until I optimize this properly)"

            {11, 2} ->
              "Day 11, Part 2: ABCLFUHJ  (run `Aoc2019.Day11.solve_part2()` for the full image)"

            {day, part} ->
              Aoc2019.solution(day, part)
          end
        )
      )

  defp sol_str(day, part, sol), do: "Day #{day}, Part #{part}: #{sol}"
end
