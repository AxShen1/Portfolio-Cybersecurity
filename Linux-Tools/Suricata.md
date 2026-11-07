# 🛡️ Suricata IDS Lab: Custom Rules, Alerts & JSON Log Analysis

[![Platform: Linux CLI](https://img.shields.io/badge/Platform-Linux%20CLI-orange.svg)](#)
[![Tool: Suricata](https://img.shields.io/badge/Tool-Suricata%20IDS-blue.svg)](#)
[![Tool: jq](https://img.shields.io/badge/Log%20Parsing-jq-green.svg)](#)
[![Role: SOC Analyst](https://img.shields.io/badge/Role-SOC%20Analyst-red.svg)](#)

## 📌 Overview
Hands-on lab with **Suricata**, an open-source IDS/IPS and network analysis tool. As a security analyst I examined a custom signature, replayed a packet capture (`sample.pcap`) against it to trigger alerts, and analysed the resulting logs (`fast.log` and `eve.json`) with `jq`.

The rule is in [`Suricata_custom.rules`](Suricata_custom.rules).

## 🧩 1. Anatomy of the Rule
```
alert http $HOME_NET any -> $EXTERNAL_NET any (msg:"GET on wire"; flow:established,to_server; content:"GET"; http_method; sid:12345; rev:3;)
```
| Part | Value | Meaning |
|---|---|---|
| **Action** | `alert` | Generate an alert. Others: `drop` (alert + drop, IPS mode only), `reject` (send TCP reset), `pass` (allow, overrides other rules) |
| **Protocol** | `http` | Applies only to HTTP traffic |
| **Source → Destination** | `$HOME_NET any -> $EXTERNAL_NET any` | From any port in the home network (`172.21.224.0/20` in this lab, set in `/etc/suricata/suricata.yaml`) to any external address and port |
| `msg` | `"GET on wire"` | Text shown in the alert |
| `flow` | `established,to_server` | Only established connections, client-to-server direction |
| `content` + `http_method` | `"GET"` | Match the word GET in the HTTP method |
| `sid` / `rev` | `12345` / `3` | Unique rule ID / revision number |

**In short:** the rule alerts whenever an HTTP GET request leaves the home network.

> Rule order: Suricata loads rules in file order but processes actions in the order **pass → drop → reject → alert**, which affects the final verdict for a packet.

## 🚀 2. Triggering the Rule (PCAP Replay)
```bash
ls -l /var/log/suricata                              # empty before the run
sudo suricata -r sample.pcap -S custom.rules -k none # replay capture against the rule
ls -l /var/log/suricata                              # logs now exist, incl. fast.log and eve.json
cat /var/log/suricata/fast.log
```
| Option | Purpose |
|---|---|
| `-r sample.pcap` | Read packets from a capture file instead of a live interface |
| `-S custom.rules` | Load only this rule file |
| `-k none` | Disable checksum validation (not needed for a recorded capture) |

Resulting `fast.log` alerts:
```
11/23/2022-12:38:34.624866 [**] [1:12345:3] GET on wire [**] [Classification: (null)] [Priority: 3] {TCP} 172.21.224.2:49652 -> 142.250.1.139:80
11/23/2022-12:38:58.958203 [**] [1:12345:3] GET on wire [**] [Classification: (null)] [Priority: 3] {TCP} 172.21.224.2:58494 -> 142.250.1.139:80
```
Each line shows the timestamp, signature ID (`gid:sid:rev`), message, priority, protocol, and source → destination. `fast.log` is a legacy, single-line format that is handy for quick checks (e.g. counting alerts after changing a rule), but it is not recommended for incident response or threat hunting.

## 🔎 3. Analysing `eve.json` with `jq`
`eve.json` is Suricata's main log: JSON with far more detail than `fast.log`, including other network telemetry events.

```bash
# Pretty-print the whole file (q to quit less)
jq . /var/log/suricata/eve.json | less

# Extract key fields: timestamp, flow ID, signature, protocol, destination IP
jq -c "[.timestamp,.flow_id,.alert.signature,.proto,.dest_ip]" /var/log/suricata/eve.json
# ["2022-11-23T12:38:34.624866+0000",14500150016149,"GET on wire","TCP","142.250.1.139"]
# ["2022-11-23T12:38:58.958203+0000",1647223379236084,"GET on wire","TCP","142.250.1.102"]

# Show every event belonging to one network flow (replace X with a flow_id)
jq "select(.flow_id==X)" /var/log/suricata/eve.json
```
**Why `flow_id` matters:** a network flow is a sequence of packets between a source and destination sharing characteristics such as IPs and protocol. Suricata gives every flow a unique `flow_id` and stamps it on all related log entries, so an analyst can pivot from one alert to the full story of that connection.

## 🧠 Key Takeaways
- Suricata signatures have three parts: **action, header, rule options**.
- Testing rules against a PCAP is a safe, repeatable way to validate detections before deploying them.
- `eve.json` + `jq` gives structured, filterable telemetry; `fast.log` is only for quick checks.
- A broad rule like "any outbound GET" gives visibility but is noisy. In production I would narrow it (specific hosts, URIs, user-agents, thresholds) to avoid alert fatigue.

