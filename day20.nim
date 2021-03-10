import bitops, common, strformat, strscans, strutils, tables

# pow2 = np.array([
#     [1 << i, 1 << (9-i)]
#     for i in range(10)
# ])

# class Tile:
#     def __init__(self, n, grid):
#         self.n = n
#         self.grid = grid
#         # precalculate useful numbers
#         # edge number - pick lowest of two invariant to flipping
#         self.t, self.tf = self.grid[0].dot(pow2)
#         self.bf, self.b = self.grid[-1].dot(pow2)
#         self.lf, self.l = self.grid[:,0].dot(pow2)
#         self.r, self.rf = self.grid[:,-1].dot(pow2)
#         self.edges = np.array([self.l, self.t, self.r, self.b])
#         self.potential_edges = {
#             self.t, self.tf,
#             self.b, self.bf,
#             self.l, self.lf,
#             self.r, self.rf,
#         }

#     def __repr__(self):
#         return f'''   {self.t:4d} {self.tf:4d}
# {self.lf:4d}  {self.n:4d}  {self.r:4d}
# {self.l:4d}  {self.n:4d}  {self.rf:4d}
#     {self.bf:4d} {self.b:4d}    '''

#     def edge_orientations(self):
#         # 16 orientations - 4 rotations, fliph+4 rotations, flipv+4rotations, transpose+4rotations
#         return [
#             np.roll([self.l, self.t, self.r, self.b], i) for i in range(0, 4)
#         ] + [
#             np.roll([self.rf, self.tf, self.lf, self.bf], i) for i in range(0, 4)
#         ] + [
#             np.roll([self.lf, self.bf, self.rf, self.tf], i) for i in range(0, 4)
#         ] + [
#             np.roll([self.tf, self.l, self.bf, self.r], i) for i in range(0, 4)
#         ]

#     def render(self, n):
#         return Tile(self.n, transformations(self.grid, n))

type Edge = uint16
type Tile = ref object
    n: uint16
    grid: array[10, Edge]
type Orient = tuple[left, top, right, bottom: Edge, tile: Tile, o: int]

proc line_to_bits(s: string): uint16 =
    for i in countdown(s.len-1, 0):
        result = result shl 1
        if s[i] == '#':
            inc result

proc parse_tile(data: string): Tile =
    result = new(Tile)
    let lines = data.splitLines()
    var n: int
    assert scanf(lines[0], "Tile $i", n)
    result.n = uint16(n)
    for i, line in lines[1..^1]:
        result.grid[i] = line_to_bits(line)

proc bits_to_line(l: uint16): string =
    for i in 0..9:
        result = result & (if l.testBit(i): "#" else: ".")

proc `$`(t: Tile): string =
    result = &"Tile: {t.n}\n"
    for l in t.grid:
        result = result & bits_to_line(l) & "\n"

proc parse: seq[Tile] =
    for data in readFile("input20.txt").split("\n\n"):
        result.add parse_tile(data)

let tiles = parse()

# NUM_TRANSFORMATIONS = 8

# def transformations(grid, i):
#     if i < 4:
#         return np.rot90(grid, -i)
#     elif 4 <= i < 8: # fliph
#         return np.rot90(np.flip(grid, axis=1), -i)

proc flip(e: Edge): Edge =
    reverseBits(e) shr 6

proc vertical(t: Tile, i: int): Edge =
    for j in countdown(9, 0):
        result = result shl 1
        if t.grid[j].testBit(i):
            inc result

proc rotate(t: Tile) =
    var grid: array[10, Edge]
    for i in 0..9:
        grid[i] = t.vertical(i).flip
    t.grid = grid

proc flip(t: Tile) =
    for i in 0..9:
        t.grid[i] = t.grid[i].flip

proc top(t: Tile): Edge = t.grid[0]
proc bottom(t: Tile): Edge = t.grid[^1]
proc left(t: Tile): Edge = t.vertical(0)
proc right(t: Tile): Edge = t.vertical(9)

proc potential_edges(t: Tile): seq[Edge] =
    result.add t.top
    result.add t.top.flip
    result.add t.bottom
    result.add t.bottom.flip
    result.add t.left
    result.add t.left.flip
    result.add t.right
    result.add t.right.flip

proc rotate(o: Orient): Orient =
    return (o.bottom, o.left.flip, o.top, o.right.flip, o.tile, o.o+1)

proc flip(o: Orient): Orient =
    return (o.right, o.top.flip, o.left, o.bottom.flip, o.tile, o.o+4)

proc render(o: Orient): Tile =
    result = new(Tile)
    result.n = o.tile.n
    result.grid = o.tile.grid
    if o.o >= 4:
        result.flip
        # echo "flipped:\n", result
    for _ in 1..(o.o mod 4):
        result.rotate
        # echo "rotation:\n", result

proc `$`(o: Orient): string =
    &"{o.o} {o.left} {o.top} {o.right} {o.bottom}\n{o.render}"

iterator orientations(tile: Tile): Orient =
    var result: Orient = (tile.left, tile.top, tile.right, tile.bottom, tile, 0)
    var flipped = result.flip
    yield result
    for _ in 1..3:
        result = result.rotate
        yield result

    yield flipped
    for _ in 1..3:
        flipped = flipped.rotate
        yield flipped

proc edges_and_corners(tiles: seq[Tile]): (set[Edge], seq[Tile]) =
    var edge_count: CountTable[Edge]
    for tile in tiles:
        for edge in tile.potential_edges:
            edge_count.inc edge

    # outer edges are unique
    for edge, count in edge_count:
        if count == 1:
            result[0].incl edge

    # a corner has 4 outer edges (normal and flipped)
    for tile in tiles:
        var outer_edges = 0
        for edge in tile.potential_edges:
            if edge_count[edge] == 1:
                inc outer_edges
        if outer_edges == 4:
            result[1].add tile

type Layout = array[12, array[12, Orient]]
type Board = array[96, array[96, bool]]

proc rotate(board: Board): Board =
    for y, row in board:
        for x, b in row:
            result[x][row.high-y] = b

proc flip(board: Board): Board =
    for i, row in board:
        for j in 0..row.high:
            result[i][j] = row[^(j+1)]

proc combine_layout(layout: Layout): Board =
    for y, row in layout:
        for x, orient in row:
            let tile = orient.render
            # ignore border
            for i in 1..8:
                for j in 1..8:
                    result[y*8+i-1][x*8+j-1] = ((tile.grid[i] shr j) and 1) == 1

proc count_snakes(board: Board): int =
    # ..................1.
    # 1....11....11....111
    # .1..1..1..1..1..1...
    for y in 0..<board.len-2:
        for x in 0..76:
            let r1 = board[y][x..^1]
            let r2 = board[y+1][x..^1]
            let r3 = board[y+2][x..^1]
            if r1[18] and r2[0] and r2[5] and r2[6] and r2[11] and r2[12] and r2[17] and r2[18] and r2[19] and r3[1] and r3[4] and r3[7] and r3[10] and r3[13] and r3[16]:
                inc result
            if r1[1] and r2[19] and r2[14] and r2[13] and r2[8] and r2[7] and r2[2] and r2[1] and r2[0] and r3[18] and r3[15] and r3[12] and r3[9] and r3[6] and r3[3]:
                inc result

proc count(board: Board): int =
    for row in board:
        for b in row:
            if b: inc result

proc `$`(board: Board): string =
    for row in board:
        for b in row:
            result &= (if b: "#" else: ".")
        result &= "\n"

proc solve: Answer =
    let (edges, corners) = edges_and_corners(tiles)
    assert len(edges) == 96 # 12*4*2
    assert len(corners) == 4

    result.part1 = 1
    for tile in corners:
        result.part1 *= int(tile.n)

    var lookup: Table[(Edge, Edge), Orient]
    for tile in tiles:
        for orient in tile.orientations:
            lookup[(orient.left, orient.top)] = orient

    var start_orient: Orient
    for orient in corners[0].orientations:
        if orient.left in edges and orient.top in edges:
            start_orient = orient
            break

    const size = 12
    var layout: Layout
    var used: set[uint16]
    for y in 0..<size:
        for x in 0..<size:
            var picked: Orient
            if x == 0 and y == 0:
                picked = start_orient
            elif x == 0:
                for key, orient in lookup:
                    if orient.tile.n in used: continue
                    if orient.top == layout[y-1][x].bottom and orient.left in edges:
                        picked = orient
                        break
            elif y == 0:
                for key, orient in lookup:
                    if orient.tile.n in used: continue
                    if orient.left == layout[y][x-1].right and orient.top in edges:
                        picked = orient
                        break
            else:
                picked = lookup[(layout[y][x-1].right, layout[y-1][x].bottom)]
            layout[y][x] = picked
            used.incl picked.tile.n

    var board = combine_layout(layout)
    var snakes: int
    for i in 0..3:
        snakes = count_snakes(board)
        if snakes > 0:
            break
        board = board.rotate
        # if i == 3:
        #     board = board.flip

    result.part2 = board.count - (snakes * 15)

echo solve()

# def combine_tiles(layout, size):
#     combined = np.zeros((8 * size, 8 * size), np.int)
#     for y in range(size):
#         for x in range(size):
#             combined[y*8:(y+1)*8,x*8:(x+1)*8] = layout[y,x].grid[1:-1,1:-1]
#     return combined

# def solve_snakes(combined):
#     snake = '''
#                   # 
# #    ##    ##    ###
#  #  #  #  #  #  #   '''.strip('\n')
#     snake = grid_to_array(snake)
#     filter = np.rot90(snake, 2) # convolution filter is flipped
#     snakelen = snake.sum()
#     for i in range(NUM_TRANSFORMATIONS):
#         d = transformations(combined, i)
#         cv = convolve2d(d, filter, mode='valid')
#         snakes = (cv == snakelen).sum()
#         # assumption: no overlaps
#         if snakes:
#             return d.sum() - snakes*snakelen

# def display(grid):
#     print('\n'.join(''.join('#' if cell else '.' for cell in row) for row in grid))
