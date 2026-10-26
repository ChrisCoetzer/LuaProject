local wordle = {}


local currentGuess = ""
local currentRow = 1
local guesses = {}


local secretWord = "APPLE"
local feedback = {}
local guessLimits = {Easy = 8, Medium = 6, Hard = 4}
local difficulty = "Medium"
local maxGuesses = guessLimits[difficulty]

function wordle.start(selectedDifficulty)
    assert(guessLimits[selectedDifficulty], "Unknown Wordle difficulty")
    difficulty = selectedDifficulty
    maxGuesses = guessLimits[difficulty]
    currentGuess = ""
    currentRow = 1
    guesses = {}
    feedback = {}
end

function wordle.draw()
    -- Wordle title
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("WORDLE", 0, 50, 800, "center")
    love.graphics.printf(difficulty .. " - " .. maxGuesses .. " guesses", 0, 100, 800, "center")

    -- Wordle grid
    for row = 1, maxGuesses do
        for col = 1, 5 do
            local x = 280 + (col - 1) * 50
            local y = 150 + (row - 1) * 50
            love.graphics.rectangle("line", x, y, 40, 40)

            local displayedGuess = guesses[row] or ""

            if row == currentRow then
                displayedGuess = currentGuess
            end
            
            if col <= #displayedGuess then
                local letter = displayedGuess:sub(col, col)
                love.graphics.printf(letter, x, y + 8, 40, "center")
            end
        end
    end
end

function wordle.textinput(text)
    if currentRow <= maxGuesses and #currentGuess < 5 and text:match("%a") then
        currentGuess = currentGuess .. text:upper()
    end
end

local function checkGuess(guess)
    local result = {}

    for i = 1, 5 do
        local guessedLetter = guess:sub(i, i)
        local secretLetter = secretWord:sub(i, i)

        if guessedLetter == secretLetter then
            result[i] = "green"
        else
            result[i] = "gray"
        end
    end

    return result
end

function wordle.keypressed(key)
    if key == "backspace" then
        -- Remove the last letter
        currentGuess = currentGuess:sub(1, -2)

    elseif key == "return" then
        -- Only submit guesses containing 5 letters
        if #currentGuess == 5 and currentRow <= maxGuesses then
            guesses[currentRow] = currentGuess
            feedback[currentRow] = checkGuess(currentGuess)
            currentRow = currentRow + 1
            currentGuess = ""
        end
    end
end




return wordle
