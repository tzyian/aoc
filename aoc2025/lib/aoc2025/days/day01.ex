defmodule AOC2025.Days.Day01 do
  alias Day01

  @doc """
      iex> input = File.read!("inputs/day01_example.txt")
      iex> AOC2025.Days.Day01.part1(input)
      3
  """

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({50, 0}, &rotate/2)
    |> elem(1)
  end

  defp rotate(instr, {point, count}) do
    {dir, dist} = String.split_at(instr, 1)
    dist = String.to_integer(dist)

    signed_dist = if dir == "L", do: -dist, else: dist

    point =
      (point + signed_dist)
      |> Integer.mod(100)

    case point do
      0 -> {point, count + 1}
      _ -> {point, count}
    end
  end

  @doc """
      iex> input = File.read!("inputs/day01_example.txt")
      iex> AOC2025.Days.Day01.part2(input)
      6
  """
  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({50, 0}, &rotate2/2)
    |> elem(1)
  end

  defp rotate2(instr, {point, count}) do
    full = 100

    {dir, dist} = String.split_at(instr, 1)
    dist = String.to_integer(dist)

    signed_dist = if dir == "L", do: -dist, else: dist

    target = point + signed_dist

    new_point = Integer.mod(target, full)

    offset = if dir == "L", do: -1, else: 0
    # offset needed to deal with boundary when going left
    cycles = Integer.floor_div(target + offset, full) - Integer.floor_div(point + offset, full)

    new_count = count + abs(cycles)

    {new_point, new_count}
  end
end
