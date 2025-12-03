defmodule AOC2025.Runner do
  @moduledoc """
  Module to run Advent of Code solutions for a given day and part,
  using an input file. If no file path is provided, it defaults to
  "inputs/dayDD_P.txt" where DD is the zero-padded day number and P
  is the part number.

  ## Example (not doctest):
  iex> AOC2025.Runner.run_file(1, 1)
  result # uses "inputs/day01_1.txt" by default

  iex> AOC2025.Runner.run_file(1, 1, "inputs/day01_1.txt")
  result

  """

  @spec run_file(integer(), integer(), String.t() | nil) :: {float(), any()}
  def run_file(day, part \\ 1, file_path \\ nil) when is_integer(day) and is_integer(part) do
    path =
      if file_path do
        Path.expand(file_path)
      else
        default_input_path(day)
      end

    input = File.read!(path)

    mod = Module.concat([AOC2025, Days, "Day#{pad_day(day)}"])
    fun = String.to_atom("part#{part}")

    {time, result} = :timer.tc(fn -> apply(mod, fun, [input]) end)
    {time / 1_000_000, result}
  end

  defp default_input_path(day) do
    Path.expand("inputs/day#{pad_day(day)}.txt")
  end

  defp pad_day(d) when d < 10, do: "0#{d}"
  defp pad_day(d), do: "#{d}"
end
