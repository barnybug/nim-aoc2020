import re, sets, tables
# from collections import Counter

type
    Point = tuple[x, y: int]
    Grid = HashSet[Point]

const STEPS = {
    "e": (x: 2, y: 0),
    "se": (x: 1, y: 1),
    "sw": (x: -1, y: 1),
    "w": (x: -2, y: 0),
    "nw": (x: -1, y: -1),
    "ne": (x: 1, y: -1),
}.toTable

proc `+`(a, b: Point): Point = (a.x + b.x, a.y + b.y)

proc run_steps: Grid =
    for line in lines "input24.txt":
        var p: Point
        for m in line.findAll(re"e|se|sw|w|nw|ne"):
            let step = STEPS[m]
            p = p + step

        if p in result:
            result.excl(p)
        else:
            result.incl(p)

proc part1: int =
    len run_steps()

proc part2: int =
    var grid = run_steps()
    for _ in 1..100:
        var adjacent: CountTable[Point]
        for p in grid:
            for step in STEPS.values:
                adjacent.inc(p + step)
        var newgrid: Grid
        for p, count in adjacent:
            if count == 2 or (p in grid and count == 1):
                newgrid.incl p
        grid = newgrid
    return len(grid)

proc run* =
    echo part1()
    echo part2()
