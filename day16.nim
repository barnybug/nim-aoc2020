import common, sequtils, strutils, strscans

type Rule = object
    name: string
    a, b, c, d: int

let parts = (readFile "input16.txt").split("\n\n")

proc valueset(rule: Rule): set[uint16] =
    {uint16(rule.a)..uint16(rule.b)} + {uint16(rule.c)..uint16(rule.d)}

proc parse: (seq[Rule], seq[int], seq[seq[int]]) =
    for line in parts[0].splitLines:
        var rule: Rule
        if line.scanf("$*: $i-$i or $i-$i", rule.name, rule.a, rule.b, rule.c, rule.d):
            result[0].add rule
    for n in parts[1].split({'\n', ','})[1..^1]:
        result[1].add parseInt(n)
    for line in parts[2].splitLines()[1..^1]:
        result[2].add parseIntList(line)

let (rules, your_ticket, nearby_tickets) = parse()

proc solve: Answer =
    var all_numbers: set[uint16]
    for rule in rules:
        all_numbers = all_numbers + rule.valueset

    var valid_tickets: seq[seq[int]]
    for ticket in nearby_tickets:
        var all_valid = true
        for num in ticket:
            if uint16(num) notin all_numbers:
                all_valid = false
                result.part1 += num
        if all_valid:
            valid_tickets.add ticket

    var potential_fields: seq[set[uint16]]
    for column in 0..<rules.len:
        var values: set[uint16]
        for ticket in valid_tickets:
            values.incl uint16(ticket[column])

        var fields: set[uint16]
        for field, rule in rules:
            if values <= rule.valueset:
                fields.incl uint16(field)
        potential_fields.add fields
    
    var unsolved = {0..uint16(rules.high)}
    var answers = newSeq[uint16](rules.len)
    while unsolved.len > 0:
        for col in unsolved:
            if potential_fields[col].len == 1:
                let answer = toSeq(potential_fields[col])[0]
                unsolved.excl col
                answers[col] = answer
                for other in unsolved:
                    potential_fields[other].excl answer

    result.part2 = 1
    for i, answer in answers:
        if rules[answer].name.startswith("departure "):
            result.part2 *= your_ticket[i]

proc run* =
    echo solve()

