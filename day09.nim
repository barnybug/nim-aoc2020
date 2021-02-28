import common, sequtils, strutils

var numbers = toSeq(lines "input09.txt").map(parseInt)

proc solve(preamble: int = 25): Answer =
    for i in preamble..high numbers:
        block loop:
            for a in (i-preamble)..<i-1:
                for b in a+1..<i:
                    let pair = numbers[a]+numbers[b]
                    if numbers[i] == pair:
                        break loop
            result.part1 = numbers[i]
            break

    for i in numbers.low..numbers.high:
        var s = 0
        for j in i..numbers.high:
            s += numbers[j]
            if s == result.part1:
                result.part2 = min(numbers[i..j]) + max(numbers[i..j])
                return
            if s > result.part1:
                break # bailout early

echo solve()