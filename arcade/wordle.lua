local wordle = {}

local currentGuess = ""
local currentRow = 1
local guesses = {}
local feedback = {}

-- List of possible words
local words = require("words")

local secretWord = words[love.math.random(#words)]
print("Secret word: " .. secretWord)
local gameOver = false
local message = ""

-- Draw the Wordle screen
function wordle.draw()

    -- Wordle title
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("WORDLE", 0, 50, 800, "center")

    -- Wordle grid
    for row = 1, 6 do
        for col = 1, 5 do
            local x = 250 + (col - 1) * 60
            local y = 150 + (row - 1) * 60

            -- Display color feedback
            if feedback[row] then
                local color = feedback[row][col]

                if color == "green" then
                    love.graphics.setColor(0.33, 0.55, 0.30)

                elseif color == "yellow" then
                    love.graphics.setColor(0.71, 0.62, 0.23)

                else
                    love.graphics.setColor(0.34, 0.35, 0.38)
                end

                love.graphics.rectangle("fill", x, y, 50, 50)
            end

            -- Draw tile outline
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", x, y, 50, 50)

            -- Display guessed letters
            local displayedGuess = guesses[row] or ""

            if row == currentRow then
                displayedGuess = currentGuess
            end

            if col <= #displayedGuess then
                local letter = displayedGuess:sub(col, col)
                love.graphics.printf(letter, x, y + 15, 50, "center")
            end
        end
    end

    -- Display game message
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(message, 0, 520, 800, "center")

    if gameOver then
        love.graphics.printf(
            "Press ENTER to play again", 0, 550, 800, "center"
        )
    end

    love.graphics.printf(
        "Press ESC to return to menu", 0, 580, 800, "center"
    )
end

-- Handle letter input
function wordle.textinput(text)
    if not gameOver and currentRow <= 6
        and #currentGuess < 5
        and text:match("^[a-zA-Z]$") then

        currentGuess = currentGuess .. text:upper()
        message = ""
    end
end

-- Check whether the guess is a valid word
local function isValidWord(guess)
    for _, word in ipairs(words) do
        if guess == word then
            return true
        end
    end

    return false
end

-- Calculate color feedback
local function checkGuess(guess)
    local result = {}
    local used = {}

    -- Check correct positions
    for i = 1, 5 do
        local guessedLetter = guess:sub(i, i)
        local secretLetter = secretWord:sub(i, i)

        if guessedLetter == secretLetter then
            result[i] = "green"
            used[i] = true
        else
            result[i] = "gray"
        end
    end

    -- Check misplaced letters
    for i = 1, 5 do
        if result[i] ~= "green" then
            local guessedLetter = guess:sub(i, i)

            for j = 1, 5 do
                local secretLetter = secretWord:sub(j, j)

                if guessedLetter == secretLetter and not used[j] then
                    result[i] = "yellow"
                    used[j] = true
                    break
                end
            end
        end
    end

    return result
end

-- Reset the game
function wordle.reset()
    currentGuess = ""
    currentRow = 1
    guesses = {}
    feedback = {}

    secretWord = words[love.math.random(#words)]
    print("Secret word: " .. secretWord)

    gameOver = false
    message = ""
end

-- Handle keyboard actions
function wordle.keypressed(key)

    -- Restart the game
    if gameOver then
        if key == "return" then
            wordle.reset()
        end
        return
    end

    if key == "backspace" then
        currentGuess = currentGuess:sub(1, -2)
        message = ""

    elseif key == "return" then

        -- Check guess length
        if #currentGuess ~= 5 then
            message = "Enter a five-letter word!"
            return
        end

        -- Validate the word
        if not isValidWord(currentGuess) then
            message = "Word not in list!"
            return
        end

        -- Save guess and feedback
        guesses[currentRow] = currentGuess
        feedback[currentRow] = checkGuess(currentGuess)

        -- Check winning condition
        if currentGuess == secretWord then
            message = "You won!"
            gameOver = true

        -- Check losing condition
        elseif currentRow == 6 then
            message = "You lost! The word was " .. secretWord
            gameOver = true
        end

        -- Move to the next row
        currentRow = currentRow + 1
        currentGuess = ""
    end
end



return wordle