# 🛡️ Cybersecurity Portfolio

Welcome! This repository collects everything I build while learning cybersecurity: hands-on labs, scripts, cheat sheets, playbooks and write-ups. It's a living record of my progress, and it grows as I learn.

## 🌱 About me and this repo
I'm a beginner, currently working through the **Google Cybersecurity Professional Certificate** plus my own practice. I'm still learning, so some solutions may not be the most elegant or complete. I try to explain what I did and why, and to note where I found problems or made mistakes. Suggestions and corrections are very welcome (issues or pull requests).

<!-- Optional: add one or two sentences about your background here, only what you are comfortable sharing publicly and can back up. -->

## ⚠️ Disclaimer
- Everything here is **my own work and notes from training labs**. This portfolio is not affiliated with or endorsed by Google, Coursera or any other organisation.
- Lab data (logs, captures, user lists) and course materials are **not** reproduced. Where a scenario involves an organisation, it is fictional or used only as a case study, and numbers are assumptions.
- Scripts are for learning. Run them only on systems you own or are authorised to test, ideally in a VM. Some change files, users or permissions; their READMEs say so.

## 📂 What's inside
| Area | Project | What it is |
|---|---|---|
| 🐍 **Python** | [Python for Security Analysts](python/python-for-security-analysts/) | 11 labs: conditionals, loops, functions, strings, regex, file handling, debugging, applied to security scenarios |
| 🐧 **Linux & Bash** | [Incident triage & log analysis](linux-bash/incident-triage-and-log-analysis/) | Navigation, `grep` and pipes, evidence hashing, audit and setup scripts |
| | [CLI recon toolkit](linux-bash/cli-recon-toolkit/) | `whatis` / `man` / `apropos` wrapper for "verify before you execute" |
| | [Permissions hardening](linux-bash/permissions-hardening/) | Finding and fixing excessive `chmod` permissions (least privilege) |
| | [IAM user lifecycle](linux-bash/iam-lifecycle-manager/) | Onboarding to offboarding with `useradd`/`usermod`/`userdel` (dry run by default) |
| | [Workspace sanitizer](linux-bash/workspace-sanitizer/) | Safe cleanup script that records what it did |
| | [Crypto toolkit](linux-bash/linux-crypto-toolkit/) | Caesar cipher and AES-256 (OpenSSL) encrypt/decrypt, with command cheat sheet |
| | [File integrity lab](linux-bash/linux-file-integrity-lab/) | Hash comparison (SHA-256) and byte-level diff to detect tampering |
| 🌐 **Network security** | [Wireshark PCAP analysis](network-security/wireshark-pcap-analysis/) | Display filters and a filter cheat sheet |
| | [tcpdump packet capture](network-security/tcpdump-packet-capture-lab/) | Capturing and reading traffic from the CLI, with command reference |
| | [Suricata IDS](network-security/suricata-ids-lab/) | A custom rule, `fast.log`, and `eve.json` analysis with `jq` |
| 🗄️ **SQL** | [SOC SQL playbook](sql/soc-sql-playbook/) | Queries for alert triage, timelines, asset lookups and threat hunting |
| 🧪 **Home lab** | [VirtualBox lab: Kali + Windows 11](home-lab/) | Build log, security decisions, troubleshooting notes and three helper scripts |
| 🔍 **Secure code review** | [Secure code review](secure-code-review/) | Reviewing my own server-automation scripts (about 10k lines of JavaScript, written with AI help): injection, weak authorisation, identity and error-handling findings, with runnable demos and a checklist |
| 🚨 **Incident response & GRC** | [Phishing response playbook](incident-response-and-grc/phishing-incident-response-playbook/) | Alert triage, IoC analysis, ticket and escalation decision |
| | [E-commerce breach report review](incident-response-and-grc/ecommerce-breach-final-report-review/) | Post-incident review of a forced-browsing data breach, with a reusable template |
| | [Bank risk register](incident-response-and-grc/bank-risk-register/) | Likelihood × severity risk scoring for a fictional bank |

## 🧰 Topics and tools practised
These are things I have actually used in the projects above (and nothing more):

- **Languages and scripting:** Python 3 (standard library, `re`), Bash, SQL (MariaDB/MySQL syntax), JavaScript (KubeJS, Node.js demos)
- **Linux:** command line, `grep`/pipes, permissions (`chmod`), users and groups, hashing (`sha256sum`, `cmp`, `od`), OpenSSL
- **Network analysis:** Wireshark, tcpdump, Suricata (rules, `fast.log`, `eve.json`), `jq`
- **Security operations:** alert triage, phishing analysis, IoC handling, ticketing and escalation, NIST incident response lifecycle
- **Secure code review:** spotting injection, access-control and logging weaknesses; CWE/OWASP mapping
- **GRC:** risk register and scoring, NIST CSF basics, post-incident reporting

## 🗺️ Next on my list
Add new labs as I finish them, and revisit older ones as I learn better ways to do them.

## 📬 Contact
You can reach me through GitHub (issues, discussions or my profile). I'm happy to learn from people working in the field.
