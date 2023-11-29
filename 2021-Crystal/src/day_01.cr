puts "--- Day 1: Sonar Sweep ---"

num_incs = 0

File
  .read_lines("#{__DIR__}/../inputs/day_01.txt")
  .map(&.to_i)
  .each_cons_pair do |m1, m2|
    num_incs += 1 if m2 > m1
  end


puts "Part 1: #{num_incs}"

num_incs = 0

File
  .read_lines("#{__DIR__}/../inputs/day_01.txt")
  .map(&.to_i)
  .each_cons(3)
  .map(&.sum)
  .each_cons_pair do |m1, m2|
    num_incs += 1 if m2 > m1
  end

puts "Part 2: #{num_incs}"
