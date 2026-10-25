local wordle = {}


local currentGuess = ""
local currentRow = 1
local guesses = {}


local secretWord = "APPLE"
local feedback = {}


function wordle.draw()
    -- Wordle title
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("WORDLE", 350, 50)

    -- Wordle grid
    for row = 1, 6 do
        for col = 1, 5 do
            local x = 250 + (col - 1) * 60
            local y = 150 + (row - 1) * 60
            love.graphics.rectangle("line", x, y, 50, 50)

            local displayedGuess = guesses[row] or ""

            if row == currentRow then
                displayedGuess = currentGuess
            end
            
            if col <= #displayedGuess then
                local letter = displayedGuess:sub(col, col)
                love.graphics.print(letter, x + 18, y + 15)
            end
        end
    end
end

function wordle.textinput(text)
    if currentRow <= 6 and #currentGuess < 5 and text:match("%a") then
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
        if #currentGuess == 5 and currentRow <= 6 then
            guesses[currentRow] = currentGuess
            feedback[currentRow] = checkGuess(currentGuess)
            currentRow = currentRow + 1
            currentGuess = ""
        end
    end
end




return wordle