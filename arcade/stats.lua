local json = require("json")
local stats = {}
local records = {}
local loadError
local filename = "results.json"
local games = { wordle = true, sudoku = true, memory = true }

local function finitePositive(value)
    return type(value) == "number" and value >= 0 and value < math.huge
end

local function valid(result)
    return type(result) == "table" and games[result.game]
        and type(result.won) == "boolean"
        and type(result.difficulty) == "string"
        and finitePositive(result.elapsedSeconds)
        and (result.attempts == nil or
            (finitePositive(result.attempts) and result.attempts % 1 == 0))
end

function stats.load()
    records = {}
    loadError = nil
    if not love.filesystem.getInfo(filename) then return true end
    local contents, readError = love.filesystem.read(filename)
    if not contents then
        loadError = "Could not read statistics: " .. tostring(readError)
        return nil, loadError
    end
    local ok, data = pcall(json.decode, contents)
    if not ok or type(data) ~= "table" or data.version ~= 1
        or type(data.results) ~= "table" then
        loadError = "Saved statistics could not be loaded. The file was left unchanged."
        return nil, loadError
    end
    for key, result in pairs(data.results) do
        if type(key) ~= "string" or not valid(result) then
            loadError = "Saved statistics contain an invalid result. The file was left unchanged."
            return nil, loadError
        end
    end
    records = data.results
    return true
end

-- A round ID makes repeated completion notifications safe to call.
function stats.record(roundId, result)
    if loadError then return nil, loadError end
    if type(roundId) ~= "string" or roundId == "" or not valid(result) then
        return nil, "Invalid round ID or game result."
    end
    if records[roundId] then return true end
    local copy = { game = result.game, won = result.won, difficulty = result.difficulty,
        elapsedSeconds = result.elapsedSeconds, attempts = result.attempts }
    records[roundId] = copy
    local ok, message = love.filesystem.write(filename, json.encode({ version = 1, results = records }))
    if not ok then
        records[roundId] = nil
        return nil, "Could not save result: " .. tostring(message)
    end
    return true
end

function stats.summary(game)
    local summary = { played = 0, wins = 0, losses = 0, winPercent = 0, totalSeconds = 0 }
    for _, result in pairs(records) do
        if not game or result.game == game then
            summary.played = summary.played + 1
            summary.totalSeconds = summary.totalSeconds + result.elapsedSeconds
            if result.won then
                summary.wins = summary.wins + 1
                if not summary.bestSeconds or result.elapsedSeconds < summary.bestSeconds then
                    summary.bestSeconds = result.elapsedSeconds
                end
            end
        end
    end
    summary.losses = summary.played - summary.wins
    if summary.played > 0 then
        summary.winPercent = 100 * summary.wins / summary.played
        summary.averageSeconds = summary.totalSeconds / summary.played
    end
    return summary
end

return stats
