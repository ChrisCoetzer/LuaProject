
## Lua Programs

`program1_demo.lua` - This file demonstrates four Lua data types: number, string, boolean, and table. It also demonstrates two built-in operations or methods for each data type.

`program2_demo.lua` - This file demonstrates major Lua data structures and control structures, including an array-style table, a struct-style table, a for loop, and an anonymous function.

`program3_demo.lua` - This file demonstrates cooperative concurrency in Lua by using coroutines as a simple producer/consumer scheduler.

## Install Lua

```powershell
winget install DEVCOM.Lua
```

Close and reopen the terminal, then check the install:

```powershell
lua -v
```

## Run the Programs

```powershell
lua ./program1_demo.lua
```

```powershell
lua ./program2_demo.lua
```

```powershell
lua ./program3_demo.lua
```

## Lua Mini Arcade

The Lua Mini Arcade is a GUI-based application developed using **LÖVE (Love2D)**.

The arcade will include three games:
- Wordle
- Sudoku
- Memory Match

### Requirements

- LÖVE (Love2D) 11.5
- Git (for cloning and updating the repository)

Download LÖVE for your operating system:
https://love2d.org/

**Note:** LÖVE includes its own Lua runtime, so a separate Lua installation is not required to run the arcade.

### Getting Started

**1. Clone the repository**

```bash
git clone https://github.com/ChrisCoetzer/LuaProject.git
cd LuaProject
```

If you already have the repository, pull the latest changes:

```bash
git switch main
git pull origin main
```

**2. Install LÖVE**

Download and install LÖVE for your operating system from the official website.

**3. Run the arcade**

Open the `arcade` folder using LÖVE.

Alternatively, if the `love` command is available in your terminal, run this from the project's root directory:

```bash
love arcade
```

For additional instructions, visit:
https://love2d.org/wiki/Getting_Started

### Project Structure

```text
LuaProject/
├── README.md
├── program1_demo.lua
├── program2_demo.lua
├── program3_demo.lua
└── arcade/
    ├── json.lua
    ├── main.lua
    ├── menu.lua
    ├── results.lua
    ├── stats.lua
    ├── stats_screen.lua
    ├── test_stats.lua
    └── wordle.lua
```

### Development Status

- **Main Menu:** Basic GUI and game navigation implemented.
- **Wordle:** In progress.
- **Sudoku:** Pending implementation.
- **Memory Match:** Pending implementation.

The current GUI is a basic starting point and may be modified or improved as development continues.

## Results and Gameplay Statistics

Run `love arcade` from the repository root. At the main menu:

- Press **R** to preview a sample results screen. Demo results never enter saved statistics.
- Press **S** to view statistics for Wordle, Sudoku, and Memory Match.
- Press **Escape** to return to the menu.

Statistics start empty. They include games played, wins, losses, win percentage,
average completion time, and fastest winning time for each game.
Average completion time includes wins and losses; fastest time includes wins only.

### Connecting a Game

When a round ends, call:

```lua
local results = require("results")

local ok, message = results.complete(roundId, {
    game = "wordle", -- "wordle", "sudoku", or "memory"
    difficulty = "normal",
    won = true,
    elapsedSeconds = 95,
    attempts = 4 -- optional nonnegative integer: guesses or moves
})
if not ok then
    -- Display the error and allow the player to retry saving.
    print(message)
end
```

Generate a unique string `roundId` when starting each new round, and keep that
same ID when retrying its completion. IDs must remain unique across app launches
(for example, use a timestamp plus a random suffix). Repeated calls with the
same ID will not count the round twice. The first successfully saved result wins.
The next update switches to the results screen after a successful save.
Measure elapsed time in each game; difficulty labels come from the difficulty module.
Abandoned rounds should not call `complete`.

### Storage

`stats.lua` uses LÖVE's save directory, not the repository, for `results.json`.
The save contains a version and completed results keyed by round ID. No database
or downloaded dependencies are required. The included JSON codec supports the
objects and primitive values used by this format, not general JSON arrays/null.
Missing saves start empty; unreadable or invalid saves show a warning.
Failed writes return an error and roll back the new result in memory.

### Current Scope

Wordle still needs win/loss detection and a call to `results.complete`.
Sudoku and Memory Match can use the same interface once their games are ready.
The results demo is a UI preview, not evidence that game integration is finished.

### Running the Statistics Tests

From the repository root, run:

```powershell
lua arcade/test_stats.lua
```

Expected output: `Results and statistics checks passed`.
