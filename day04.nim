import common, re, sequtils, sets, strutils

type
    Field = tuple[name, value: string]
    Passport = object
        fields: seq[Field]

proc fieldSet(p: Passport): HashSet[string] =
    toHashSet(p.fields.map do (f: Field) -> string: f.name)

let fieldsRequired = toHashSet(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])

proc parse(line: string): Passport =
    result.fields = line.splitWhitespace.map do (rule: string) -> Field:
        let p = rule.split(':')
        (p[0], p[1])

proc required(p: Passport): bool = len(fieldsRequired - p.fieldSet) == 0

proc valid(f: Field): bool =
    case f.name:
        of "byr":
            result = parseInt(f.value) in 1920..2002
        of "iyr":
            result = parseInt(f.value) in 2010..2020
        of "eyr":
            result = parseInt(f.value) in 2020..2030
        of "hgt":
            case f.value[^2..^1]
            of "cm":
                result = parseInt(f.value[0..^3]) in 150..193
            of "in":
                result = parseInt(f.value[0..^3]) in 59..76
        of "hcl":
            result = f.value.match(re"^#[0-9a-f]{6}$")
        of "ecl":
            result = f.value.match(re"^(amb|blu|brn|gry|grn|hzl|oth)$")
        of "pid":
            result = f.value.match(re"^\d{9}$")
        of "cid":
            result = true

proc fieldsValid(p: Passport): bool =
    for field in p.fields:
        if not field.valid: return false
    return true

let passports = (readFile "input04.txt").split("\n\n").map(parse)

proc solve: Answer =
    for pp in passports:
        if pp.required:
            inc result.part1
            if pp.fieldsValid:
                inc result.part2

echo solve()