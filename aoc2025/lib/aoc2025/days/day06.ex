defmodule AOC2025.Days.Day06 do
  alias Day6

  @moduledoc """
  Solution for Advent of Code Day 6.
  """

  @doc """
      iex> input = File.read!("inputs/day06_example.txt")
      iex> AOC2025.Days.Day06.part1(input)
      4277556

  """
  def part1(input) do
    # Implement Part 1 solution here
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.reverse()
    |> transpose()
    |> Enum.map(&solve/1)
    |> Enum.sum()

  end

  def transpose(matrix) do
    matrix
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp solve([op | xs]) when op == "*" do
    xs
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(&(&1 * &2))
  end

  defp solve([op | xs]) when op == "+" do
    xs
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  # ===========================================================

  @doc """
      iex> input = File.read!("inputs/day06_example.txt")
      iex> AOC2025.Days.Day06.part2(input)
      3263827
  """
  def part2(input) do
    # Implement Part 2 solution here

    [ops | rows] = String.split(input, "\n", trim: true) |> Enum.reverse()

    indices = get_split_indices(ops)

    _ = """
    turn 
    123 328  51 64 
     45 64  387 23 
      6 98  215 314
    into (note the spaces)
    123,328, 51,64
     45,64 ,387,23
      6,98 ,215,314
    """

    rows =
      rows
      # last column needs to add a single separator column
      |> Enum.map(fn line -> line <> " " end)
      |> Enum.map(&split_at_indices(&1, indices))
      |> Enum.map(fn nums ->
        # get rid of separator column
        Enum.map(nums, fn x -> binary_part(x, 0, byte_size(x) - 1) end)
      end)
      |> Enum.reverse()

    ops =
      ops
      |> String.split()
      |> Enum.map(&String.trim/1)

    [ops | rows]
    |> transpose()
    |> Enum.map(&solve2/1)
    |> Enum.sum()
  end

  def get_split_indices(s) do
    Regex.scan(~r/\*|\+/, s, return: :index)
    |> List.flatten()
    |> Enum.map(&elem(&1, 0))
    # drop the 0th element, no point splitting on index 0
    |> tl()
  end

  def split_at_indices(str, idxs) do
    n = byte_size(str)

    {parts, prev} =
      Enum.map_reduce(idxs, 0, fn i, prev ->
        {binary_part(str, prev, i - prev), i}
      end)

    parts ++ [binary_part(str, prev, n - prev)]
  end

  @doc """
    Note the spaces in the numbers
      iex> ["+", "64 ", "23 ", "314"] |> AOC2025.Days.Day06.solve2()
      1058
      iex> ["*", " 51", "387", "215"] |> AOC2025.Days.Day06.solve2()     
      3253600
      iex> ["+", "564 ", " 23 ", " 123"] |> AOC2025.Days.Day06.solve2()
      1061
  """
  def solve2([op | xs]) do
    nums = 
      xs
      |> Enum.map(&String.graphemes/1)
      |> transpose()
      |> Enum.map(&Enum.join/1)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)

    case String.trim(op) do
      "*" -> Enum.reduce(nums, &(&1 * &2))
      "+" -> Enum.sum(nums)
    end
  end
end
