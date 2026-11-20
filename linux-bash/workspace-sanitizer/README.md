# 🧹 Workspace Sanitizer (Bash)

[![Platform: Linux / Bash](https://img.shields.io/badge/Platform-Linux%20%2F%20Bash-orange.svg)](#)

## 📌 Overview
[`sanitizer.sh`](sanitizer.sh) tidies an analyst workspace the way the Linux file-management lab asked, and writes a record of what it *actually* did.

Given a base directory (default `~/analyst`) it will:
1. create `logs/` if missing;
2. remove `temp/` **only if it is empty** (`rmdir`; a non-empty folder is left alone with a warning);
3. move `notes/Q3patches.txt` to `reports/`;
4. delete `notes/tempnotes.txt`;
5. write `notes/tasks.txt` listing only the actions performed in this run, with a UTC timestamp.

```bash
chmod +x sanitizer.sh
./sanitizer.sh                 # ~/analyst
./sanitizer.sh /tmp/test_ws    # custom workspace
```

## 🔐 Design choices
- `set -euo pipefail` and a guard that refuses to run on `/` or `$HOME`.
- `rmdir` instead of `rm -rf`, so a typo in the path can't wipe a directory tree.
- The record is built from what happened, not a fixed text. It is a plain text file, **not** tamper-proof; real audit trails need append-only or remote logging.
- Heredoc quoting matters: `<<'EOF'` would write `$(date)` literally. I print the record with `echo` so command substitution runs.

## 🧠 Skills Demonstrated
File-system automation · defensive Bash · idempotent scripts (second run reports "nothing to do").
