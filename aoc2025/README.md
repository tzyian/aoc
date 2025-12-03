# Advent of Code 2025

1. Put files within `inputs/` in the format `dayDD.txt`, where `DD` is 0-padded, examples take the form of `dayDD_example.txt`
2. Boilerplate can be generated using `mix aoc.generate [DAY]`, which will generate `lib/aoc2025/days/dayDD.ex` and `test/aoc2025/dayDD_test.exs`
2. To run, do 
  `mix aoc.run DAY [PART] [--file <input_path>] [--example]`
  or in IEX:
  `iex> AOC2025.Runner.run_file(1, 1)`
  or use the module directly
3. Doctests can be run using `mix test`



