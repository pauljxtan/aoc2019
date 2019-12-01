defmodule Mix.Tasks.Sols do
  use Mix.Task

  def run(args) do
    solutions = Aoc2019.solutions()

    case args do
      [] ->
        solutions
        |> Enum.each(fn {{day, part}, sol} -> IO.puts(sol_str(day, part, sol)) end)

      [day, part] ->
        day = String.to_integer(day)
        part = String.to_integer(part)
        IO.puts(sol_str(day, part, solutions[{day, part}]))
    end
  end

  defp sol_str(day, part, sol), do: "Day #{day}, Part #{part}: #{sol}"
end
