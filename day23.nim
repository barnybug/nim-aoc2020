proc play(cups: seq[int], times: int): seq[int] =
    let n = max(cups)
    result = newSeq[int](n+1)
    for i in 0..<n:
        result[cups[i]] = cups[(i+1) mod n]

    var current = cups[0]
    for i in 1..times:
        let a = result[current]
        let b = result[a]
        let c = result[b]
        result[current] = result[c]
        var destination = current
        while true:
            dec destination
            if destination < 1:
                destination = n
            if destination != a and destination != b and destination != c:
                break
        
        result[c] = result[destination]
        result[destination] = a
        current = result[current]

const data = @[2, 5, 3, 1, 4, 9, 8, 6, 7]

proc part1: string =
    let nodes = play(data, 100)
    var i = 1
    while true:
        i = nodes[i]
        if i == 1:
            break
        result = result & $i

proc part2: int =
    var cups = data
    for i in 9..<1000000:
        cups.add(i+1)
    let nodes = play(cups, 10000000)
    result = nodes[1] * nodes[nodes[1]]

echo part1()
echo part2()