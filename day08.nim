import strscans, strutils

type
    Op = enum acc, jmp, nop
    Instruction = tuple[op: Op, arg: int]


proc parse: seq[Instruction] =
    for line in lines "input08.txt":
        var instruction: Instruction
        var op: string
        if scanf(line, "$+ $i", op, instruction.arg):
            instruction.op = parseEnum[Op](op)
            result.add instruction

var code = parse()

proc run(code: seq[Instruction]): (int, bool) =
    var reg: int
    var pc: int16
    var pcs: set[int16]
    while pc < len(code):
        if pc in pcs:
            return (reg, true)
        pcs.incl(pc)
        if code[pc].op == acc:
            reg += code[pc].arg
        if code[pc].op == jmp:
            pc += int16(code[pc].arg)
        else:
            inc pc
    return (reg, false)

proc part1: int =
    return run(code)[0]

proc part2: int =
    for i, ins in code.pairs:
        if ins.op == acc:
            continue
        code[i].op = if ins.op == nop: jmp else: nop
        let (acc, loop) = run(code)
        if not loop:
            return acc
        code[i] = ins

echo part1()
echo part2()