#!/usr/bin/env python3
# Find the number of symmetrical numbers between the variables:
# start_num
# end_num
start_num = 1000
end_num = 100000

def is_symmetrical_num(n):
    return str(n) == str(n)[::-1]


# print(is_symmetrical_num(121))
# print(is_symmetrical_num(0))
# print(is_symmetrical_num(122))
# print(is_symmetrical_num(990099))
i = start_num
syms = 0
while i < end_num:
    if is_symmetrical_num(i):
        syms = syms + 1
    i = i + 1
print("Found", syms, "symmetrical numbers between:")
print(start_num," and ",end_num)
