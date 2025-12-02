defmodule AOC2025.Days.Day02 do
  alias Day02

  @doc """
      iex> input = File.read!("inputs/day02_example.txt")
      iex> AOC2025.Days.Day02.part1(input)
      1227775554
  """
  def part1(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&count/1)
    |> Enum.sum()
  end

  @doc """
      iex> input = File.read!("inputs/day02_example.txt")
      iex> AOC2025.Days.Day02.part2(input)
      4174379265

      iex> input = File.read!("inputs/day02.txt")
      iex> AOC2025.Days.Day02.part2(input)
      31755323497

  """
  def part2(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&count2/1)
    |> Enum.sum()
  end

  defp count2(range) do
    [start_s, stop_s | _] = String.split(range, "-")
    start = String.to_integer(start_s)
    stop = String.to_integer(stop_s)
    iter2(start, stop, 0)
  end

  defp iter2(num, stop, sum) when num > stop, do: sum

  defp iter2(num, stop, sum) do
    # TODO: a non-brute force solution, to figure out how to do this
    # https://old.reddit.com/r/adventofcode/comments/1pbzqcx/2025_day_2_solutions/nruhu70/?context=3#nruhu70
    s = Integer.to_string(num)
    match = String.match?(s, ~r/^(.+)\1+$/)

    newsum = if match, do: sum + num, else: sum
    iter2(num + 1, stop, newsum)
  end

  # ===================================================

  defp count(range) do
    [start_s, stop_s | _] = String.split(range, "-")
    start = String.to_integer(start_s)
    stop = String.to_integer(stop_s)

    min_k = start_s |> String.length() |> div(2)
    min_k = max(min_k, 1)
    max_k = stop_s |> String.length() |> div(2)
    iter(start, stop, min_k, max_k, 0)
  end

  defp iter(_start, _stop, k, max_k, sum) when k > max_k, do: sum

  defp iter(start, stop, k, max_k, sum) do
    # All valid numbers are of the form
    # x = h * 10^k + h
    #   = h * (10^k + 1)
    #   = h * mult
    # where h is a k-digit number

    # Condition A:
    # x ∈ [start, stop]
    # start <= x <= end
    # start <= h * mult <= end
    # start/mult <= h <= end/mult

    # Condition B:
    # Since h is k-digit
    # h ∈ [10^(k-1), 10^k-1]
    # 10^(k-1) <= h <= 10^k-1

    # Then solve for h

    # Then do AP on the range
    # sum += AP * mult

    # E.g.
    # 100 to 999 is 10^k(100+101+...+999)+1(100+101+...+999)

    # k is in the range [len(start) / 2, len(stop) / 2]
    # TC ∈ O(log n), where n = stop

    min_x = Integer.pow(10, k - 1)
    max_x = Integer.pow(10, k) - 1

    mult = Integer.pow(10, k) + 1

    lo = Float.ceil(start / mult) |> trunc()
    hi = Float.floor(stop / mult) |> trunc()
    valid_start = max(min_x, lo)
    valid_stop = min(max_x, hi)

    ap =
      ((valid_stop + valid_start) * (valid_stop - valid_start + 1))
      |> div(2)

    sum =
      if valid_start <= valid_stop do
        sum + ap * mult
      else
        sum
      end

    iter(start, stop, k + 1, max_k, sum)
  end
end
