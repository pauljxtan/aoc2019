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
end
