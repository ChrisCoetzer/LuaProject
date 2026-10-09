-- Lua Data Types and Built-in Methods Demo
-- This program demonstrates four Lua data types:
-- number, string, boolean, and table.
-- Each data type is used with two operations or built-in methods.
local num_value = 8
local message_value = "This is a test"
local is_true = true
local table_value = {10, 20, 30}

-- type() checks and displays the data type of each value.
print(type(num_value))
print(type(message_value))
print(type(is_true))
print(type(table_value))

-- Number methods:
-- math.abs() returns the absolute value of a number.
-- math.sqrt() returns the square root of a number.
print(math.abs(num_value))
print(math.sqrt(num_value))

-- String methods:
-- string.len() returns the number of characters in the string.
-- string.lower() converts the string to lowercase.
print(string.len(message_value))
print(string.lower(message_value))

-- Boolean operations:
-- "not" reverses a boolean value.
-- "and" checks whether both boolean expressions are true.
print(not is_true)
print(is_true and true)

-- Table methods:
-- table.insert() adds a new value to the table.
-- table.remove() removes a value from the table.
table.insert(table_value, 3, 40)
print(table_value[3])
table.remove(table_value, 1)
print(table_value[1])
