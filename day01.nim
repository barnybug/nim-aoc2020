import math, sequtils, strutils, combinatorics

proc solve(numbers: openarray[int], n: int): int =
    for combination in combinations(numbers, n):
        if sum(combination) == 2020:
            return prod(combination)

var numbers = toSeq(lines "input01.txt").map(parseInt)
echo solve(numbers, 2)
echo solve(numbers, 3)