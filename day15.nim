proc solve(data: openArray[int], nth: int): int =
    var seen = newSeq[int](nth)
    for i, n in data:
        seen[n] = i+1
    for i in data.len+1 ..< nth:
        let temp = (if seen[result] > 0: i - seen[result] else: 0)
        seen[result] = i
        result = temp
    
const input = [0,5,4,1,10,14,7]
proc part1: int = solve(input, 2020)
proc part2: int = solve(input, 30000000)

echo part1()
echo part2()
