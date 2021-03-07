import algorithm, combinatorics, re, sequtils, sets, strutils, tables

type
    SS = HashSet[string]
    Rule = tuple[ingredients: SS, allergens: SS]

proc parse_line(line: string): Rule =
    let words = line.findAll(re"\w+")
    let contains = words.find("contains")
    result[0] = words[0..contains-1].toHashSet
    result[1] = words[contains+1..^1].toHashSet

proc parse: (seq[Rule], SS, SS) =
    let rules = toSeq(lines "input21.txt").map(parse_line)
    result[0] = rules
    for rule in rules:
        result[1].incl rule.ingredients
        result[2].incl rule.allergens

proc inert_ingredients(rules: seq[Rule], ingredients: SS, allergens: SS): SS =
    var potential_allergens: SS
    for ig in ingredients:
        for al in allergens:
            var flag = false
            for rule in rules:
                # if the allergen is in one of this rules' ingredients
                if al in rule.allergens and ig notin rule.ingredients:
                    flag = true
                    break
            if not flag:
                potential_allergens.incl ig
                break
    return ingredients - potential_allergens

let (rules, ingredients, allergens) = parse()
let inert = inert_ingredients(rules, ingredients, allergens)

proc part1: int =
    for ig in inert:
        for rule in rules:
            if ig in rule.ingredients:
                inc result

proc part2: string =
    # eliminate inert from rules
    var rules = rules
    for i, rule in rules:
        rules[i].ingredients.excl inert
    var ingredients = toSeq(ingredients - inert)
    var allergens = sorted(toSeq(allergens))
    assert len(ingredients) == len(allergens)

    # brute force
    for perm in permutations(ingredients):
        var ingredient_map: Table[string, string]
        for (ig, al) in zip(perm, allergens):
            ingredient_map[ig] = al
        var success = true
        for rule in rules:
            var calc_als: SS
            for ig in rule.ingredients:
                calc_als.incl ingredient_map[ig]
            if not (rule.allergens <= calc_als):
                success = false
                break
        if success:
            return perm.join(",")

echo part1()
echo part2()