import sequtils

proc trees(lines: openarray[string], xstride: int, ystride: int = 1): int =
    var ret = 0
    for y, item in lines.pairs:
        if y mod ystride != 0:
            continue
        let x = (y div ystride * xstride) mod len(item)
        if item[x] == '#':
            inc ret
    return ret

let lines = toSeq(lines "input03.txt")
proc part1: int =
    trees(lines, 3)
proc part2: int =
    trees(lines, 1) *
    trees(lines, 3) *
    trees(lines, 5) *
    trees(lines, 7) *
    trees(lines, 1, 2)

echo part1()
echo part2()
