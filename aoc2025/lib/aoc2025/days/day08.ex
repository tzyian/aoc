defmodule AOC2025.Days.Day08 do
  @moduledoc """
  Solution for Advent of Code Day 8.
  """

  @doc """
      iex> input = File.read!("inputs/day08_example.txt")
      iex> AOC2025.Days.Day08.part1(input, 10)
      40
  """
  def part1(input, merges \\ 1000) do
    # Implement Part 1 solution here
    input
    |> parse()
    |> Enum.with_index()
    |> generate_pairs([])
    |> Enum.sort()
    |> Enum.map(fn {_dist, i, j} -> {i, j} end)
    |> union_find(merges)
    |> top_three()
  end

  defp union_find(pairs, merges) do
    {uf, _} =
      pairs
      |> Enum.reduce_while({UnionFind.new(), merges}, fn {i, j}, {uf, merges} ->
        uf = UnionFind.union(uf, i, j)

        if merges == 1 do
          {:halt, {uf, merges}}
        else
          {:cont, {uf, merges - 1}}
        end
      end)

    uf
  end

  defp top_three(uf) do
    UnionFind.get_roots(uf)
    |> Enum.map(&UnionFind.get_size(uf, &1))
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  # Generate the euclidean distances of all pairs in O(n^2)
  # Take in [{[x, y, z], index}]
  # Return [{dist, i, j}]
  defp generate_pairs([], dists), do: dists
  defp generate_pairs([_], dists), do: dists

  defp generate_pairs([x | xs], dists) do
    {ele1, i} = x

    acc =
      Enum.reduce(xs, dists, fn {ele2, j}, acc ->
        [{euc_dist(ele1, ele2), i, j} | acc]
      end)

    generate_pairs(xs, acc)
  end

  defp euc_dist([i, j, k], [x, y, z]) do
    di = i - x
    dj = j - y
    dk = k - z
    :math.sqrt(di * di + dj * dj + dk * dk)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&String.split(&1, ","))
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(3)
  end

  # ===========================================

  @doc """
      iex> input = File.read!("inputs/day08_example.txt")
      iex> AOC2025.Days.Day08.part2(input)
      25272

  """
  def part2(input) do
    # Implement Part 2 solution here
    parsed =
      input
      |> parse()

    n = length(parsed)

    {i, j} =
      parsed
      |> Enum.with_index()
      |> generate_pairs([])
      |> Enum.sort()
      |> Enum.map(fn {_dist, i, j} -> {i, j} end)
      |> union_find2(n)

    # whatever no point changing all the functions just to avoid the fetch here
    i_coord = Enum.fetch!(parsed, i) |> hd()
    j_coord = Enum.fetch!(parsed, j) |> hd()
    i_coord * j_coord
  end

  defp union_find2(pairs, n) do
    {_, coords} =
      pairs
      |> Enum.reduce_while({UnionFind.new(), nil}, fn {i, j}, {uf, nil} ->
        # This too, needs changing to return size. Whatever
        uf = UnionFind.union(uf, i, j)

        size = UnionFind.get_size(uf, i)

        if size == n do
          {:halt, {uf, {i, j}}}
        else
          {:cont, {uf, nil}}
        end
      end)

    coords
  end
end
