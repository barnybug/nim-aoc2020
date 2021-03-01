import algorithm, common, strscans, strutils, tables

proc floatingMasks(mask: string): seq[int] =
    var xs: seq[int]
    for i, c in mask.reversed:
        if c == 'X': xs.add(i)
    for fuzz in 0 ..< 1 shl len(xs):
        var v: int
        for i, x in xs:
            if (fuzz and (1 shl i)) > 0:
                v = v or (1 shl x)
        result.add v

proc solve: Answer =
    var memory, memory2: Table[int, int]
    var ones, zeros, mask, address, value: int
    var floating: seq[int]
    var bitmask: string
    for line in lines "input14.txt":
        if scanf(line, "mask = $+", bitmask):
            floating = floatingMasks(bitmask)
            mask = parseBinInt(bitmask.replace('1', '0').replace('X', '1'))
            ones = parseBinInt(bitmask.replace('X', '0'))
        elif scanf(line, "mem[$i] = $i", address, value):
            memory[address] = (value and mask) or ones
            for f in floating:
                let faddr = (address and not mask) or ones or f
                memory2[faddr] = value

    for value in memory.values:
        result.part1 += value
    for value in memory2.values:
        result.part2 += value

echo solve()
