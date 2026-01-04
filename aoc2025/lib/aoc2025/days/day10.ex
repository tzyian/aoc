defmodule AOC2025.Days.Day10 do
  @moduledoc """
  Solution for Advent of Code Day 10.
  """

  @doc """
      iex> input = File.read!("inputs/day10_example.txt")
      iex> AOC2025.Days.Day10.part1(input)
      7
  """
  def part1(input) do
    # Implement Part 1 solution here
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {target, switches, _joltage} = parse_line(line)

      initial = 0
      queue = :queue.from_list([{initial, 0}])
      visited = MapSet.new([initial])
      bfs(target, switches, queue, visited)
    end)
    |> Enum.sum()
  end

  defp bfs(target, switches, queue, visited) do
    case :queue.out(queue) do
      {:empty, _} ->
        :inf

      {{:value, {^target, count}}, _} ->
        count

      {{:value, {state, count}}, new_queue} ->
        {new_queue, new_visited} =
          Enum.reduce(switches, {new_queue, visited}, fn switch, {q, visited} ->
            new_state = Bitwise.bxor(state, switch)

            if MapSet.member?(visited, new_state) do
              {q, visited}
            else
              {:queue.in({new_state, count + 1}, q), MapSet.put(visited, new_state)}
            end
          end)

        bfs(target, switches, new_queue, new_visited)
    end
  end

  defp parse_line(line) do
    line =
      String.split(line, " ")

    target =
      line
      |> hd
      |> remove_brackets()
      |> to_targetbits()

    switches =
      line
      |> tl
      |> Enum.reverse()
      |> Enum.drop(1)
      |> Enum.map(fn switch ->
        switch
        |> remove_brackets()
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> to_switchbits()
      end)

    joltage =
      line
      |> Enum.reverse()
      |> hd
      |> remove_brackets()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    {target, switches, joltage}
  end

  defp remove_brackets(s) do
    n = String.length(s)
    String.slice(s, 1, n - 2)
  end

  defp to_targetbits(s) do
    s
    |> String.reverse()
    |> String.replace(".", "0")
    |> String.replace("#", "1")
    |> String.to_integer(2)
  end

  defp to_switchbits(nums) do
    Enum.reduce(nums, 0, fn x, acc ->
      # acc | (1 << x)
      bit = Bitwise.bsl(1, x)
      Bitwise.bor(acc, bit)
    end)
  end

  # TODO:
  # NOTE:

  # Easier solution without needing ILP:
  # https://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/

  # Very rough idea of what LP and ILP are::
  # Linear Programming is given an objective function (minimise Z = sum x_i) and a set of inequality constraints (in this case Ax = b)
  # Use the Simplex algorithm.
  # Simplex algorithm adds slack variables to remove all inequalities,
  # then pivots to vertices to find an optimal solution.
  # The optimum is guaranteed to be at a vertex.
  # The optimal solution gives a lower bound on the integer solution.

  # ILP is harder than LP because the integer solution space is not convex.
  # Because Simplex can return fractional solutions, we need to branch and bound to find integer solutions.
  # Branch and bound explores the search tree, by adding constraints e.g. x1=27.5, then branch x1<=27 or x1>=28.
  # Then rerun Simplex, pruning fathomed branches (branches which give a worse solution than the best known integer solution).
  # Until optimum integral solution is found

  @doc """
      iex> input = File.read!("inputs/day10_example.txt")
      iex> AOC2025.Days.Day10.part2(input)
      :not_implemented
      # 33
  """

  def part2(input) do
    # Implement Part 2 solution here
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {_target, switches, joltage} = parse_line(line)
      solve(switches, joltage)
    end)
    |> Enum.sum()

    :not_implemented
  end

  defp solve(_switches, _joltage) do
    0
  end
end
