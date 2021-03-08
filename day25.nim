import math

proc powmod(x, y, p: int): int =  
    result = 1
    var x = x mod p
    var y = y
    while y > 0:
        # If y is odd, multiply x with result  
        if (y and 1) == 1:
            result = (result * x) mod p
        # y must be even now  
        y = y shr 1
        x = (x * x) mod p
  
# Function to calculate k for given a, b, m  
proc modlog(a, b, m: int): int =
    let n = int(sqrt(float32(m)) + 1)
    var value = newSeq[int](m)
    # Store all values of a^(n*i) of LHS  
    for i in 1..n:
        value[ powmod(a, i * n, m) ] = i
  
    for j in 0..<n:
        # Calculate (a ^ j) * b and check for collision
        let cur = (powmod(a, j, m) * b) mod m
        # If collision occurs i.e., LHS = RHS  
        if (value[cur] > 0):
            result = value[cur] * n - j
            # Check whether ans lies below m or not  
            if (result < m): 
                return result
    return -1

proc part1: int =
    let a = 11239946
    let b = 10464955
    let m = 20201227
    let k = modlog(7, a, m)
    return powmod(b, k, m)

echo part1()
