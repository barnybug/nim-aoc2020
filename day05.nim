import algorithm, sequtils

proc seat_id(line: string): int =
    for c in line:
        result *= 2
        if c in {'B', 'R'}:
            inc result

var seat_ids = toSeq(lines "input05.txt").map(seat_id)
seat_ids.sort()

proc part1: int = seat_ids[^1]

proc part2: int =
    for i in low(seat_ids)..high(seat_ids):
        if seat_ids[i]+2 == seat_ids[i+1]:
            return seat_ids[i]+1
    
proc run* =
    echo part1()
    echo part2()

