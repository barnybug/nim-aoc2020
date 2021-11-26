import streams

proc readValue(ss: Stream, c: char): int =
    result = ord(c) - ord('0')
    while ss.peekChar in '0'..'9':
        result = result * 10 + ord(ss.readChar) - ord('0')

proc rewind(ss: Stream) =
    ss.setPosition(ss.getPosition-1)

proc parse(ss: Stream, part2: bool, ps: bool = false): int =
    # part2: + over *, left-right
    var op = '^'
    var bits: string
    while not ss.atEnd:
        let c = ss.readChar
        bits = bits & $c
        case c:
        of '0'..'9', '(':
            let value = if c == '(':
                parse(ss, part2, true)
            else:
                readValue(ss, c)
            if op == '^':
                result = value
            elif op == '*':
                result *= value
            elif op == '+':
                result += value
        of '*', '+':
            op = c
            if op == '*' and part2: # for part2, recurse here for lower precedence '*' operator
                result *= parse(ss, part2)
        of ')':
            if not ps:
                ss.rewind
            break
        else:
            discard

proc part1: int =
    for line in lines "input18.txt":
        result += parse(line.newStringStream, false)

proc part2: int =
    for line in lines "input18.txt":
        result += parse(line.newStringStream, true)

proc run* =
    echo part1()
    echo part2()


