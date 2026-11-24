
local menu = require("menu")
local wordle = require("wordle")
local sudoku = require("sudoku")
local memory = require("memory")
local results = require("results")
local stats = require("stats")
local statsScreen = require("stats_screen")
local statsMessage
local currentScreen = "menu"

-- Lua Mini Arcade
function love.load()
    love.window.setTitle("Lua Mini Arcade")
    love.window.setMode(800, 600)

    titleFont = love.graphics.newFont(36)
    buttonFont = love.graphics.newFont(20)
    sudoku.load()
    local ok, message = stats.load()
    if not ok then statsMessage = message end
end

function love.update(dt)
    if results.takeCompleted() then currentScreen = "results" end
    if currentScreen == "memory" then
        memory.update(dt)
    end
end

function love.draw()
    -- Background
    love.graphics.clear(0.08, 0.11, 0.19)

    if currentScreen == "menu" then
        -- Display the main menu
        menu.draw(titleFont, buttonFont)
        love.graphics.setFont(buttonFont)
        love.graphics.setColor(0.75, 0.8, 0.9)
        love.graphics.printf("S: Statistics    R: Results demo", 0, 525, 800, "center")

    elseif currentScreen == "results" then
        results.draw(titleFont, buttonFont)

    elseif currentScreen == "stats" then
        statsScreen.draw(titleFont, buttonFont, statsMessage)

    elseif currentScreen == "wordle" then
        wordle.draw()

    elseif currentScreen == "sudoku" then
        sudoku.draw()

    elseif currentScreen == "memory" then
        memory.draw()
    end

end

function love.mousepressed(x, y, button)
    if currentScreen == "menu" then
        local selectedGame = menu.mousepressed(x, y, button)

        if selectedGame then
            currentScreen = selectedGame

            if selectedGame == "memory" then
                memory.reset()

            elseif selectedGame == "wordle" then
                wordle.reset()
            end

            print(selectedGame .. " selected!")
        end
    elseif currentScreen == "sudoku" then
        sudoku.mousepressed(x, y, button)
    elseif currentScreen == "memory" then
        memory.mousepressed(x, y, button)
    end
end

function love.keypressed(key)
    -- Press Escape to return to the main menu
    if key == "escape" then
        currentScreen = "menu"

    elseif (currentScreen == "menu" or currentScreen == "results") and key == "s" then
        currentScreen = "stats"

    elseif currentScreen == "menu" and key == "r" then
        results.show({ game = "wordle", difficulty = "normal", won = true,
            elapsedSeconds = 95, attempts = 4 }, true)
        currentScreen = "results"

    elseif currentScreen == "wordle" then
        wordle.keypressed(key)
    elseif currentScreen == "sudoku" then
        sudoku.keypressed(key)
    end
end

function love.textinput(text)
    if currentScreen == "wordle" then
        wordle.textinput(text)
    end
end
