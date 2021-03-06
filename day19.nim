import re, strutils, tables

type Rules = Table[string, string]

proc parse: (Rules, seq[string]) =
    let parts = readFile("input19.txt").split("\n\n")
    for line in parts[0].splitLines():
        let bits = line.split(": ")
        result[0][bits[0]] = bits[1]
    result[1] = parts[1].splitLines()

let (rules, messages) = parse()

proc expand(rules: Rules, n: string): string =
    let rule = rules[n]
    if rule.startsWith('"'):
        return rule.strip(chars={'"'})

    for s in rule.findAll(re"(\d+|\||\+)"):
        case s:
        of "|", "+":
            result &= s
        else:
            result &= expand(rules, s)

    if '|' in result:
        result = "(?:" & result & ")"

proc part1: int =
    let regex = re("^" & expand(rules, "0") & "$")
    for message in messages:
        if message.match(regex):
            inc result

proc part2: int =
    var rules = rules
    # 8: 42 | 42 8
    rules["8"] = "42+"
    # 11: 42 31 | 42 11 31
    rules["11"] = "42 31 | 42 42 31 31 | 42 42 42 31 31 31 | 42 42 42 42 31 31 31 31 | 42 42 42 42 42 31 31 31 31 31"
    let regex = re("^" & expand(rules, "0") & "$")
    for message in messages:
        if message.match(regex):
            inc result

echo part1()
echo part2()