local players = {"Messi", "Ronaldo", "Neymar"}

print(players[1])
print(#players)

for i = 1, 10 do
  print(i)
end

-- "struct"
local box = {
    blue = 14,
    red = 56,
    green = 1
}

-- lambda function
local add = function(x, y, z) return x + y + z end

print(add(box.blue, box.red, box.green))
