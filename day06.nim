import sequtils, strutils

const groups = readFile("input06.txt").split("\n\n")

proc groupSet(group: string): set[char] =
    for c in group:
        if c != '\n':
            result.incl(c)

proc part1: int {.locks: 0.} =
    for group in groups:
        result += groupSet(group).len
    
proc part2: int {.locks: 0.} =
    for group in groups:
        let sets = group.split("\n").map(groupSet)
        let combined = foldl(sets, a * b)
        result += combined.len

proc run* =
    echo part1()
    echo part2()
