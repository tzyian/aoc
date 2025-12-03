defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  @shortdoc "Run Advent of Code solutions: mix aoc.run DAY [PART] [--file path]"

  @moduledoc """
  Run a day's solution quickly from the command line.

  Usage:
    mix aoc.run DAY [PART] [--file path]

  Examples:
    mix aoc.run 1
    mix aoc.run 1 2
    mix aoc.run 1 --file inputs/day01.txt
  """

  def run(argv) do
    Mix.Task.run("app.start")

    {opts, args, _} = OptionParser.parse(argv, switches: [file: :string, example: :boolean])

    {day, part} =
      case args do
        [day_str] ->
          {String.to_integer(day_str), 1}

        [day_str, part_str] ->
          {String.to_integer(day_str), String.to_integer(part_str)}

        _ ->
          Mix.shell().info(@moduledoc)
          System.halt(1)
      end

    try do
      {time, result} = AOC2025.Runner.run_file(day, part, opts[:file], opts[:example])

      Mix.shell().info(
        "Day #{day} Part #{part} #{if opts[:example], do: "Example", else: ""} Result (#{time}s):\n#{inspect(result)}"
      )
    rescue
      e in File.Error ->
        Mix.shell().error("Input file not found: #{e.path}")
        System.halt(1)

      _e in UndefinedFunctionError ->
        Mix.shell().error("Day #{day} Part #{part} is not implemented yet.")
        System.halt(1)

      e ->
        Mix.shell().error("Unexpected error: #{Exception.message(e)}")
        System.halt(1)
    end
  end
end
