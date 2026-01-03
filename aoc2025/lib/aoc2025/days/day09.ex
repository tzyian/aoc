defmodule AOC2025.Days.Day09 do
  @moduledoc """
  Solution for Advent of Code Day 9.
  """

  @doc """
      iex> input = File.read!("inputs/day09_example.txt")
      iex> AOC2025.Days.Day09.part1(input)
      50
  """
  def part1(input) do
    # Implement Part 1 solution here
    coords = parse(input)

    for i <- coords, j <- coords do
      rect_size(i, j)
    end
    |> Enum.max()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&String.split(&1, ",", trim: true))
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
  end

  defp rect_size([xi, yi], [xj, yj]) do
    (abs(xi - xj) + 1) * (abs(yi - yj) + 1)
  end

  @doc """
      iex> input = File.read!("inputs/day09_example.txt")
      iex> AOC2025.Days.Day09.part2(input)
      :not_implemented

  """
  def part2(input) do
    # Implement Part 2 solution here
    grid = parse(input)

    # The coords that have the maximal difference are the following
    # (1874, 50137), (94901, 50137)
    #                (94901, 48623), (1544, 48623)

    # Then find the largest rectangle between the high coords
    # Actually just did in python cos matplotlib can visualise lol
    # Do see the subreddit for other different solutions
    :not_implemented
  end
end
