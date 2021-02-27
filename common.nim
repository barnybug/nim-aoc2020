import strformat

type Answer* = tuple[part1: int, part2: int]

proc `$`*(answer: Answer): string = &"Part 1: {answer.part1}\nPart 2: {answer.part2}"
