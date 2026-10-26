local menu = {}
local difficulties = {"Easy", "Medium", "Hard"}
local difficultyColors = {
    Easy = {0.20, 0.46, 0.30},
    Medium = {0.58, 0.34, 0.05},
    Hard = {0.65, 0.20, 0.20},
}

function menu.draw(titleFont, buttonFont, selectedDifficulty, difficultyFont)
    -- Main title
    love.graphics.setFont(titleFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("LUA MINI ARCADE", 0, 80, 800, "center")

    -- Subtitle
    love.graphics.setFont(buttonFont)
    love.graphics.setColor(0.75, 0.8, 0.9)
    love.graphics.printf("Select a game to begin!", 0, 145, 800, "center")

    love.graphics.setFont(difficultyFont)
    for i, difficulty in ipairs(difficulties) do
        local x = 250 + (i - 1) * 105
        love.graphics.setColor(difficultyColors[difficulty])
        love.graphics.rectangle("fill", x, 180, 90, 40, 6, 6)
        love.graphics.setColor(1, 1, 1)
        if difficulty == selectedDifficulty then
            love.graphics.rectangle("line", x, 180, 90, 40, 6, 6)
        end
        love.graphics.printf(difficulty, x, 190, 90, "center")
    end

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
    love.graphics.setFont(difficultyFont)
    love.graphics.printf("Difficulty: click or use Left / Right arrow keys", 0, 510, 800, "center")
    love.graphics.setFont(buttonFont)
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        for i, difficulty in ipairs(difficulties) do
            local left = 250 + (i - 1) * 105
            if x >= left and x <= left + 90 and y >= 180 and y <= 220 then
                return nil, difficulty
            end
        end

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

function menu.keypressed(key, selectedDifficulty)
    local step = key == "right" and 1 or key == "left" and -1 or 0
    for i, difficulty in ipairs(difficulties) do
        if difficulty == selectedDifficulty then
            return difficulties[i + step] or selectedDifficulty
        end
    end
    return selectedDifficulty
end

return menu
