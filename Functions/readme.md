# Core Utilities (Functions)

This directory contains a suite of lightweight Batch scripts that mimic common Linux commands on Windows. These are designed to be placed in the `Functions` folder of `cmdsh` or added to your system `%PATH%`.

## 📦 Package Management

### `apt`
A Debian-style wrapper for Windows Package Manager (`winget`).
* **Usage:** `apt [command] <package>`
* **Commands:**
  * `install <pkg>` - Installs a package.
  * `update` - Upgrades all packages.
  * `upgrade <pkg>` - Upgrades a specific package.
  * `search <pkg>` - Searches for a package.

### `pacman`
An Arch-style wrapper for Windows Package Manager (`winget`).
* **Usage:** `pacman [flag] <package>`
* **Flags:**
  * `-S <pkg>` - Install.
  * `-Syu` - Full system upgrade.
  * `-Ss <pkg>` - Search.
  * `-R <pkg>` - Remove/Uninstall.

### `func`
A tool to install/uninstall functions
* **Usage:** `func [flag] <function>`
* **Flags:**
  * `install` - install
  * `uninstall` - uninstall

---

## 📂 File Operations

### `ls`
Lists directory contents in a clean, wide format (similar to `ls -C`).
* **Usage:** `ls [path]`
* **Features:**
  * Returns distinct error messages if the path is not found.
  * Returns valid error codes (0 for success, 1 for failure).

### `rm`
Removes files or directories with safety checks.
* **Usage:** `rm [-rf] [--no-preserve-root] <target>`
* **Flags:**
  * `-rf`: Force recursive deletion (required for folders).
  * `--no-preserve-root`: Required to operate on `C:\`.
* **Safety:** Includes a built-in guardrail against accidental deletion of the root drive.

### `touch`
Creates a new empty file or updates the timestamp of an existing file.
* **Usage:** `touch <filename>`

### `cat`
Outputs the contents of a file to the console.
* **Usage:** `cat [filename]`
* **Features:** If no filename is provided, it reads from standard input (useful for piping).

---

## 🔍 Search & Display

### `grep`
Searches for text patterns within a file or input stream and highlights matches.
* **Usage:** `grep <pattern> [file]`
* **Features:**
  * Highlights the matching pattern in **Red**.
  * Supports standard input if no file is specified.

### `clear`
Clears the terminal screen (wrapper for `cls`).
* **Usage:** `clear`
