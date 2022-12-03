defmodule Aoc2022 do

  def parse_input(str) do
    mapped_split = fn(s) -> String.split(s, "\n", trim: true) end
    str 
    |> String.split("\n\n") 
    |> Enum.map(mapped_split) 
    |> Enum.map(fn (l) -> Enum.map(l, fn s -> String.to_integer(s) end) end)
  end

  def nlargest(lst, n) when n > 0 do
    [Enum.max(lst)| nlargest(List.delete(lst, Enum.max(lst)), n-1)]
  end

  def nlargest(_lst, 0) do
    []
  end

  def rps_scorer(round) do
    {opponent, player} = round
    cond do
      opponent == "A" and player == "X" -> "D"
      opponent == "A" and player == "Y" -> "W"
      opponent == "A" and player == "Z" -> "L"
      opponent == "B" and player == "X" -> "L"
      opponent == "B" and player == "Y" -> "D"
      opponent == "B" and player == "Z" -> "W"
      opponent == "C" and player == "X" -> "W"
      opponent == "C" and player == "Y" -> "L"
      opponent == "C" and player == "Z" -> "D"
    end
  end

  def alt_rps_scorer(round) do
    {opponent, outcome} = round
    cond do
      opponent == "A" and outcome == "X" -> "S"
      opponent == "A" and outcome == "Y" -> "R"
      opponent == "A" and outcome == "Z" -> "P"
      opponent == "B" and outcome == "X" -> "R"
      opponent == "B" and outcome == "Y" -> "P"
      opponent == "B" and outcome == "Z" -> "S"
      opponent == "C" and outcome == "X" -> "P"
      opponent == "C" and outcome == "Y" -> "S"
      opponent == "C" and outcome == "Z" -> "R"
    end
  end


  def scorer(round) do
    {_opponent, player} = round
    outcome = rps_scorer(round)
    score = cond do
      outcome == "W" -> 6
      outcome == "D" -> 3
      outcome == "L" -> 0
    end
    cond do
      player == "X" -> score + 1
      player == "Y" -> score + 2
      player == "Z" -> score + 3
    end
  end

  def alt_scorer(round) do
    {_opponent, outcome} = round
    player = alt_rps_scorer(round)
    score = cond do
      outcome=="X" -> 0
      outcome=="Y" -> 3
      outcome=="Z" -> 6
    end
    cond do
      player=="R" -> score+1
      player=="P" -> score+2
      player=="S" -> score+3
    end
  end




  def day1(input) do
    input 
    |> parse_input() 
    |> Enum.map(fn l -> Enum.sum(l) end) 
    |> Enum.max()
  end

  def day1_part2(input) do
    input 
    |> parse_input() 
    |> Enum.map(fn (l) -> Enum.sum(l) end) 
    |> nlargest(3) 
    |> Enum.sum()
  end

  def day2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn s -> String.split(s, " ") end)
    |> Enum.map(fn s -> List.to_tuple(s) end)
    |> Enum.map(fn s -> scorer(s) end)
    |> Enum.sum()
  end

  def day2_part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn s -> String.split(s, " ") end)
    |> Enum.map(fn s -> List.to_tuple(s) end)
    |> Enum.map(fn s -> alt_scorer(s) end)
    |> Enum.sum()
  end


## Day 3
#

  def compute_priorities(char) do
    [c|tail] = char
    cond do
      c>=97 -> c-96
      c<97 -> c-(65-27)
    end 
  end

  def split_charlist(chrlst) do
    half = round(length(chrlst)/2)
    Enum.chunk_every(chrlst, half, half, [])
  end

  def find_similar_char(tuple_of_chrlsts) do
    {chrlst1, chrlst2} = tuple_of_chrlsts
    diff = chrlst1 -- chrlst2
    chrlst1 -- diff
  end

  def find_common_char(three_chrlsts) do
    {chrlst1, chrlst2, chrlst3} = three_chrlsts
    common12 = find_similar_char({chrlst1, chrlst2})
    common13 = find_similar_char({chrlst1, chrlst3})
    find_similar_char({common12, common13})
  end


  def day3_part1(input) do
    input 
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> to_charlist(x) end)
    |> Enum.map(fn x -> split_charlist(x) end)
    |> Enum.map(fn x -> List.to_tuple(x) end)
    |> Enum.map(fn x -> find_similar_char(x) end)
    |> Enum.map(fn x -> compute_priorities(x) end)
    |> Enum.sum()
  end

  def day3_part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> to_charlist(x) end)
    |> Enum.chunk_every(3)
    |> Enum.map(fn x -> List.to_tuple(x) end)
    |> Enum.map(fn x -> find_common_char(x) end) 
    |> Enum.map(fn x -> compute_priorities(x) end)
    |> Enum.sum()
  end


  

end
