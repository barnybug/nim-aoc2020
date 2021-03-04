import combinatorics, sets, sequtils, tables

proc solve(dims: int): int =
    var around = permutationsWithReplacement([-1, 0, 1], dims)
    keepIf(around) do (a: seq[int]) -> bool: anyIt(a, it != 0) # drop 0 0 0

    var start: HashSet[int]
    for y, line in toSeq(lines "input17.txt"):
        for x, c in line.pairs:
            if c == '#':
                var key = (x+128) + ((y+128) shl 8)
                for i in 2..<dims:
                    key += 128 shl (i*8)
                start.incl key

    for _ in 0..<6:
        var next: HashSet[int]
        var surround: CountTable[int]
        for coord in start:
            for delta in around:
                var ncoord = 0
                for i, d in delta:
                    ncoord += (((coord shr (i*8)) and 255) + d) shl (i*8)
                surround.inc(ncoord)
        for coord, count in surround:
            if coord in start and count in 2..3:
                next.incl coord
            elif coord notin start and count == 3:
                next.incl coord
        start = next

    return len(start)

proc part1: int = solve(3)
proc part2: int = solve(4)

echo part1()
echo part2()
