# 🐧 Linux Incident Triage & Log Analysis

[![OS: Debian/Ubuntu](https://img.shields.io/badge/OS-Debian%20%2F%20Ubuntu-A81D33.svg)](#)
[![Focus: Log Analysis](https://img.shields.io/badge/Focus-Log%20Analysis%20%26%20Triage-blue.svg)](#)

## 📌 Overview
Hands-on Linux command-line lab from my cybersecurity studies. The scenario: act as a junior analyst on a Linux server, explore the `/home/analyst` workspace, read quarterly user reports (`reports/users`), pull the first errors out of `logs/server_logs.txt`, and keep the evidence trustworthy.

> **Note:** The lab data (users, logs) is training data and is **not included** in this repo. The commands below are the reusable part. I deliberately do not publish specific account names or IP addresses from the lab as "findings", because I can't verify them outside the lab environment.

## ⚙️ Methodology
```
1. Reconnaissance      pwd, ls -la
2. Access & identity   read the quarterly user reports (who was added / deleted?)
3. Log inspection      head, tail, grep
4. Evidence integrity  sha256sum
5. Containment ideas   disable account, block source IP (see below)
```
A typical triage question this supports: *"Was every newly added account approved?"* — compare the added-users report against change tickets, then look for failed or odd activity from the same accounts or IPs in the logs.

## 🛠️ Command Reference

### Navigation and reading
| Command | Example | Purpose |
|---|---|---|
| `pwd` | `pwd` | Confirm where you are |
| `ls -la` | `ls -la /home/analyst` | List everything, including hidden files, with permissions |
| `cat` | `cat reports/users/Q1_added_users.txt` | Read a small file |
| `head -n` | `head -n 10 server_logs.txt` | First lines: header and earliest timestamps |
| `tail -n` | `tail -n 20 server_logs.txt` | Last lines: most recent events |

### Packages (APT)
```bash
sudo apt install tcpdump nload htop -y     # install analysis tools
apt list --installed | grep -i tcpdump      # verify
sudo apt remove <package_name> -y           # remove what you don't need (smaller attack surface)
```

### Filtering logs with `grep` and pipes
```bash
grep error server_logs.txt                  # case-sensitive
grep -i "warning" logs/server_logs.txt      # case-insensitive
grep -c -i "error" server_logs.txt          # just count matches
grep "Human Resources" Q4_added_users.txt   # phrase with a space
ls reports/users | grep Q1                  # pipe one command into another
```

### File-system hygiene
```bash
mkdir -p /home/analyst/logs                 # create directories (-p: no error if it exists)
mv notes/Q3patches.txt reports/             # move a file
touch notes/tasks.txt                       # create an empty file
rm notes/tempnotes.txt                      # delete a file
rmdir temp_directory/                       # delete an EMPTY directory (safer than rm -r)
```

### Evidence integrity
```bash
sha256sum reports/users/Q1_added_users.txt > Q1_added_users.txt.sha256   # record the hash
sha256sum -c Q1_added_users.txt.sha256                                    # verify later
```
> Store the `.sha256` file somewhere separate from the evidence, otherwise someone who can change the file can change the hash too.

### Containment ideas (examples — run only on systems you are authorised to change)
```bash
sudo usermod -s /usr/sbin/nologin <username>   # remove interactive shell
sudo passwd -l <username>                      # lock the password
sudo iptables -A INPUT -s <ip_address> -j DROP # block a source IP
```
Then forward the verified logs to a SIEM for correlation. In real incidents, follow your organisation's IR plan and preserve evidence *before* changing the system.

## 📄 Scripts
| Script | What it does |
|---|---|
| [`audit_tool.sh`](audit_tool.sh) | Read-only audit: counts error lines, counts quarterly reports with `ls \| grep`, checks the Q2 deleted-users and Q4 added-users reports. Takes an optional base directory. |
| [`bootstrap.sh`](bootstrap.sh) | Installs `tcpdump` and `nload` (needs sudo), then computes a false-positive baseline from example numbers (32 alerts, 8 actionable → 75% noise). |

## 🧠 Skills Demonstrated
Linux navigation · log filtering with `grep` and pipes · file-system hygiene · evidence hashing · basic Bash scripting · thinking in an incident-triage workflow.
