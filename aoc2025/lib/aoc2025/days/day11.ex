defmodule AOC2025.Days.Day11 do
  @moduledoc """
  Solution for Advent of Code Day 11.
  """

  @doc """
      iex> input = File.read!("inputs/day11_example.txt")
      iex> AOC2025.Days.Day11.part1(input)
      5
  """
  def part1(input) do
    # Implement Part 1 solution here
    input
    |> parse()
    |> then(fn graph ->
      dp("you", graph, %{"out" => 1})
      |> elem(0)
    end)
  end

  defp dp(curr, _graph, visited) when is_map_key(visited, curr),
    do: {Map.get(visited, curr), visited}

  defp dp(curr, graph, visited) do
    nbs = Map.get(graph, curr)

    {ans, visited} =
      Enum.reduce(nbs, {0, visited}, fn nb, {count, new_visited} ->
        {add, vis} = dp(nb, graph, new_visited)
        {count + add, vis}
      end)

    {ans, Map.put(visited, curr, ans)}
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Map.new()
  end

  defp parse_line(line) do
    line
    |> String.split(":")
    |> then(fn [src, dsts] ->
      dsts = String.split(dsts, " ", trim: true)
      {src, dsts}
    end)
  end

  @doc """
      iex> input = File.read!("inputs/day11_example2.txt")
      iex> AOC2025.Days.Day11.part2(input)
      2

  """

  def part2(input) do
    graph = parse(input)

    {ans, _visited} = dp2("svr", 0, graph, %{{"out", 3} => 1})
    ans
  end

  defp dp2(curr, state, _graph, visited) when is_map_key(visited, {curr, state}),
    do: {Map.get(visited, {curr, state}), visited}

  defp dp2(curr, state, graph, visited) do
    new_state =
      case curr do
        "fft" -> Bitwise.bor(state, 1)
        "dac" -> Bitwise.bor(state, 2)
        _ -> state
      end

    nbs = Map.get(graph, curr, [])

    {ans, new_visited} =
      Enum.reduce(nbs, {0, visited}, fn nb, {acc, visited} ->
        {res, new_visited} = dp2(nb, new_state, graph, visited)
        {acc + res, new_visited}
      end)

    {ans, Map.put(new_visited, {curr, state}, ans)}
  end
end
