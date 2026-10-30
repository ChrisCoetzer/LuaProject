local stats = require("stats")
local screen = {}

function screen.draw(titleFont, buttonFont, message)
    love.graphics.setFont(titleFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("GAMEPLAY STATISTICS", 0, 45, 800, "center")
    love.graphics.setFont(buttonFont)
    local overall = stats.summary()
    love.graphics.printf(string.format("Total games: %d    Wins: %d    Losses: %d",
        overall.played, overall.wins, overall.losses), 0, 110, 800, "center")
    local games = { { "wordle", "WORDLE" }, { "sudoku", "SUDOKU" }, { "memory", "MEMORY MATCH" } }
    for index, game in ipairs(games) do
        local summary = stats.summary(game[1])
        local y = 165 + (index - 1) * 110
        love.graphics.setColor(0.75, 0.8, 0.9)
        love.graphics.print(game[2], 55, y)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(string.format("Played: %d    Wins: %d    Losses: %d    Win rate: %.0f%%",
            summary.played, summary.wins, summary.losses, summary.winPercent), 55, y + 28)
        local timing = summary.averageSeconds and string.format("Average time: %.1fs", summary.averageSeconds)
            or "No completed games yet"
        if summary.bestSeconds then timing = timing .. string.format("    Fastest win: %.1fs", summary.bestSeconds) end
        love.graphics.print(timing, 55, y + 56)
    end
    if message then love.graphics.printf(message, 35, 500, 730, "center") end
    love.graphics.printf("Escape: Main menu", 0, 555, 800, "center")
end

return screen
