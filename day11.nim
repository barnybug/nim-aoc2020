import sequtils

const around = [(-1, -1), (0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0)]

proc part1: int =
    var grid = toSeq(lines "input11.txt")
    let height = len grid
    let width = len grid[0]
    var counts = newSeqWith(height, newSeq[uint8](width))

    while true:
        var next = grid
        var nextCounts = counts
        var changed = false
        for y, row in next.pairs:
            for x, c in row:
                if c == 'L' and counts[y][x] == 0:
                    next[y][x] = 'O'
                    changed = true
                    inc result
                    for (i, j) in around:
                        if x+i >= 0 and y+j >= 0 and x+i < width and y+j < height:
                            inc nextCounts[y+j][x+i]
                elif c == 'O' and counts[y][x] >= 4:
                    next[y][x] = 'L'
                    changed = true
                    dec result
                    for (i, j) in around:
                        if x+i >= 0 and y+j >= 0 and x+i < width and y+j < height:
                            dec nextCounts[y+j][x+i]

        if not changed:
            break
        grid = next
        counts = nextCounts

proc part2: int =
    var grid = toSeq(lines "input11.txt")
    let height = len grid
    let width = len grid[0]

    while true:
        var next = grid
        var changed = false

        for y, row in next.pairs:
            for x, c in row:
                if c == '.': continue
                var surrounding = 0
                for (dx, dy) in around:
                    for i in 1..99:
                        var (ax, ay) = (x + dx * i, y + dy * i)
                        if ax < 0 or ax >= width: break
                        if ay < 0 or ay >= height: break
                        if grid[ay][ax] == 'O':
                            inc surrounding
                            break
                        if grid[ay][ax] == 'L':
                            break

                    # bail early
                    if c == 'L' and surrounding > 0:
                        break
                    elif c == 'O' and surrounding >= 5:
                        break
                
                if c == 'L' and surrounding == 0:
                    changed = true
                    next[y][x] = 'O'
                    inc result
                elif c == 'O' and surrounding >= 5:
                    changed = true
                    next[y][x] = 'L'
                    dec result
                # else no change

        if not changed:
            break
        grid = next

proc run* =
    echo part1()
    echo part2()

