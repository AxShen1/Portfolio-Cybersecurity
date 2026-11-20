# 🐍 Python for Security Analysts: Hands-On Labs

[![Language: Python 3](https://img.shields.io/badge/Language-Python%203-blue.svg)](#)
[![Role: Security Analyst](https://img.shields.io/badge/Role-Security%20Analyst-red.svg)](#)
[![Labs: 11](https://img.shields.io/badge/Labs-11-green.svg)](#)
[![Dependencies: none](https://img.shields.io/badge/Dependencies-standard%20library-lightgrey.svg)](#)

## 📌 Overview
Eleven hands-on Python labs, each set in a security analyst scenario: checking OS patch status, validating login attempts, flagging IP addresses, parsing logs and maintaining allow lists. Each lab is one runnable script in [`labs/`](labs/), with my solution and short comments on what each step demonstrates. Only the Python standard library is used.

```bash
python3 labs/02_conditionals.py          # run a single lab
for f in labs/*.py; do python3 "$f"; done   # run them all
```

## 🌱 About This Repo
I'm a beginner. I'm still learning Python and security fundamentals, so some of this code may not be the best or most elegant solution. I'm doing my best, and this repo is where I practise and track my progress. Suggestions and corrections are welcome (open an issue or a pull request).

## 📚 Labs
| # | Lab | Script | Security scenario | Concepts |
|---|---|---|---|---|
| 01 | Basics | [`01_python_basics.py`](labs/01_python_basics.py) | First notebook, first output | comments, `print()` |
| 02 | Conditionals | [`02_conditionals.py`](labs/02_conditionals.py) | OS update check; approved users and organization hours | `if`/`elif`/`else`, `and`, `or`, `in`, Booleans |
| 03 | Loops | [`03_loops.py`](labs/03_loops.py) | Failed connections; IP allow-list check; employee ID generation | `for`, `while`, `range()`, `break` |
| 04 | Functions | [`04_functions.py`](labs/04_functions.py) | `alert()`; usernames list to string | `def`, calling, string concatenation |
| 05 | Built-ins and return values | [`05_builtin_functions_and_return.py`](labs/05_builtin_functions_and_return.py) | Spotting outlier months; login ratio vs daily average | `sorted()`, `max()`, parameters, `return` |
| 06 | Strings | [`06_strings.py`](labs/06_strings.py) | Normalizing employee IDs; parsing device IDs and URLs | `str()`, `len()`, indexing, slicing, `.index()` |
| 07 | Algorithm | [`07_device_algorithm.py`](labs/07_device_algorithm.py) | Verify the user and their assigned device | parallel lists, `.append()`, `.remove()`, nested conditionals |
| 08 | Regular expressions | [`08_regex.py`](labs/08_regex.py) | Find devices to update; extract IPs from a log | `re.findall()`, `\w`, `\d`, `+`, `{1,3}` |
| 09 | Files | [`09_file_parsing.py`](labs/09_file_parsing.py) | Prepare a log for analysis; create an allow list | `with open()`, modes `r`/`a`/`w`, `.read()`, `.write()`, `.split()` |
| 10 | Allow-list updater | [`10_update_allow_list.py`](labs/10_update_allow_list.py) | Revoke access for removed IP addresses | file rewrite, `.join()`, function wrapping an algorithm |
| 11 | Debugging | [`11_debugging.py`](labs/11_debugging.py) | Fix broken automation code | syntax errors, exceptions, logic errors |

## 🔎 Findings and Observations
Things I noticed while working through the labs, and checked by running the code:

- **Regex: `\d{1,3}` is better than `\d+`, but not perfect (lab 08).** The log contains the malformed address `192.168.103.10654`. The lab's pattern still returns `192.168.103.106`, which is only the first part of it. Adding word boundaries (`\b...\b`) rejects the whole malformed token. The script shows both patterns. A pattern can also match numbers above 255, so real validation needs a range check (e.g. the `ipaddress` module).
- **Removing items from a list while looping over it skips elements (lab 10).** If two entries to remove are next to each other, the second one survives. Looping over the removal list instead, as in the debugging lab, avoids this. The script demonstrates both versions.
- **`.split()` on a log file returns one element per whitespace-separated token (lab 09).** This works for lines without spaces, but a log with spaces inside a line would need `.split("\n")` or `.splitlines()`.
- **Trailing separator (lab 04).** Concatenating `name + ", "` leaves a trailing comma after the last name. `", ".join(...)` produces a clean result.
- **Division by zero (lab 05).** `current / average` raises `ZeroDivisionError` when the average is 0. The lab assumes it never is, but real analysis code would need a guard.
- **Sample data:** where a lab supplied a file or list that is not part of my notes (for example the allow list in lab 03 and `allow_list.txt` in lab 10), the script defines a small sample so it runs on its own. These are marked in the code comments.

## 🧠 Skills Demonstrated
Python fundamentals applied to security tasks: decision logic for access control and patch checks · loops for log and IP processing · functions and return values for reusable detection logic · string parsing of IDs and URLs · regular expressions for IoC extraction · reading and writing files for log handling and allow lists · reading tracebacks and fixing the three kinds of errors.

## 📁 Repository Structure
```
.
├── README.md
├── data/
│   └── login.txt                       # sample login log used in lab 09
└── labs/
    ├── 01_python_basics.py
    ├── 02_conditionals.py
    ├── 03_loops.py
    ├── 04_functions.py
    ├── 05_builtin_functions_and_return.py
    ├── 06_strings.py
    ├── 07_device_algorithm.py
    ├── 08_regex.py
    ├── 09_file_parsing.py
    ├── 10_update_allow_list.py
    └── 11_debugging.py
```
