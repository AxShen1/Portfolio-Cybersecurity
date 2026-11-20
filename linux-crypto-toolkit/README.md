# 🔐 Linux Crypto Toolkit: Caesar Cipher Breaking & AES-256 Decryption

[![Shell: Bash](https://img.shields.io/badge/Shell-Bash-green.svg)](#)
[![Algorithm: AES-256-CBC](https://img.shields.io/badge/Algorithm-AES--256--CBC-red.svg)](#)
[![Tool: OpenSSL](https://img.shields.io/badge/Tool-OpenSSL-blue.svg)](#)
[![Role: Security Analyst](https://img.shields.io/badge/Role-Security%20Analyst-orange.svg)](#)

## 📌 Overview
Hands-on lab write-up and tooling for a scenario in which every file in a home directory has been "encrypted" (a ransomware-style recovery exercise). The task: explore the system, find a hidden file, break a Caesar cipher, and use the revealed command to decrypt the data.

This repo contains my **manual walkthrough** (what I typed and why) and a **reusable Bash toolkit** ([`crypto_toolkit.sh`](crypto_toolkit.sh)) that automates the same steps. A full command reference is in [`COMMANDS.md`](COMMANDS.md).

## 🧭 Attack-Chain Walkthrough

### Task 1 – Recon: read the instructions
```bash
ls              # Q1.encrypted  README.txt  caesar
cat README.txt  # points to a hidden file inside ./caesar
```

### Task 2 – Find the hidden file and break the Caesar cipher
```bash
cd caesar
ls -a                                  # .  ..  .leftShift3   (dot-prefix = hidden)
cat .leftShift3                        # scrambled text
cat .leftShift3 | tr "d-za-cD-ZA-C" "a-zA-Z"   # shift 3 left -> readable
cd ~
```
`tr` maps each character of the first set onto the same position in the second set, so `d→a`, `e→b`, … which undoes a 3-letter shift. The decrypted text reveals the command for Task 3.

### Task 3 – Decrypt the data with OpenSSL
```bash
openssl aes-256-cbc -pbkdf2 -a -d -in Q1.encrypted -out Q1.recovered -k ettubrute
ls
cat Q1.recovered
```
| Flag | Meaning |
|---|---|
| `aes-256-cbc` | Symmetric cipher: AES, 256-bit key, CBC mode |
| `-pbkdf2` | Strong key derivation from the password |
| `-a` | Base64 encoding of the ciphertext |
| `-d` | Decrypt |
| `-in` / `-out` | Input / output file |
| `-k` | Password (`ettubrute` in this lab) |

## 🛠️ Toolkit
```bash
chmod +x crypto_toolkit.sh

./crypto_toolkit.sh caesar 3 .leftShift3          # decrypt Caesar (left shift 3)
./crypto_toolkit.sh bruteforce .leftShift3        # try all 25 shifts when the key is unknown
./crypto_toolkit.sh decrypt Q1.encrypted Q1.recovered ettubrute
./crypto_toolkit.sh encrypt secret.txt secret.enc # prompts for a password
./crypto_toolkit.sh selftest                      # round-trip test
```
Improvements over a plain wrapper:
- Works for **any** Caesar shift, plus a brute-force mode for unknown shifts.
- Both **encrypt and decrypt**, with a built-in self-test.
- Password is passed to OpenSSL through an environment variable (`-pass env:`) instead of `-k`, and is **prompted for silently** if omitted. This avoids leaking it in `ps` output and shell history.
- Strict mode (`set -euo pipefail`), input validation and clear exit codes.

## 🧠 Security Takeaways
- **Caesar cipher is obfuscation, not encryption**: only 25 possible keys, trivially brute-forced. Attackers and malware authors use similar trivial encodings to hide strings.
- **AES-256 is only as strong as the password**: weak passwords (like the lab's) fall to dictionary attacks; PBKDF2 slows these down but does not replace a strong secret.
- **Never put secrets on the command line** in real environments; they leak via process lists and history.
- Hidden files (leading `.`) are a common place to stash payloads and notes, so always use `ls -a` during triage.

## 📁 Repository Structure
```
.
├── README.md           # walkthrough + documentation
├── COMMANDS.md         # key Linux / crypto commands cheat sheet
└── crypto_toolkit.sh   # Caesar + AES-256 toolkit
```
