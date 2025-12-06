defmodule AOC2025.Days.Day01Test do
  use ExUnit.Case, async: true
  doctest AOC2025.Days.Day01

  # test "part 1 with example input" do
  #   result = Day01.part1(@example_input)
  #   assert result == "solution for part 1"
  # end

  test "part 2 with multiple rotations" do
    input1 = """
    L150
    L200
    R500
    R50
    R1000
    R150
    """

    result = AOC2025.Days.Day01.part2(input1)
    assert result == 21
  end
end
