local memory = {}

local board = {}
local revealed = {}
local matched = {}
local firstCard = nil
local secondCard = nil
local lockInput = false
local flipTimer = 0
local message = "Find all 3 pairs!"

local function shuffleCards()
    board = {}
    for i = 1, 3 do
        board[#board + 1] = i
        board[#board + 1] = i
    end

    for i = #board, 2, -1 do
        local j = math.random(i)
        board[i], board[j] = board[j], board[i]
    end
end

function memory.reset()
    shuffleCards()
    revealed = {}
    matched = {}
    firstCard = nil
    secondCard = nil
    lockInput = false
    flipTimer = 0
    message = "Find all 3 pairs!"
end

memory.reset()

local function countMatched()
    local total = 0
    for _, isMatched in pairs(matched) do
        if isMatched then
            total = total + 1
        end
    end
    return total
end

function memory.update(dt)
    if lockInput then
        flipTimer = flipTimer - dt
        if flipTimer <= 0 then
            revealed[firstCard] = false
            revealed[secondCard] = false
            firstCard = nil
            secondCard = nil
            lockInput = false
            message = "Try again!"
        end
    end
end

function memory.mousepressed(x, y, button)
    if button ~= 1 or lockInput then
        return
    end

    for i = 1, #board do
        local col = (i - 1) % 3
        local row = math.floor((i - 1) / 3)
        local cardX = 170 + col * 150
        local cardY = 140 + row * 120

        if x >= cardX and x <= cardX + 100 and y >= cardY and y <= cardY + 100 then
            if matched[i] or revealed[i] then
                return
            end

            revealed[i] = true

            if firstCard == nil then
                firstCard = i
                message = "Pick one more card"
                return
            end

            secondCard = i

            if board[firstCard] == board[secondCard] then
                matched[firstCard] = true
                matched[secondCard] = true
                message = "Match!"
                firstCard = nil
                secondCard = nil

                if countMatched() == 6 then
                    message = "You won! Press Esc to return to menu."
                end
            else
                lockInput = true
                flipTimer = 0.8
                message = "Not a match!"
            end

            return
        end
    end
end

function memory.keypressed(key)
    if key == "r" then
        memory.reset()
    end
end

function memory.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(titleFont or love.graphics.newFont(30))
    love.graphics.printf("MEMORY MATCH", 0, 35, 800, "center")

    love.graphics.setFont(buttonFont or love.graphics.newFont(18))
    love.graphics.printf(message, 0, 60, 800, "center")

    for i = 1, #board do
        local col = (i - 1) % 3
        local row = math.floor((i - 1) / 3)
        local cardX = 170 + col * 150
        local cardY = 140 + row * 120

        local isVisible = revealed[i] or matched[i]

        if isVisible then
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("fill", cardX, cardY, 100, 100, 12, 12)
            love.graphics.setColor(0.2, 0.25, 0.3)
            love.graphics.printf(tostring(board[i]), cardX, cardY + 35, 100, "center")
        else
            love.graphics.setColor(0.35, 0.52, 0.86)
            love.graphics.rectangle("fill", cardX, cardY, 100, 100, 12, 12)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf("?", cardX, cardY + 35, 100, "center")
        end
    end
end

return memory

