# 📖 Key Commands Cheat Sheet

## Navigation & files
| Command | Purpose |
|---|---|
| `pwd` | Print current directory |
| `ls` | List files |
| `ls -a` | List **all** files incl. hidden (`.name`) |
| `ls -l` / `ls -la` | Long format (permissions, owner, size, date) |
| `cd <dir>` | Change directory |
| `cd ~` / `cd ..` | Go to home / one level up |
| `cat <file>` | Print file contents |
| `less <file>` | Page through a file |
| `head -n 5 <file>` / `tail -n 5 <file>` | First / last lines |
| `file <file>` | Identify file type |
| `mkdir`, `cp`, `mv`, `rm` | Create dir, copy, move/rename, delete |

## Searching & text processing
| Command | Purpose |
|---|---|
| `grep "text" <file>` | Search for text in a file |
| `grep -ri "text" .` | Recursive, case-insensitive search |
| `find . -name ".*"` | Find hidden files |
| `\|` (pipe) | Send output of one command into another |
| `>` / `>>` | Redirect output to file (overwrite / append) |
| `wc -l <file>` | Count lines |

## Caesar cipher with `tr`
| Command | Purpose |
|---|---|
| `tr "abcd" "pqrs"` | Translate characters: a→p, b→q, c→r, d→s |
| `cat f \| tr "d-za-cD-ZA-C" "a-zA-Z"` | Decrypt Caesar, shifted **left by 3** |
| `cat f \| tr "a-zA-Z" "d-za-cD-ZA-C"` | Encrypt (shift right by 3) |
| `cat f \| tr "n-za-mN-ZA-M" "a-zA-Z"` | ROT13 (shift 13, same command both ways) |

## OpenSSL symmetric encryption
| Command | Purpose |
|---|---|
| `openssl aes-256-cbc -pbkdf2 -a -d -in X.encrypted -out X.recovered -k <pass>` | Decrypt (lab command) |
| `openssl aes-256-cbc -pbkdf2 -a -e -in X -out X.encrypted -k <pass>` | Encrypt |
| `openssl aes-256-cbc -pbkdf2 -a -d -in X.encrypted -out X.rec -pass env:VAR` | Safer: password from env variable |
| `openssl enc -list` | List supported ciphers |
| `openssl version` | Show OpenSSL version |

## Hashing & encoding (integrity checks)
| Command | Purpose |
|---|---|
| `sha256sum <file>` | SHA-256 hash (verify integrity) |
| `md5sum <file>` | MD5 hash (legacy, not collision-safe) |
| `base64 <file>` / `base64 -d` | Encode / decode Base64 |
| `xxd <file> \| head` | Hex dump |

## Permissions & users
| Command | Purpose |
|---|---|
| `whoami` / `id` | Current user / IDs and groups |
| `chmod +x script.sh` | Make a file executable |
| `chmod 600 file` | Owner read/write only |
| `chown user:group file` | Change owner |
| `sudo <cmd>` | Run as superuser |

## Shell tips
| Command | Purpose |
|---|---|
| `man <cmd>` / `<cmd> --help` | Documentation |
| `history` | Previous commands |
| `Tab` / `Ctrl+C` / `Ctrl+L` | Autocomplete / interrupt / clear screen |
