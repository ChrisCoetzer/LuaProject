
local menu = require("menu")
local wordle = require("wordle")
local sudoku = require("sudoku")
local currentScreen = "menu"

-- Lua Mini Arcade
function love.load()
    love.window.setTitle("Lua Mini Arcade")
    love.window.setMode(800, 600)

    titleFont = love.graphics.newFont(36)
    buttonFont = love.graphics.newFont(20)
    sudoku.load()
end

function love.draw()
    -- Background
    love.graphics.clear(0.08, 0.11, 0.19)

    if currentScreen == "menu" then
        -- Display the main menu
        menu.draw(titleFont, buttonFont)

    elseif currentScreen == "wordle" then
        wordle.draw()

    elseif currentScreen == "sudoku" then
        sudoku.draw()
    
    elseif currentScreen == "memory" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(titleFont)
        love.graphics.printf("MEMORY MATCH", 0, 100, 800, "center")
    
        love.graphics.setFont(buttonFont)
        love.graphics.printf("Memory Match game coming soon!", 0, 250, 800, "center")    
    end
    
end

function love.mousepressed(x, y, button)
    if currentScreen == "menu" then
        local selectedGame = menu.mousepressed(x, y, button)

        if selectedGame then
            currentScreen = selectedGame
            print(selectedGame .. " selected!")
        end
    elseif currentScreen == "sudoku" then
        sudoku.mousepressed(x, y, button)
    end
end

function love.keypressed(key)
    -- Press Escape to return to the main menu
    if key == "escape" then
        currentScreen = "menu"

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
