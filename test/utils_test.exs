defmodule UtilsTest do
  use ExUnit.Case

  test "permutations" do
    assert Utils.permutations([1, 2, 3]) |> Enum.sort() ==
             [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]
  end

  test "lowest common multiple" do
    assert Utils.lowest_common_multiple([12, 34, 56]) == 2856
  end
end
