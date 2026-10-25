local currentScreen = "menu"

-- Lua Mini Arcade
function love.load()
    love.window.setTitle("Lua Mini Arcade")
    love.window.setMode(800, 600)

    titleFont = love.graphics.newFont(36)
    buttonFont = love.graphics.newFont(20)
end

function love.draw()
    -- Background
    love.graphics.clear(0.08, 0.11, 0.19)

    if currentScreen == "menu" then

    -- Main title
    love.graphics.setFont(titleFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("LUA MINI ARCADE", 0, 80, 800, "center")

    -- Subtitle
    love.graphics.setFont(buttonFont)
    love.graphics.setColor(0.75, 0.8, 0.9)
    love.graphics.printf("Select a game to begin!", 0, 145, 800, "center")

    -- Wordle button
    love.graphics.setColor(0.27, 0.48, 0.40)
    love.graphics.rectangle("fill", 250, 230, 300, 65, 10, 10)

    -- Sudoku button
    love.graphics.setColor(0.26, 0.43, 0.67)
    love.graphics.rectangle("fill", 250, 320, 300, 65, 10, 10)

    -- Memory Match button
    love.graphics.setColor(0.50, 0.38, 0.65)
    love.graphics.rectangle("fill", 250, 410, 300, 65, 10, 10)

    -- Button labels
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(buttonFont)

    love.graphics.printf("WORDLE", 250, 250, 300, "center")
    love.graphics.printf("SUDOKU", 250, 340, 300, "center")
    love.graphics.printf("MEMORY MATCH", 250, 430, 300, "center")

    elseif currentScreen == "wordle" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(titleFont)
        love.graphics.printf("WORDLE", 0, 100, 800, "center")

        love.graphics.setFont(buttonFont)
        love.graphics.printf("Wordle game coming soon!", 0, 250, 800, "center")
    end
end


function love.mousepressed(x, y, button)
    if currentScreen == "menu" and button == 1 then
        if x >= 250 and x <= 550 and y >= 230 and y <= 295 then
            currentScreen = "wordle"
            print("Wordle selected!")
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        currentScreen = "menu"
    end
end