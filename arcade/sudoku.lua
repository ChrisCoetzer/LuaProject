local sudoku = {}

local puzzle = {
    {5, 3, 0, 6, 7, 8, 9, 1, 2},
    {6, 7, 2, 1, 9, 5, 3, 4, 8},
    {1, 9, 8, 3, 4, 2, 5, 6, 7},
    {8, 5, 9, 7, 6, 1, 4, 2, 3},
    {4, 2, 6, 8, 0, 3, 7, 9, 1},
    {7, 1, 3, 9, 2, 4, 8, 5, 6},
    {9, 6, 1, 5, 3, 7, 2, 8, 4},
    {2, 8, 7, 4, 1, 9, 6, 3, 5},
    {3, 4, 5, 2, 8, 6, 1, 7, 0}
}

local cells = {}
local margins = {top = {}, bottom = {}, left = {}, right = {}}
local selected = nil
local showWrongAnswers = false
local gridX, gridY = 193, 112
local cellSize = 46
local numberFont, noteFont, labelFont

-- Set up the fonts, empty player cells, and margin notes.
function sudoku.load()
    selected = nil
    showWrongAnswers = false
    numberFont = love.graphics.newFont(28)
    noteFont = love.graphics.newFont(12)
    labelFont = love.graphics.newFont(16)

    for row = 1, 9 do
        cells[row] = {}
        for col = 1, 9 do
            cells[row][col] = {notes = {}}
        end
    end

    for side, entries in pairs(margins) do
        for i = 1, 9 do
            entries[i] = {notes = {}}
        end
    end
end

-- Only a single number counts as an answer. Empty cells and notes return zero.
local function cellValue(row, col)
    if puzzle[row][col] ~= 0 then
        return puzzle[row][col]
    end

    local value, count = 0, 0
    for number = 1, 9 do
        if cells[row][col].notes[number] then
            value = number
            count = count + 1
        end
    end
    if count == 1 then
        return value
    end
    return 0
end

-- Check that every row, column, and box contains nine different answers.
function sudoku.isComplete()
    local rows, columns, boxes = {}, {}, {}
    for i = 1, 9 do
        rows[i], columns[i], boxes[i] = {}, {}, {}
    end

    for row = 1, 9 do
        for col = 1, 9 do
            local value = cellValue(row, col)
            local box = math.floor((row - 1) / 3) * 3 + math.floor((col - 1) / 3) + 1
            if value == 0 or rows[row][value] or columns[col][value] or boxes[box][value] then
                return false
            end
            rows[row][value] = true
            columns[col][value] = true
            boxes[box][value] = true
        end
    end
    return true
end

-- Check that every cell contains a single answer rather than notes.
local function isFilled()
    for row = 1, 9 do
        for col = 1, 9 do
            if cellValue(row, col) == 0 then
                return false
            end
        end
    end
    return true
end

-- Check whether a player answer repeats in its row, column, or box.
local function isWrong(row, col)
    if puzzle[row][col] ~= 0 then
        return false
    end
    local value = cellValue(row, col)
    for i = 1, 9 do
        if i ~= col and cellValue(row, i) == value then
            return true
        end
        if i ~= row and cellValue(i, col) == value then
            return true
        end
    end
    local firstRow = math.floor((row - 1) / 3) * 3 + 1
    local firstCol = math.floor((col - 1) / 3) * 3 + 1
    for r = firstRow, firstRow + 2 do
        for c = firstCol, firstCol + 2 do
            if (r ~= row or c ~= col) and cellValue(r, c) == value then
                return true
            end
        end
    end
    return false
end

-- Small digits always use the same position in a 3 by 3 arrangement.
local function drawNotes(notes, x, y)
    love.graphics.setFont(noteFont)
    for number = 1, 9 do
        if notes[number] then
            local col = (number - 1) % 3
            local row = math.floor((number - 1) / 3)
            love.graphics.printf(number, x + col * 15, y + row * 15, 15, "center")
        end
    end
end

-- Find the screen position of a margin note box.
local function marginPosition(side, i)
    if side == "top" then
        return gridX + (i - 1) * cellSize, gridY - cellSize
    elseif side == "bottom" then
        return gridX + (i - 1) * cellSize, gridY + 9 * cellSize
    elseif side == "left" then
        return gridX - cellSize, gridY + (i - 1) * cellSize
    else
        return gridX + 9 * cellSize, gridY + (i - 1) * cellSize
    end
end

-- Draw the board, notes, instructions, and completion feedback.
function sudoku.draw()
    local complete = sudoku.isComplete()
    local incorrect = isFilled() and not complete
    if not incorrect then
        showWrongAnswers = false
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(numberFont)
    if complete then
        love.graphics.setColor(0.5, 0.95, 0.65)
        love.graphics.printf("SUDOKU COMPLETE!", 0, 8, 800, "center")
    elseif incorrect then
        love.graphics.setColor(1, 0.65, 0.5)
        love.graphics.printf("BOARD FULL - CHECK ANSWERS", 0, 8, 800, "center")
    else
        love.graphics.printf("SUDOKU", 0, 8, 800, "center")
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(labelFont)
    if incorrect then
        love.graphics.setColor(0.35, 0.24, 0.23)
        love.graphics.rectangle("fill", 285, 41, 230, 23, 4, 4)
        love.graphics.setColor(1, 0.85, 0.8)
        local label = showWrongAnswers and "Hide wrong answers" or "Show wrong answers"
        love.graphics.printf(label, 285, 43, 230, "center")
    else
        love.graphics.printf("1-9: add or remove a number  |  Multiple numbers become notes", 0, 43, 800, "center")
    end

    for side, entries in pairs(margins) do
        for i = 1, 9 do
            local x, y = marginPosition(side, i)
            love.graphics.setColor(0.14, 0.20, 0.29)
            if selected and selected.side == side and selected.index == i then
                love.graphics.setColor(0.27, 0.43, 0.60)
            end
            love.graphics.rectangle("fill", x + 1, y + 1, cellSize - 2, cellSize - 2)
            love.graphics.setColor(0.75, 0.85, 1)
            drawNotes(entries[i].notes, x, y)
        end
    end

    for row = 1, 9 do
        for col = 1, 9 do
            local x = gridX + (col - 1) * cellSize
            local y = gridY + (row - 1) * cellSize
            love.graphics.setColor(0.92, 0.94, 0.97)
            if selected and selected.row == row and selected.col == col then
                love.graphics.setColor(0.65, 0.80, 0.95)
            end
            if incorrect and showWrongAnswers and isWrong(row, col) then
                love.graphics.setColor(1, 0.65, 0.65)
            end
            love.graphics.rectangle("fill", x, y, cellSize, cellSize)

            local value = cellValue(row, col)
            love.graphics.setColor(0.12, 0.16, 0.23)
            if puzzle[row][col] == 0 then
                love.graphics.setColor(0.16, 0.36, 0.65)
            end
            if value > 0 then
                love.graphics.setFont(numberFont)
                love.graphics.printf(value, x, y + 6, cellSize, "center")
            else
                love.graphics.setColor(0.55, 0.58, 0.63)
                drawNotes(cells[row][col].notes, x, y)
            end
        end
    end

    love.graphics.setColor(0.12, 0.16, 0.23)
    for i = 0, 9 do
        love.graphics.setLineWidth(i % 3 == 0 and 3 or 1)
        love.graphics.line(gridX + i * cellSize, gridY, gridX + i * cellSize, gridY + 9 * cellSize)
        love.graphics.line(gridX, gridY + i * cellSize, gridX + 9 * cellSize, gridY + i * cellSize)
    end
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0.75, 0.8, 0.9)
    love.graphics.setFont(labelFont)
    love.graphics.printf("*near completed puzzle for testing*", 14, 260, 120, "center")
    love.graphics.printf("Click a cell or margin to edit  |  Backspace / Delete: clear  |  Esc: menu", 0, 578, 800, "center")
end

-- Select a cell or margin box, or toggle the wrong-answer highlights.
function sudoku.mousepressed(x, y, button)
    if button ~= 1 then
        return
    end
    if isFilled() and not sudoku.isComplete() and x >= 285 and x <= 515 and y >= 41 and y <= 64 then
        showWrongAnswers = not showWrongAnswers
        return
    end
    selected = nil

    if x >= gridX and x < gridX + 9 * cellSize and y >= gridY and y < gridY + 9 * cellSize then
        selected = {
            row = math.floor((y - gridY) / cellSize) + 1,
            col = math.floor((x - gridX) / cellSize) + 1
        }
        return
    end

    for side, entries in pairs(margins) do
        for i = 1, 9 do
            local marginX, marginY = marginPosition(side, i)
            if x >= marginX and x < marginX + cellSize and y >= marginY and y < marginY + cellSize then
                selected = {side = side, index = i}
                return
            end
        end
    end
end

-- Add, remove, or clear numbers in the selected cell or margin box.
function sudoku.keypressed(key)
    if not selected then
        return
    end

    local cell
    if selected.side then
        cell = margins[selected.side][selected.index]
    else
        if puzzle[selected.row][selected.col] ~= 0 then
            return
        end
        cell = cells[selected.row][selected.col]
    end

    if key == "backspace" or key == "delete" then
        cell.notes = {}
        showWrongAnswers = false
        return
    end

    local number = tonumber(key) or tonumber(key:match("^kp([1-9])$"))
    if number and number >= 1 and number <= 9 then
        cell.notes[number] = not cell.notes[number]
        if not isFilled() then
            showWrongAnswers = false
        end
    end
end

return sudoku
