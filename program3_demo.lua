-- Lua Coroutine Concurrency Demo
-- Coroutines are Lua's built-in hand-off concurrency feature: each coroutine
-- runs until it yields, then the scheduler resumes the next coroutine.

math.randomseed(os.time())

-- Shared stock table. The factory coroutine adds food here, and the
-- consumer coroutines remove food from it when their preferred item exists.
local stock = {
    Banana = 0,
    Carrot = 0,
    Bamboo = 0
}

local foods = {"Banana", "Carrot", "Bamboo"}

-- Producer coroutine:
-- Runs forever, but yields after making one item so other coroutines can run.
local function factory()
    while true do
        local food = foods[math.random(#foods)]
        stock[food] = stock[food] + 1

        print("Factory made:", food)

        coroutine.yield()
    end
end

-- Consumer coroutine:
-- Each consumer checks the shared stock, acts once, then yields control.
local function consumer(name, food)
    while true do
        if stock[food] > 0 then
            stock[food] = stock[food] - 1
            print(name .. " ate a " .. food)
        else
            print(name .. " is waiting for " .. food)
        end

        coroutine.yield()
    end
end

-- Create coroutines. They do not start immediately; they start when resumed.
local factoryCo = coroutine.create(factory)

local monkeyCo = coroutine.create(function()
    consumer("Monkey", "Banana")
end)

local rabbitCo = coroutine.create(function()
    consumer("Rabbit", "Carrot")
end)

local pandaCo = coroutine.create(function()
    consumer("Panda", "Bamboo")
end)

-- Simple cooperative scheduler:
-- Each cycle resumes every coroutine once. Lua coroutines are cooperative,
-- so each coroutine must call coroutine.yield() to let the others continue.
for cycle = 1, 10 do
    print("\nCycle " .. cycle)

    coroutine.resume(factoryCo)
    coroutine.resume(monkeyCo)
    coroutine.resume(rabbitCo)
    coroutine.resume(pandaCo)
end
