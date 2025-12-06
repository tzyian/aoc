defmodule Mix.Tasks.Aoc.Generate do
  use Mix.Task

  @shortdoc "Generate boilerplate for a new Advent of Code day: mix aoc.generate [DAY]"

  @moduledoc """
  Generate boilerplate code for a new Advent of Code day.

  Usage:
    mix aoc.generate DAY

  Example:
    mix aoc.generate 1

  This will create:
    - lib/aoc2025/days/day01.ex
    - test/aoc2025/days/day01_test.exs
    - inputs/day01.txt
    - inputs/day01_example.txt
  """

  defp pad_day(d) when d < 10, do: "0#{d}"
  defp pad_day(d), do: "#{d}"

  def run([day_str]) do
    Mix.Task.run("app.start")

    day = String.to_integer(day_str)
    day_padded = pad_day(day)

    module_name = "AOC2025.Days.Day#{day_padded}"

    # Create the day module file
    day_module_path = "lib/aoc2025/days/day#{day_padded}.ex"

    unless File.exists?(day_module_path) do
      File.write!(day_module_path, """
      defmodule #{module_name} do
        @moduledoc \"""
        Solution for Advent of Code Day #{day}.
        \"""

        @doc \"""
            iex> input = File.read!("inputs/day#{day_padded}_example.txt")
            iex> AOC2025.Days.Day#{day_padded}.part1(input)
            :not_implemented
        \"""
        def part1(input) do
          # Implement Part 1 solution here
          :not_implemented
        end

        @doc \"""
            iex> input = File.read!("inputs/day#{day_padded}_example.txt")
            iex> AOC2025.Days.Day#{day_padded}.part2(input)
            :not_implemented

        \"""
        def part2(input) do
          # Implement Part 2 solution here
          :not_implemented
        end
      end
      """)

      Mix.shell().info("Created #{day_module_path}")
    else
      Mix.shell().info("#{day_module_path} already exists, skipping.")
    end

    # Create the test file
    test_file_path = "test/aoc2025/days/day#{day_padded}_test.exs"

    unless File.exists?(test_file_path) do
      File.write!(test_file_path, """
      defmodule #{module_name}Test do
        use ExUnit.Case, async: true, async: true
        doctest AOC2025.Days.Day#{day_padded}

      end
      """)

      Mix.shell().info("Created #{test_file_path}")
    else
      Mix.shell().info("#{test_file_path} already exists, skipping.")
    end

    # Create input files
    input_file_path = "inputs/day#{day_padded}.txt"

    unless File.exists?(input_file_path) do
      File.write!(input_file_path, "")
      Mix.shell().info("Created #{input_file_path}")
    else
      Mix.shell().info("#{input_file_path} already exists, skipping.")
    end

    example_input_file_path = "inputs/day#{day_padded}_example.txt"

    unless File.exists?(example_input_file_path) do
      File.write!(example_input_file_path, "")
      Mix.shell().info("Created #{example_input_file_path}")
    else
      Mix.shell().info("#{example_input_file_path} already exists, skipping.")
    end
  end
end
