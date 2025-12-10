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

  # TODO:
  @doc """
      iex> input = File.read!("inputs/day09_example.txt")
      iex> AOC2025.Days.Day09.part2(input)
      :not_implemented
      # 24

  """
  def part2(input) do
    # Implement Part 2 solution here
    grid = parse(input)

    max_x =
      grid
      |> Enum.map(fn [x, _y] -> x end)
      |> Enum.max()

    max_y =
      grid
      |> Enum.map(fn [_x, y] -> y end)
      |> Enum.max()

    plot =
      grid
      |> Enum.map(fn [x, y] -> {y, x} end)
      |> Map.from_keys("x")

    _out =
      AocUtil.inspect_grid(plot, max_y + 2, max_x + 2, ".")
      |> Enum.map(&Enum.join/1)
      |> Enum.join("\n")

    :not_implemented
  end
end
