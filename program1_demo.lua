
local num_value = 8
local message_value = "This is a test"
local is_true = true
local table_value = {10, 20, 30}

print(type(num_value))
print(type(message_value))
print(type(is_true))
print(type(table_value))


print(math.abs(num_value))
print(math.sqrt(num_value))

print(string.len(message_value))
print(string.lower(message_value))

print(not is_true)
print(is_true and true)

table.insert(table_value, 3, 40)
print(table_value[3])
table.remove(table_value, 1)
print(table_value[1])
