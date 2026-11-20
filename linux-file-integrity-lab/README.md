# 🧮 Linux File Integrity Lab: Hashing & Comparison (SHA-256)

[![Platform: Linux CLI](https://img.shields.io/badge/Platform-Linux%20CLI%20%2F%20Bash-orange.svg)](#)
[![Security: Data Integrity](https://img.shields.io/badge/Security-Data%20Integrity-blue.svg)](#)
[![Algorithm: SHA-256](https://img.shields.io/badge/Algorithm-SHA--256-red.svg)](#)

## 📌 Overview
Hands-on lab on verifying file integrity with cryptographic hashes. A hash function produces a fixed-size digest that uniquely identifies a file's contents, and changing even one byte changes the digest completely. This is how analysts check whether a file was modified, or whether a suspicious file really matches a known original.

**Scenario:** two files, `file1.txt` and `file2.txt`, look identical when printed with `cat`. Are they really the same?

This repo has my manual walkthrough and a reusable Bash script, [`fim_comparator.sh`](fim_comparator.sh), that automates the same check.

## 🧭 Walkthrough

### Task 1 – Generate hashes
```bash
ls                   # file1.txt  file2.txt
cat file1.txt        # looks identical...
cat file2.txt        # ...to file1.txt
sha256sum file1.txt  # 131f95c5...fd8267  file1.txt
sha256sum file2.txt  # 2558ba9a...a017b   file2.txt
```
**Result:** the contents look the same on screen, but the SHA-256 hashes are completely different, so the files are **not** identical. The visible text can't tell you that. Only the hash can.

### Task 2 – Save and compare the hashes
```bash
sha256sum file1.txt >> file1hash
sha256sum file2.txt >> file2hash
cat file1hash file2hash
cmp file1hash file2hash   # file1hash file2hash differ: char 1, line 1
```
`cmp` compares two files byte by byte and reports the position of the first difference. Here the hashes differ from the very first character, which shows that a tiny change in input produces a totally different hash (the *avalanche effect*).

**Conclusion:** `file1.txt` and `file2.txt` are different files, even though they appear identical.

## 🛠️ Toolkit: `fim_comparator.sh`
```bash
chmod +x fim_comparator.sh
./fim_comparator.sh file1.txt file2.txt
./fim_comparator.sh -a md5 file1.txt file2.txt     # other algorithms: sha1, sha512, md5
```
What it does:
1. Computes the hash and size of both files.
2. Prints **MATCH** or **MISMATCH** (exit code `0` = identical, `1` = different, `2` = error, so it works in scripts).
3. On a mismatch, shows **where** the files differ: first differing byte (`cmp`), differing byte values (`cmp -l`), and a hex diff (`od`).

Step 3 matters because the hash only says *that* files differ, not *why*. Invisible differences such as a trailing newline, extra spaces or a look-alike character can't be seen with `cat`. For example:
```
--- First difference (cmp) ---
a d differ: char 8, line 1
--- Hex diff ---
< 0000000 68 65 6c 6c 6f 20 77 6f 72 6c 64 0a   >hello world.<
> 0000000 68 65 6c 6c 6f 20 77 30 72 6c 64 0a   >hello w0rld.<
```
(Example output from my own test files, not the lab files.)

## 🔑 Commands Used
| Command | Purpose |
|---|---|
| `ls`, `cat` | List files, display contents |
| `sha256sum <file>` | Compute SHA-256 hash |
| `>` / `>>` | Redirect output to a file (overwrite / append) |
| `cmp a b` | Byte-by-byte comparison, reports first difference |
| `cmp -l a b` | List every differing byte |
| `od -A d -t x1z <file>` | Hex dump (offset, hex bytes, text) |

> Note: `>>` appends, so running the command twice writes two lines to the same hash file. Use `>` to overwrite.

## 🧠 Security Takeaways
- **Never trust what a file looks like**: compare hashes, not visual output.
- Hashes verify **integrity** (was it changed?), not **secrecy** or **who** made the file.
- A hash value can be checked against known-good values (software vendors) or known-bad ones (threat-intelligence IoC databases such as VirusTotal).
- **SHA-256 is preferred over MD5/SHA-1**, which have known collision weaknesses.

## 📁 Repository Structure
```
.
├── README.md           # walkthrough and documentation
└── fim_comparator.sh   # hash comparator script
```
