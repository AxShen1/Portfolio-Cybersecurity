# Alert Ticket A-2703

| Field | Value |
|---|---|
| **Ticket ID** | A-2703 |
| **Alert message** | SERVER-MAIL Phishing attempt possible download of malware |
| **Severity** | Medium |
| **Details** | The user may have opened a malicious email and opened attachments or clicked links. |
| **Ticket status** | ~~Open~~ → Investigating → **Escalated** |

## Ticket comments
This alert was triggered by a potential phishing email with an attachment delivered to an employee. Based on my investigation, I am escalating this ticket to a Level-2 SOC analyst for immediate action.

The email contains multiple suspicious indicators:
- **Language:** grammatical errors in the message body (e.g. "I am writing for to express").
- **Sender:** a suspicious address, `76tguyhh6tgftrt7tg[.]su`.
- **Attachment:** an executable file named `bfsvc.exe`, whose SHA-256 hash (`54e6ea47eb04634d3e87fd7787e2136ccfbcc80ade34f246a12cf93bab527f6b`) has been verified as malicious.

Following the Phishing Playbook, a confirmed malicious attachment in an email delivered to a user, together with a Medium severity rating, requires escalation.
