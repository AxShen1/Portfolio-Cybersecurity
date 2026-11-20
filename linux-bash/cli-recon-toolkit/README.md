# 🔎 Linux CLI Recon: "Verify Before You Execute"

[![Platform: Linux CLI](https://img.shields.io/badge/Platform-Linux%20CLI%20%2F%20Bash-orange.svg)](#)

## 📌 Overview
Running a command you don't fully understand on a production system can destroy data, stop services or weaken access control. This small toolkit wraps three built-in Linux helpers so you can check a command **before** running it:

1. **`whatis`**: a one-line description (e.g. the difference between `rm` and `rmdir`).
2. **`man` (SYNOPSIS section)**: the syntax and flags (e.g. `useradd -e` sets an account expiry date).
3. **`apropos -a`**: find a command by what you want to do when you don't know its name.

> **Rule of thumb:** don't run commands that change accounts or the file system until you have read the SYNOPSIS.

## 📊 What I looked up in the lab
| I wanted to… | Tool used | Result | Why it's useful |
|---|---|---|---|
| Know what `cat` does | `whatis cat` | `cat`: concatenate files and print | Reading small config files and reports |
| Number lines when reading a file | `man cat` | `cat -n` | Pinpoint line numbers in logs |
| Find a command to show the start of a file | `apropos -a first part file` | `head` | Check log headers and timestamps |
| Set an expiry date for a temporary account | `man useradd` | `useradd -e YYYY-MM-DD` | Temporary or contractor accounts |
| Delete only **empty** directories | `whatis rm rmdir` | `rmdir` | Cleanup without risking files |
| Find a command to create a group | `apropos -a create new group` | `groupadd` | Role-based access control groups |

## 🚀 Usage
```bash
chmod +x cli_recon_tool.sh
./cli_recon_tool.sh verify useradd
./cli_recon_tool.sh verify cat
./cli_recon_tool.sh search create new group
./cli_recon_tool.sh search first part file
```
*Modes:* `verify` runs `whatis` then prints the SYNOPSIS block from `man`; `search` runs `apropos -a` with every keyword you give.

## 🧠 Skills Demonstrated
Using Linux documentation tools · safe command discovery · Bash argument handling (`case`, `"$@"`) · defensive operating habits.
