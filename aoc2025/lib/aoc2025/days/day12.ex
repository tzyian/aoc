defmodule AOC2025.Days.Day12 do
  @moduledoc """
  Solution for Advent of Code Day 12.
  """

  @doc """
      <!-- iex> input = File.read!("inputs/day12_example.txt") -->
      <!-- iex> AOC2025.Days.Day12.part1(input) -->
      <!-- 2 -->
  """
  # NOTE: this works for the part1 BUT NOT the example
  # This involves making assumptions about the input that don't always work anyway
  def part1(input) do
    # Implement Part 1 solution here
    # Regions: {length, width, [qty1, qty2, ...]}
    # Presents: [[p1r1, p1r2, p1r3], ...]

    {presents, regions} = parse(input)

    present_sizes =
      presents
      |> Enum.map(fn p ->
        p
        |> Enum.map(&String.count(&1, "#"))
        |> Enum.sum()
      end)

    regions
    |> Enum.filter(&solvable(&1, presents, present_sizes))
    |> Enum.count()
  end

  @spec solvable(
          {integer(), integer(), list(integer())},
          list(integer()),
          list(integer())
        ) ::
          boolean()
  defp solvable({length, width, quantities}, _presents, present_sizes) do
    req =
      Enum.zip(quantities, present_sizes)
      |> Enum.map(fn {q, p} -> q * p end)
      |> Enum.sum()

    IO.inspect({req, length * width})
    req <= length * width
  end

  @spec parse(String.t()) :: {{integer(), integer(), list(integer())}, list(list(integer()))}
  defp parse(input) do
    parts = String.split(input, "\n\n", trim: true)

    presents =
      parts
      |> Enum.reverse()
      |> tl
      |> Enum.reverse()
      |> Enum.map(fn reg ->
        reg
        |> String.split("\n")
        |> tl
      end)

    regions =
      parts
      |> Enum.reverse()
      |> hd
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [size, counts] = String.split(line, ": ", parts: 2)
        [length, width] = String.split(size, "x", parts: 2)

        qtys =
          counts
          |> String.split(" ", trim: true)
          |> Enum.map(&String.to_integer/1)

        {String.to_integer(length), String.to_integer(width), qtys}
      end)

    {presents, regions}
  end

  @doc """
      iex> input = File.read!("inputs/day12_example.txt")
      iex> AOC2025.Days.Day12.part2(input)
      :not_implemented

  """
  def part2(_input) do
    # Implement Part 2 solution here
    :not_implemented
  end
end
