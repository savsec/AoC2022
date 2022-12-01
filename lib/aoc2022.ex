defmodule Aoc2022 do

  def parse_input(str) do
    mapped_split = fn(s) -> String.split(s, "\n", trim: true) end
    str |> String.split("\n\n") |> Enum.map(mapped_split) |> Enum.map(fn (l) -> Enum.map(l, fn s -> String.to_integer(s) end) end)
  end

  def nlargest(lst, n) when n > 0 do
    [Enum.max(lst)| nlargest(List.delete(lst, Enum.max(lst)), n-1)]
  end

  def nlargest(_lst, 0) do
    []
  end

  def day1(input) do
    input |> parse_input() |> Enum.map(fn l -> Enum.sum(l) end) |> Enum.max()
  end

  def day1_part2(input) do
    input |> parse_input() |> Enum.map(fn (l) -> Enum.sum(l) end) |> nlargest(3) |> Enum.sum()
  end

end
