Math.sign = (a) =>
    if a == 0
        return 0
    if a > 0
        return 1
    if a < 0
        return -1

Math.mod = (a, b) =>
    ((a % b) + b) % b
