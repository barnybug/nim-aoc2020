import deques, sets, strscans, strutils, tables

type 
    Bag = tuple[size: int, name: string]
    Bags = seq[Bag]
    Rule = tuple[name: string, bags: Bags]

proc parse: seq[Rule] =
    for rule in lines "input07.txt":
        var n1: string
        var bits: string
        if rule.scanf("$+ bags contain $+", n1, bits):
            var contents = newSeq[Bag]()
            var n: int
            var name: string
            for bag in bits.split(", "):
                if bag.scanf("$i $+ bag", n, name):
                    contents.add((n, name))
            result.add((n1, contents))

let rules = parse()

proc part1: int =
    var graph = initTable[string, HashSet[string]]()
    for rule in rules:
        for bag in rule.bags:
            if bag.name notin graph:
                graph[bag.name] = initHashSet[string]()
            graph[bag.name].incl(rule.name)

    var visited = initHashSet[string]()
    var q = initDeque[string]()
    q.addFirst("shiny gold")
    while q.len > 0:
        let current = q.popFirst()
        if current in graph:
            let unvisited = graph[current] - visited
            visited.incl(unvisited)
            for i in unvisited:
                q.addLast(i)

    return len(visited)

proc part2: int =
    var contains = initTable[string, seq[(int, string)]]()
    for rule in rules:
        contains[rule.name] = rule.bags

    var resolved = initCountTable[string]()
    proc resolve(key: string): int =
        if key notin resolved:
            let contents = contains[key]
            result = 1
            for (n, bag) in contents.items:
                result += n * resolve(bag)
            resolved[key] = result
        return resolved[key]
    
    return resolve("shiny gold")-1

echo part1()
echo part2()