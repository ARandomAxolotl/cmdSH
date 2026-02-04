# cmdsh - Zsh-Style Wrapper for Windows CMD

`cmdsh` is a lightweight Batch script designed to enhance the standard Windows Command Prompt. It provides a modern, two-line prompt aesthetic, visual error feedback, and an organized structure for custom functions.

## 🚀 Features

* **Modern Visuals:** A two-line, color-coded prompt using ANSI escape sequences.
    * Displays `╭ user@hostname path`
    * Displays `╰> input`
* **Privilege Detection:** Automatically detects if the terminal is running as Administrator and changes the username to `root`.
* **Linux-Style Paths:** Converts Windows backslashes (`\`) to forward slashes (`/`) in the prompt display.
* **Error Feedback:** The prompt symbol (`╰>`) changes color dynamically:
    * **Green:** Previous command succeeded.
    * **Red:** Previous command failed (non-zero error code).
* **Modular Functions:** Automatically creates a `Functions` directory and adds it to the `%PATH%`, allowing you to drop in scripts and run them as commands.
* **Flashfetch Integration:** Automatically runs `flashfetch` on startup if installed.
* **Startup Script:** Generates and runs a `startup.cmd` file for persistent aliases or custom initialization.
* **Func:** A function manager to install functions

## 📂 Directory Structure

Upon the first run, `cmdsh` will automatically generate the following ecosystem in its directory:

```text
/YourDirectory
│
├── cmdsh.cmd       # The main shell script
├── csh.cmd         # A shorthand wrapper created automatically
├── startup.cmd     # Runs commands on shell launch (edit this!)
├── Functions/      # Add your custom .cmd/.bat scripts here
└── .config/         # A directory to store config
