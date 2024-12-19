import re

input = open("input.1").read()

patterns, words = input.strip().split("\n\n")

pattern = "|".join(patterns.strip().split(", "))
pattern = fr"^({pattern})*$"

res = 0
for word in words.split("\n"):
    if re.match(pattern, word):
        res += 1
print(res)