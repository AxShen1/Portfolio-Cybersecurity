# 🎣 Phishing Incident Response: Playbook-Driven Alert Triage (SOC L1)

[![Domain: Incident Response](https://img.shields.io/badge/Domain-Incident%20Response-red.svg)](#)
[![Role: SOC L1 Analyst](https://img.shields.io/badge/Role-SOC%20L1%20Analyst-blue.svg)](#)
[![Focus: Phishing](https://img.shields.io/badge/Focus-Phishing%20%26%20Malware-orange.svg)](#)
[![Artifact: Alert Ticket](https://img.shields.io/badge/Artifact-Alert%20Ticket-green.svg)](#)

## 📌 Overview
Simulation of a SOC Level-1 analyst handling a phishing alert at a financial services company. A suspicious email with an attachment was delivered to an employee. The attachment's SHA-256 hash had already been verified as **malicious** in an earlier threat-intelligence exercise, so the task was to follow the organisation's **Phishing Playbook** (a flowchart plus written steps), decide whether to escalate or close, and document the decision in the alert ticket.

The completed ticket is in [`alert_ticket_A-2703.md`](alert_ticket_A-2703.md).

> **Disclaimer:** This is a training exercise with a simulated alert. All indicators come from the lab scenario, and the sender domain and file are defanged below.

## 🧭 Workflow
1. **Open the ticket:** set status to `Investigating`.
2. **Evaluate the alert** (playbook step 2): review severity, sender details, subject and message body, and any attachments or links, and record notes in the incident handler's journal.
3. **Answer the 5 W's:** who, what, when, where, why.
4. **Check for links or attachments** (steps 3.0, 3.1): does the email contain any, and are they malicious?
5. **Decide** (step 3.2 / step 4): escalate if a malicious indicator is confirmed, otherwise close.
6. **Update the ticket:** set the final status and write the comment explaining what happened and why.

## 🔎 Findings

### The 5 W's
| | |
|---|---|
| **Who** | Sender using the address `76tguyhh6tgftrt7tg[.]su` |
| **What** | A phishing email with an executable attachment, `bfsvc.exe`, was delivered to an employee. It may have been opened (alert A-2703, severity Medium) |
| **Where** | Company mail system (`SERVER-MAIL` alert), employee's mailbox and workstation |
| **Why** | Likely an attempt to get the employee to run malware |

### Indicators supporting escalation
| Indicator | Evidence |
|---|---|
| 🔴 **Malicious attachment** | `bfsvc.exe`, SHA-256 `54e6ea47eb04634d3e87fd7787e2136ccfbcc80ade34f246a12cf93bab527f6b`, previously verified as malicious |
| 🟠 **Suspicious sender** | Random-looking address on a `.su` domain: `76tguyhh6tgftrt7tg[.]su` |
| 🟠 **Poor language** | Grammatical errors in the body, e.g. "I am writing for to express" |
| 🟡 **Severity** | Medium, which the playbook treats as an indication that a ticket may need escalation |

### Decision
**Escalated** to a Level-2 analyst. A confirmed malicious attachment in an email that reached a user is enough to escalate on its own, and the other indicators support the same conclusion. Playbook step 3.2 is the point where this decision is taken.

## 🛠️ Suggested next steps for L2 (my recommendations, not part of the lab)
- Isolate the affected workstation if the attachment was opened.
- Block the file hash and the sender domain at the email gateway and endpoint tools.
- Search for the same sender or attachment in other mailboxes and remove the email.
- Review endpoint logs for execution of `bfsvc.exe`.

## 🧠 Skills Demonstrated
Following an incident response playbook · alert triage and escalation decisions · phishing indicator analysis (sender, body, attachment) · using file-hash reputation · ticket documentation · incident-handler journaling.