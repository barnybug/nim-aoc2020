import sequtils, strutils, tables

type
    Coordinate = tuple[x, y: int]
    Instruction = tuple[command: char, n: int]

const N: Coordinate = (0, -1)
const E: Coordinate = (1, 0)
const S: Coordinate = (0, 1)
const W: Coordinate = (-1, 0)
const dirs = {'N': N, 'E': E, 'S': S, 'W': W}.toTable

proc `+`(a, b: Coordinate): Coordinate =
    (a.x + b.x, a.y + b.y)

proc `*`(a: Coordinate, n: int): Coordinate =
    (a.x * n, a.y * n)

proc manhattan(a: Coordinate): int = abs(a.x) + abs(a.y)

proc left(a: Coordinate, times: int): Coordinate =
    result = a
    for i in 0..<times:
        result = (result.y, -result.x)

proc right(a: Coordinate, times: int): Coordinate =
    result = a
    for i in 0..<times:
        result = (-result.y, result.x)

proc parse(line: string): Instruction =
    result.command = line[0]
    result.n = parseInt(line[1..^1])

let instructions = toSeq(lines "input12.txt").map(parse)

proc run(initialDir: Coordinate, waypoint: bool): int =
    var ship: Coordinate
    var dir = initialDir
    for i in instructions:
        if i.command in dirs:
            if waypoint:
                dir = dir + dirs[i.command] * i.n
            else:
                ship = ship + dirs[i.command] * i.n
        elif i.command == 'L':
            dir = dir.left(i.n div 90)
        elif i.command == 'R':
            dir = dir.right(i.n div 90)
        elif i.command == 'F':
            ship = ship + dir * i.n

    result = ship.manhattan

proc part1: int =
    run(E, false)

proc part2: int =
    run(N + E * 10, true)

proc run* =
    echo part1()
    echo part2()
