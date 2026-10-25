local menu = {}

function menu.draw(titleFont, buttonFont)
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
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        -- Wordle button
        if x >= 250 and x <= 550 and y >= 230 and y <= 295 then
            return "wordle"

        -- Sudoku button
        elseif x >= 250 and x <= 550 and y >= 320 and y <= 385 then
            return "sudoku"

        -- Memory Match button
        elseif x >= 250 and x <= 550 and y >= 410 and y <= 475 then
            return "memory"
        end
    end

    return nil
end

return menu