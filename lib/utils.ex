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

  def lowest_common_multiple(list), do: lcm(list)

  defp lcm(a, b), do: abs(a * b) |> div(gcd(a, b))
  defp lcm([x | [y]]), do: lcm(x, y)
  defp lcm([x | xs]), do: lcm(x, lcm(xs))
  defp gcd(a, 0), do: abs(a)
  defp gcd(a, b), do: gcd(b, rem(a, b))
end
