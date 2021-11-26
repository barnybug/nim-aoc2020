import sequtils, strutils

proc parse: (int, seq[(int, int)]) =
    let ls = toSeq(lines "input13.txt")
    result[0] = parseInt(ls[0])
    let buses = ls[1].split(",")
    for i, bus in buses.pairs:
        if bus != "x":
            result[1].add (i, parseInt(bus))

let (target, buses) = parse()

proc part1: int =
    var nearest = int.high
    for (_, bus) in buses:
        var wait = bus - (target mod bus)
        if wait < nearest:
            nearest = wait
            result = wait * bus

proc mulInv(a0, b0: int): int =
    var (a, b, x0) = (a0, b0, 0)
    result = 1
    if b == 1: return
    while a > 1:
        let q = a div b
        a = a mod b
        swap a, b
        result = result - q * x0
        swap x0, result
    if result < 0: result += b0
 
proc chineseRemainder[T](n, a: T): int =
    var prod = 1
    var sum = 0
    for x in n: prod *= x
 
    for i in 0..<n.len:
        let p = prod div n[i]
        sum += a[i] * mulInv(p, n[i]) * p
 
    sum mod prod

proc part2: int =
    # Buses timings are a series of constraints:
    # t + 0 = 0 mod b1, t + 1 = 0 mod b2, ...
    # So solve for (Chinese Remainder Theorem):
    # t = 0 mod b1, t = -1 mod b2, etc.
    # b1, b2 should be co-prime (which fortunately they are)
    var nn, aa: seq[int]
    for (a, n) in buses:
        aa.add n-a
        nn.add n
    return chineseRemainder(nn, aa)

proc run* =
    echo part1()
    echo part2()
