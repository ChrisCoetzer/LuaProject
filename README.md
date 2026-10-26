
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

### Difficulty

On the main menu, click Easy (green), Medium (yellow), or Hard (red),
or use the Left / Right arrow keys.

Wordle uses five-letter words on every level: Easy allows 8 guesses, Medium 6,
and Hard 4. Selecting Wordle always starts a fresh round. Press Escape to return
to the menu. Sudoku and Memory Match remain placeholders; their difficulty rules
will be added when those games are implemented.

### Project Structure

```text
LuaProject/
├── README.md
├── program1_demo.lua
├── program2_demo.lua
├── program3_demo.lua
└── arcade/
    ├── main.lua
    ├── menu.lua
    └── wordle.lua
```

### Development Status

- **Main Menu:** Basic GUI and game navigation implemented.
- **Wordle:** In progress.
- **Sudoku:** Pending implementation.
- **Memory Match:** Pending implementation.

The current GUI is a basic starting point and may be modified or improved as development continues.
