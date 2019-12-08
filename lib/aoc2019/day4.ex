defmodule Aoc2019.Day4 do
  @behaviour DaySolution

  def solve_part1(), do: part1(245_182, 790_572)
  def solve_part2(), do: part2(245_182, 790_572)

  def part1(min, max), do: part1_elems(min, max) |> length()
  def part2(min, max), do: part2_elems(min, max) |> length()

  def part1_elems(min, max),
    do:
      min..max
      |> Enum.filter(fn n ->
        digits = n |> number_to_digits()
        is_monotonically_increasing(digits) and has_repeated_digit(digits)
      end)

  def part2_elems(min, max),
    do:
      part1_elems(min, max)
      |> Enum.filter(fn n ->
        n |> number_to_digits() |> digit_counts() |> Enum.count(&(&1 == 2)) >= 1
      end)

  def digit_counts(digits),
    do: digits |> MapSet.new() |> Enum.map(fn d -> digits |> Enum.count(&(&1 == d)) end)

  defp is_monotonically_increasing(digits), do: digits == Enum.sort(digits)

  # N.B. the monotonically increasing condition implies repeated digits must be adjacent
  defp has_repeated_digit(digits), do: digits |> MapSet.new() |> MapSet.size() < length(digits)

  defp number_to_digits(number),
    do:
      number
      |> Integer.to_string()
      |> String.split("")
      |> Enum.reduce([], fn s, acc -> if s != "", do: acc ++ [s], else: acc end)
      |> Enum.map(&String.to_integer/1)
end
