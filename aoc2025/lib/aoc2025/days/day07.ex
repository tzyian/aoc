defmodule AOC2025.Days.Day07 do
  @moduledoc """
  Solution for Advent of Code Day 7.
  """

  @doc """
      iex> input = File.read!("inputs/day07_example.txt")
      iex> AOC2025.Days.Day07.part1(input)
      21
  """
  def part1(input) do
    # Implement Part 1 solution here
    # puzzle is set such that splitters are not at the edges of the grid
    # technically you can just parse row by row during the bfs but whatever
    {grid, nrows, _ncols} = AocUtil.parse_grid(input)

    [{start, _v}] = Enum.filter(grid, fn {_k, v} -> v == "S" end)

    splitters =
      Enum.filter(grid, fn {_k, v} -> v == "^" end)
      |> Enum.map(fn {k, _v} -> k end)
      |> MapSet.new()

    beams = MapSet.new([start])
    bfs(beams, splitters, nrows, 0, 0)
  end

  @spec bfs(MapSet.t(), MapSet.t(), integer(), integer(), integer()) :: integer()
  defp bfs(_beams, _splitters, nrows, row, count) when nrows == row, do: count

  defp bfs(beams, splitters, nrows, row, count) do
    {new_beams, new_count} =
      Enum.reduce(beams, {MapSet.new(), count}, fn {i, j}, {new_beams, splits} ->
        if MapSet.member?(splitters, {i, j}) do
          new_beams =
            new_beams |> MapSet.put({i + 1, j - 1}) |> MapSet.put({i + 1, j + 1})

          {new_beams, splits + 1}
        else
          {MapSet.put(new_beams, {i + 1, j}), splits}
        end
      end)

    bfs(new_beams, splitters, nrows, row + 1, new_count)
  end

  @doc """
      iex> input = File.read!("inputs/day07_example.txt")
      iex> AOC2025.Days.Day07.part2(input)
      40
  """
  def part2(input) do
    # Implement Part 2 solution here
    [head | tail] =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.codepoints/1)

    start_idx = Enum.find_index(head, &(&1 == "S"))
    table = %{start_idx => 1}

    dp(tail, table)
  end

  defp dp([], table), do: table |> Map.values() |> Enum.sum()

  defp dp([row | tail], table) do
    new_table =
      row
      |> Enum.with_index()
      |> Enum.reduce(Map.new(), fn {char, idx}, acc ->
        dpi = Map.get(table, idx, 0)

        if dpi == 0 do
          acc
        else
          add = &(&1 + dpi)

          case char do
            "." -> Map.update(acc, idx, dpi, add)
            "^" -> Map.update(acc, idx - 1, dpi, add) |> Map.update(idx + 1, dpi, add)
          end
        end
      end)

    dp(tail, new_table)
  end
end
