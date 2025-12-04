defmodule AOC2025.Days.Day04 do
  @moduledoc """
  Solution for Advent of Code Day 4.
  """

  @doc """
      iex> input = File.read!("inputs/day04_example.txt")
      iex> AOC2025.Days.Day04.part1(input)
      13
  """
  def part1(input) do
    {grid, _nrows, _ncols} = AocUtil.parse_grid(input)

    grid
    |> Map.filter(fn {coord, v} -> v == "@" and accessible(coord, grid) end)
    |> Enum.count()
  end

  @doc """
      iex> input = File.read!("inputs/day04_example.txt")
      iex> AOC2025.Days.Day04.part2(input)
      43
  """
  def part2(input) do
    {grid, _nrows, _ncols} = AocUtil.parse_grid(input)

    starting_grid = grid |> Map.filter(fn {_coord, v} -> v == "@" end)

    starting_count = starting_grid |> Enum.count()
    left = iter(starting_grid, starting_count)

    starting_count - left
  end

  defp iter(grid, prev_count) do
    rolls_left = grid |> Map.reject(fn {coord, _v} -> accessible(coord, grid) end)

    new_count = Enum.count(rolls_left)

    if new_count == prev_count do
      new_count
    else
      iter(rolls_left, new_count)
    end
  end

  defp accessible({i, j}, grid) do
    count =
      Enum.reduce(-1..1, 0, fn di, acc ->
        Enum.reduce(-1..1, acc, fn dj, acc2 ->
          if di == 0 and dj == 0 do
            acc2
          else
            case Map.get(grid, {i + di, j + dj}) do
              "@" -> acc2 + 1
              _ -> acc2
            end
          end
        end)
      end)

    count < 4
  end
end
