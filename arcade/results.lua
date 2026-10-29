local results = {}
local current
local pending = false
local names = { wordle = "Wordle", sudoku = "Sudoku", memory = "Memory Match" }

function results.show(result, demo, message)
    current = { result = result, demo = demo, message = message }
end

-- Games call this once they have a final outcome. Failed saves can be retried.
function results.complete(roundId, result)
    local ok, message = require("stats").record(roundId, result)
    if not ok then return nil, message end
    results.show(result, false, "Result saved")
    pending = true
    return true
end

function results.takeCompleted()
    local completed = pending
    pending = false
    return completed
end

function results.draw(titleFont, buttonFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(titleFont)
    love.graphics.printf("GAME RESULTS", 0, 65, 800, "center")
    love.graphics.setFont(buttonFont)
    if not current then return end
    local result = current.result
    local details = {
        names[result.game] or result.game,
        result.won and "You won!" or "Game over",
        "Difficulty: " .. result.difficulty,
        string.format("Time: %.1f seconds", result.elapsedSeconds),
        result.attempts and ("Attempts / moves: " .. result.attempts) or "",
        current.demo and "DEMO - this result is not saved" or "",
        current.message or "",
        "S: View statistics     Escape: Main menu"
    }
    for index, line in ipairs(details) do
        love.graphics.printf(line, 35, 150 + (index - 1) * 45, 730, "center")
    end
end

return results
