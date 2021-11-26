import math, sequtils, strutils, combinatorics

proc solve(numbers: openarray[int], n: int): int =
    for combination in combinations(numbers, n):
        if sum(combination) == 2020:
            return prod(combination)

var numbers = toSeq(lines "input01.txt").map(parseInt)

proc part1: int = solve(numbers, 2)
proc part2: int = solve(numbers, 3)

proc run* =
    echo part1()
    echo part2()
