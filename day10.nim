import algorithm, sequtils, strutils

proc diff: seq[int] =
    var numbers = @[0] & toSeq(lines "input10.txt").map(parseInt)
    numbers.sort()
    numbers.add(numbers[^1]+3) # end
    for (a, b) in zip(numbers[0..^2], numbers[1..^1]):
        result.add(b-a)

let diffs = diff()

proc part1: int =
    return diffs.count(1) * diffs.count(3)

proc countOneGroups(diffs: seq[int]): seq[int] = 
    var run = 0
    for n in diffs.items:
        if n == 1:
            run += 1
        elif run > 0:
            result.add run
            run = 0

proc part2: int =
    assert 2 notin diffs # The differences are only 1 or 3.
    # A 3-differences pin both in the pair as required, so problem breaks down into combinations of the isolated 1 groups.
    let ones = countOneGroups(diffs)
    # Size of the 1-group determines how many combinations this individual group contributes.
    # 1x1: 1 (0 1)
    # 2x1: 2 (0 1 2 or 0 2)
    # 3x1: 4 (0 1 2 3, 0 1 3, 0 2 3, 0 3)
    # 4x1: 7 (0 1 2 3 4, 0 1 2 4, 0 1 3 4, 0 2 3 4, 0 1 4, 0 2 4, 0 3 4)
    # (nothing larger encountered)
    const combs = [0, 1, 2, 4, 7]
    # Finally, multiply up the separate combinations.
    result = 1
    for i in ones:
        result *= combs[i]

proc run* =
    echo part1()
    echo part2()

