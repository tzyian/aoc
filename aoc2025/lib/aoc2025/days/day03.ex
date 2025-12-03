defmodule AOC2025.Days.Day03 do
  @doc """
      iex> input = File.read!("inputs/day03_example.txt")
      iex> AOC2025.Days.Day03.part1(input)
      357
  """
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&largest_subseq_size_k(&1, 2))
    |> Enum.sum()
  end

  @doc """
      iex> input = File.read!("inputs/day03_example.txt")
      iex> AOC2025.Days.Day03.part2(input)
      3121910778619
  """
  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&largest_subseq_size_k(&1, 12))
    |> Enum.sum()
  end

  defp largest_subseq_size_k(s, k) do
    n = String.length(s)

    s
    |> String.graphemes()
    |> lexico_largest(k, n - k, [])
  end

  defp lexico_largest([], k, _remaining_pops, stack) do
    stack
    |> Enum.reverse()
    |> Enum.take(k)
    |> Enum.join()
    |> String.to_integer()
  end

  defp lexico_largest([x | xs], k, 0, stack) do
    lexico_largest(xs, k, 0, [x | stack])
  end

  defp lexico_largest([x | xs], k, remaining_pops, []) do
    lexico_largest(xs, k, remaining_pops, [x])
  end

  defp lexico_largest([x | xs], k, remaining_pops, [y | ys]) when x > y do
    lexico_largest([x | xs], k, remaining_pops - 1, ys)
  end

  defp lexico_largest([x | xs], k, remaining_pops, [y | ys]) when x <= y do
    lexico_largest(xs, k, remaining_pops, [x, y | ys])
  end
end
