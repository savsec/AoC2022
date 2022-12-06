defmodule Aoc2022 do

  # Day1
  def parse_input(str) do
    str 
    |> String.split("\n\n") 
    |> Enum.map(&String.split(&1, "\n", trim: true)) 
    |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)
  end

  def nlargest(lst, n) when n > 0 do
    [Enum.max(lst)| nlargest(List.delete(lst, Enum.max(lst)), n-1)]
  end

  def nlargest(_lst, 0) do
    []
  end

  def day1_part1(input) do
    input 
    |> parse_input() 
    |> Enum.map(&Enum.sum/1) 
    |> Enum.max()
  end

  def day1_part2(input) do
    input 
    |> parse_input() 
    |> Enum.map(&Enum.sum/1) 
    |> nlargest(3) 
    |> Enum.sum()
  end

  #Day2

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



  def day2_part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn s -> String.split(s, " ") end)
    |> Enum.map(fn s -> List.to_tuple(s) end)
    |> Enum.map(fn s -> scorer(s) end)
    |> Enum.sum()
  end

  def day2_part2(input) do input
    |> String.split("\n", trim: true)
    |> Enum.map(fn s -> String.split(s, " ") end)
    |> Enum.map(fn s -> List.to_tuple(s) end)
    |> Enum.map(fn s -> alt_scorer(s) end)
    |> Enum.sum()
  end


## Day3
#

  def compute_priorities(char) do
    [c|_tail] = char
    cond do
      c>=97 -> c-96
      c<97 -> c-(65-27)
    end 
  end

  def split_charlist(chrlst) do
    half = round(length(chrlst)/2)
    Enum.chunk_every(chrlst, half)
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
    |> Enum.map(&to_charlist/1)
    |> Enum.map(&split_charlist/1)
    |> Enum.map(&List.to_tuple/1)   
    |> Enum.map(&find_similar_char/1) 
    |> Enum.map(&compute_priorities/1)
    |> Enum.sum()
  end

  def day3_part2(input) do
    input 
    |> String.split("\n", trim: true)
    |> Enum.map(&to_charlist/1)
    |> Enum.chunk_every(3)
    |> Enum.map(&List.to_tuple/1)   
    |> Enum.map(&find_common_char/1) 
    |> Enum.map(&compute_priorities/1)
    |> Enum.sum()
  end

  # Day4
  
  def day4_parser(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1,","))
    |> Enum.map(fn x -> Enum.map(x, &String.split(&1, "-")) end)
    |> Enum.map(fn x -> Enum.map(x, fn y -> Enum.map(y, &String.to_integer/1) end) end)
    |> Enum.map(fn x -> Enum.map(x, &List.to_tuple/1) end)
    |> Enum.map(&List.to_tuple/1)
  end

  def inside_check(two_tuples) do
    {tuple1, tuple2} = two_tuples
    {begin_section1, end_section1} = tuple1
    {begin_section2, end_section2} = tuple2
    cond do
      begin_section1 >= begin_section2 and end_section1 <= end_section2 -> 1
      begin_section1 <= begin_section2 and end_section1 >= end_section2 -> 1
      true -> 0
    end
  end

  def overlap_check(two_tuples) do
    {tuple1, tuple2} = two_tuples
    {begin_section1, end_section1} = tuple1
    {begin_section2, end_section2} = tuple2
    cond do
      begin_section1 <= begin_section2 and begin_section2 <= end_section1 -> 1
      begin_section2 <= begin_section1 and begin_section1 <= end_section2 -> 1
      true -> 0
    end
  end



  def day4_part1(input) do
    input
    |> day4_parser()
    |> Enum.map(fn x -> inside_check(x) end)
    |> Enum.sum()
  end

  def day4_part2(input) do
    input
    |> day4_parser()
    |> Enum.map(fn x -> overlap_check(x) end)
    |> Enum.sum()
  end 

  #Day5
  
  def fold_to_map(move_list) do
    move_list
    |> Enum.chunk_every(2)
    |> Map.new(fn [k,v] -> {String.to_atom(k), String.to_integer(v)} end)
  end

  def parse_moves(moves_string) do
    moves_string
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&fold_to_map/1)
  end

  def parse_crates(crate_string) do
    crate_string
    |> String.to_charlist()
    |> Enum.chunk_every(4)
    |> Enum.map(&to_string/1)
    |> Enum.map(fn x -> String.replace(x, ~r"[^[:upper:]]", "") end)
  end

  def parse_initial_position(some_lines) do
    [stacks | crates] = some_lines
    |> String.split("\n")
    |> Enum.reverse()
    stack_numbers = stacks 
                    |> String.split(" ", trim: true) 
                    |> Enum.map(&String.to_integer/1) 
    crate_letters = crates 
                    |> Enum.map(fn x -> parse_crates(x) end) 
                    |> Enum.zip()
                    |> Enum.map(&Tuple.to_list/1)
                    |> Enum.map(&Enum.reverse/1)
                    |> Enum.map(&Enum.join/1)
    Enum.zip(stack_numbers, crate_letters) |> Enum.into(%{})
  end

  def make_move(stack_crate_map, move, reverse \\ true) do
    {:ok, from_crate} = Map.fetch(stack_crate_map, move.from)
    {:ok, to_crate} = Map.fetch(stack_crate_map, move.to)
    nmoves = move.move
    moved_crates = cond do
      reverse -> from_crate |> String.slice(0..nmoves-1) |> String.reverse()
      true -> from_crate |> String.slice(0..nmoves-1)
    end
    updated_from_crate = from_crate |> String.slice(move.move..-1)
    updated_to_crate = moved_crates <> to_crate
    stack_crate_map = %{stack_crate_map | move.from => updated_from_crate} 
    %{stack_crate_map | move.to => updated_to_crate}
  end

  def make_all_moves(positions, list_of_moves, reverse) when list_of_moves != [] do
    [next_move | rest_of_moves] = list_of_moves
    new_positions = make_move(positions, next_move, reverse)
    make_all_moves(new_positions, rest_of_moves, reverse)
  end

  def make_all_moves(positions, [], _reverse) do
    positions
  end

  def day5_part1(input) do
    [starting_configs, moves_string | _] = input |> String.split("\n\n")
    stack_crate_map = parse_initial_position(starting_configs)
    moves = parse_moves(moves_string)
    make_all_moves(stack_crate_map, moves, true) 
    |> Enum.reduce("", fn ({_k,v}, acc) -> acc <> String.at(v, 0) end)
  end

  def day5_part2(input) do
    [starting_configs, moves_string | _] = input |> String.split("\n\n")
    stack_crate_map = parse_initial_position(starting_configs)
    moves = parse_moves(moves_string)
    make_all_moves(stack_crate_map, moves, false) 
    |> Enum.reduce("", fn ({_k,v}, acc) -> acc <> String.at(v, 0) end)
  end

end
