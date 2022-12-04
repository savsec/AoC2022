defmodule Aoc2022Test do
  use ExUnit.Case
  doctest Aoc2022


  test "day 1" do
    day_1 = File.read!("data/day1.txt")
    assert Aoc2022.day1(day_1) == 71124
  end

  test "day 1 part 2" do
    day_1 = File.read!("data/day1.txt")
    assert Aoc2022.day1_part2(day_1) == 204639
  end

  test "day 2 part 1" do
    input = File.read!("data/day2.txt")
    assert Aoc2022.day2(input) == 13446
  end

  test "day 2 part 2" do
    input = File.read!("data/day2.txt")
    assert Aoc2022.day2_part2(input) == 13509
  end

  test "day 3 part 1" do
    input = File.read!("data/day3.txt")
    assert Aoc2022.day3_part1(input) == 7872
  end

  test "day 3 part 2" do
    input = File.read!("data/day3.txt")
    assert Aoc2022.day3_part2(input) == 2497
  end

  test "day 4 part 1" do
    input_1 = "1-2,2-3\n3-5,2-4\n2-6,3-5\n"
    input = File.read!("data/day4.txt")
    assert Aoc2022.day4_part1(input_1)==1
    assert Aoc2022.day4_part1(input) == 477
  end

  test "day 4 part 2" do
    input_1 = "1-2,2-3\n3-5,2-4\n2-6,3-5\n"
    input = File.read!("data/day4.txt")
    assert Aoc2022.day4_part2(input_1)==3
    assert Aoc2022.day4_part2(input) == 830
  end
end
