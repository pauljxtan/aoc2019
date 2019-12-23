defmodule Utils do
  def load_delim_ints(filepath, delim),
    do:
      File.read!(filepath)
      |> String.split(delim)
      |> Enum.map(&Integer.parse/1)
      |> Enum.reduce([], fn result, modules ->
        modules ++
          case result do
            {n, _} -> [n]
            :error -> []
          end
      end)

  def permutations([]), do: [[]]

  def permutations(xs),
    do: for(x <- xs, remaining <- permutations(xs -- [x]), do: [x | remaining])
end
