import math, sequtils, strutils

type Rule = tuple[a: int, b: int, letter: char, pw: string]

proc parseLine(line: string): Rule =
    let parts = split(line, {' ', ':', '-'})
    let a = parseInt(parts[0])
    let b = parseInt(parts[1])
    let letter = parts[2][0]
    let pw = parts[4]
    return (a, b, letter, pw)

proc valid1(rule: Rule): bool =
    let c = count(rule.pw, rule.letter)
    return rule.a <= c and c <= rule.b

proc valid2(rule: Rule): bool =
    let a = rule.pw[rule.a-1]
    let b = rule.pw[rule.b-1]
    return (a == rule.letter) != (b == rule.letter)

var lines = toSeq(lines "input02.txt").map(parseLine)
echo count(lines.map(valid1), true)
echo count(lines.map(valid2), true)