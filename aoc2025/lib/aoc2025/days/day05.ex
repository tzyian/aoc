defmodule AOC2025.Days.Day05 do
  @moduledoc """
  Solution for Advent of Code Day 5.
  """

  @doc """
      iex> input = File.read!("inputs/day05_example.txt")
      iex> AOC2025.Days.Day05.part1(input)
      3
  """
  def part1(input) do
    # Implement Part 1 solution here
    {ranges, ids} =
      parse(input)

    ids
    |> Enum.filter(&in_range(&1, ranges))
    |> Enum.count()
  end

  @doc """
      iex> input = File.read!("inputs/day05_example.txt")
      iex> AOC2025.Days.Day05.part2(input)
      14
  """
  def part2(input) do
    # Implement Part 2 solution here
    {ranges, _} = parse(input)

    ranges
    |> Enum.map(fn {s, e} -> e - s + 1 end)
    |> Enum.sum()
  end

  defp parse(input) do
    [ranges, ids] =
      input
      |> String.split("\n\n", trim: true, parts: 2)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    ranges =
      ranges
      |> Enum.map(fn range ->
        range
        |> String.split("-", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)
      |> Enum.sort()
      |> merge_intervals({0, 0}, [])

    ids =
      ids
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()

    {ranges, ids}
  end

  defp merge_intervals([], se, intervals) do
    [se | intervals]
    |> Enum.reverse()
    |> Enum.drop(1)
  end

  defp merge_intervals([{i, j} | xs], {s, e}, intervals) do
    cond do
      e < i -> merge_intervals(xs, {i, j}, [{s, e} | intervals])
      e >= i -> merge_intervals(xs, {s, max(j, e)}, intervals)
    end
  end

  defp in_range(id, ranges) do
    ranges
    |> Enum.any?(fn {s, e} -> s <= id and id <= e end)
  end
end
