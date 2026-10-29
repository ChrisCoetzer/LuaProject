-- Run from the repository root: lua arcade/test_stats.lua
package.path = "arcade/?.lua;" .. package.path
local saved, failWrite
love = { filesystem = {
    getInfo = function() return saved ~= nil end,
    read = function() return saved end,
    write = function(_, contents)
        if failWrite then return nil, "Disk unavailable" end
        saved = contents
        return true
    end
} }
local stats = require("stats")
local results = require("results")
assert(stats.load())
assert(stats.summary().played == 0)
local win = { game = "wordle", difficulty = "normal", won = true, elapsedSeconds = 90, attempts = 3 }
local loss = { game = "wordle", difficulty = "normal", won = false, elapsedSeconds = 150, attempts = 6 }
assert(results.complete("round1", win))
assert(results.takeCompleted())
assert(not results.takeCompleted())
assert(results.complete("round1", win))
assert(stats.record("round2", loss))
local summary = stats.summary("wordle")
assert(summary.played == 2 and summary.wins == 1 and summary.losses == 1)
assert(summary.winPercent == 50 and summary.averageSeconds == 120 and summary.bestSeconds == 90)
assert(stats.summary("sudoku").played == 0)
assert(stats.load())
assert(stats.summary().played == 2, "Results must survive reload")
results.show(win, true)
assert(stats.summary().played == 2, "Demo must not affect statistics")
assert(not stats.record("bad", { game = "unknown" }))
failWrite = true
assert(not stats.record("round3", win))
assert(stats.summary().played == 2, "Failed save must roll back")
failWrite = false
saved = "{broken"
assert(not stats.load())
assert(not stats.record("round4", win))
assert(saved == "{broken", "Corrupt saves must not be overwritten")
local json = require("json")
local text = 'normal "quoted" \\ slash\nline'
assert(json.decode(json.encode({ label = text })).label == text)
assert(not pcall(json.decode, '{} trailing'))
print("Results and statistics checks passed")
