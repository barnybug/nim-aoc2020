import intsets, sequtils, strutils

const groups = readFile("input06.txt").split("\n\n")

proc groupSet(group: string): IntSet =
    for c in group:
        if c != '\n':
            result.incl(int(c))

proc part1: int =
    for group in groups:
        result += groupSet(group).len
    
proc part2: int =
    for group in groups:
        let sets = group.split("\n").map(groupSet)
        let combined = foldl(sets, intersection(a, b))
        result += combined.len

echo part1()
echo part2()