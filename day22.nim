import common, deques, sets, strutils

type Deck = Deque[int]

func score(p: Deck): int =
  for i in 1 .. p.len:
    result += i * p[p.len-i]

proc parse_player(s: string): Deck =
    let parts = s.split("\n", 1)
    return parseIntList(parts[1]).toDeque

proc parse: (Deck, Deck) =
    var players = readFile("input22.txt").split("\n\n")
    result[0] = parse_player(players[0])
    result[1] = parse_player(players[1])

proc win_score(player1: Deck, player2: Deck): int =
    let winner = if player1.len > 0: player1 else: player2
    result = winner.score

proc part1: int =
    var (player1, player2) = parse()
    while player1.len > 0 and player2.len > 0:
        let p1 = player1.popFirst
        let p2 = player2.popFirst
        if p1 > p2:
            player1.addLast p1
            player1.addLast p2
        else:
            player2.addLast p2
            player2.addLast p1
    return win_score(player1, player2)

proc slice(d: Deck, n: int): Deck =
    for i in 0 ..< n:
        result.addLast(d[i])

proc play(player1: Deck, player2: Deck): (Deck, Deck) =
    var played: HashSet[int]
    var player1 = player1
    var player2 = player2

    while player1.len > 0 and player2.len > 0:
        if played.containsOrIncl(player1.score * player2.score):
            return (player1, player2)

        let p1 = player1.popFirst
        let p2 = player2.popFirst
        let p1win = if len(player1) >= p1 and len(player2) >= p2:
            let (s1, _) = play(player1.slice(p1), player2.slice(p2))
            s1.len > 0
        else:
            p1 > p2
        if p1win:
            player1.addLast(p1)
            player1.addLast(p2)
        else:
            player2.addLast(p2)
            player2.addLast(p1)
    return (player1, player2)

proc part2: int =
    let (player1, player2) = parse()
    let (result1, result2) = play(player1, player2)
    return win_score(result1, result2)

proc run* =
    echo part1()
    echo part2()
