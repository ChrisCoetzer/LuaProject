-- Lua Data Structures and Control Structures Demo
-- This program demonstrates two major data structures:
-- an array-style table and a struct-style table.
-- also a for loop and a function.
local players = {"Messi", "Ronaldo", "Neymar"}

-- Array-style table:
-- Stores multiple player names using numbered indexes.
print(players[1])
print(#players)

-- For loop:
-- Repeats the code inside the loop ten times.
for i = 1, 10 do
  print(i)
end

-- Struct-style table:
-- Lua tables can store named fields, allowing them to work like structs.
local box = {
    blue = 14,
    red = 56,
    green = 1
}

-- Lambda-style anonymous function:
-- The function accepts three values and returns their sum.
local add = function(x, y, z) return x + y + z end

print(add(box.blue, box.red, box.green))
