# 🔒 Linux File Permissions Hardening (Least Privilege)

[![Concept: Least Privilege](https://img.shields.io/badge/Concept-Least%20Privilege-blue.svg)](#)
[![Platform: Linux / Bash](https://img.shields.io/badge/Platform-Linux%20%2F%20Bash-orange.svg)](#)

## 📌 Overview
Wrongly set file permissions can expose data (*information disclosure*) or let the wrong people change files (*integrity loss*). In this lab I audited a project directory (`/home/researcher2/projects`, user `researcher2`, group `research_team`), found files with excessive permissions, and fixed them with `chmod`. [`harden_permissions.sh`](harden_permissions.sh) automates the same fixes.

## 🛡️ Findings and fixes
| Object | Before | Problem | After | Command |
|---|---|---|---|---|
| `project_k.txt` | `-rw-rw-rw-` | **World-writable**: any user could modify it | `-rw-rw-r--` | `chmod o-w project_k.txt` |
| `project_m.txt` | `-rw-r-----` | Confidential file readable by the whole group | `-rw-------` | `chmod g-rw,o-rwx project_m.txt` |
| `.project_x.txt` (hidden) | `-rw-rw----` | Archive file should not be modifiable | `-r--r-----` | `chmod ug-w .project_x.txt` |
| `drafts/` (directory) | `drwx--x---` | Group could enter the directory (`x`) | `drwx------` | `chmod g-x drafts` |

## 🔍 Concepts
- **Execute bit on directories** means *permission to enter/traverse* (`cd`, access files by name), not "run".
- **UGO model:** **u**ser (owner), **g**roup, **o**ther (everyone else). Symbolic `chmod` (`o-w`, `g-rw`) changes only the bits you name.
- **Hidden files** start with `.` and don't appear in plain `ls`. Always audit with `ls -la`.
- Related standards: NIST SP 800-53 AC-6 (least privilege), ISO/IEC 27001 Annex A access-control controls.

## 🚀 Usage
```bash
chmod +x harden_permissions.sh
./harden_permissions.sh                      # defaults to ~/projects
./harden_permissions.sh /path/to/projects    # or a custom directory
```
The script changes permissions in place. Try it on a copy or a lab VM first. Files that don't exist are skipped.

## 🧠 Skills Demonstrated
Reading `ls -la` output · symbolic `chmod` · least-privilege thinking · Bash scripting with safe defaults.
