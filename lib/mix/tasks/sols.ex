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

  defp do_sol(day, part) do
    IO.puts(sol_str(day, part, Aoc2019.solution(day, part)))
  end

  # Too big to display the full image, just hardcode the displayed characters
  defp sol_str(8, 2, _), do: "Day 8, Part 2: LGYHB (run `Aoc2019.Day8.solve_part2()` for the full image)"
  defp sol_str(day, part, sol), do: "Day #{day}, Part #{part}: #{sol}"
end
