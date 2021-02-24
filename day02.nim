import math, sequtils, strutils

type Rule = tuple[a: int, b: int, letter: char, pw: string]

proc parseLine(line: string): Rule =
    let parts = split(line, {' ', ':', '-'})
    result.a = parseInt(parts[0])
    result.b = parseInt(parts[1])
    result.letter = parts[2][0]
    result.pw = parts[4]

let lines = toSeq(lines "input02.txt").map(parseLine)
proc part1: int =
    for rule in lines.items:
        let c = rule.pw.count(rule.letter)
        if c in rule.a..rule.b: inc result 

proc part2: int =
    for rule in lines.items:
        let a = rule.pw[rule.a-1]
        let b = rule.pw[rule.b-1]
        if (a == rule.letter) != (b == rule.letter):
            inc result

echo part1()
echo part2()