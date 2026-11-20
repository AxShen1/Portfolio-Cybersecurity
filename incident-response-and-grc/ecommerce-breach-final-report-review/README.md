# 📝 Post-Incident Review: E-Commerce Data Breach (NIST IR Lifecycle)

[![Phase: Post-Incident](https://img.shields.io/badge/NIST%20IR%20Phase-Post--Incident%20Activity-blue.svg)](#)
[![Threat: Forced Browsing](https://img.shields.io/badge/Vector-Forced%20Browsing-red.svg)](#)
[![Focus: Root Cause Analysis](https://img.shields.io/badge/Focus-Root%20Cause%20Analysis-green.svg)](#)
[![Role: SOC L1](https://img.shields.io/badge/Role-SOC%20L1%20Analyst-orange.svg)](#)

## 📌 Overview
A review of a **final incident report** for a simulated data breach at a mid-sized retail company (physical stores plus e-commerce, which brings in about 80% of sales). The breach affected **over one million users**. As a new SOC L1 analyst, I reviewed the report to understand the full incident lifecycle and what the team learned from it.

> **Disclaimer:** Training exercise based on a fictional scenario. This is my own summary of what the report contains.

## 🎯 Review Goals and Findings
| Goal | Finding |
|---|---|
| **1. What happened** | A **data theft** incident: attacker(s) accessed and stole customer data from the company's e-commerce platform. |
| **2. Root cause** | Documented in the report's **Investigation** section: a **vulnerability in the e-commerce web application**. |
| **3. Attack technique** | **Forced browsing**: requesting URLs directly to reach pages and resources that the application should not have exposed without authorization. |
| **4. Recommendations implemented** | **Access control mechanisms** and **routine vulnerability scans**. |
| **When it happened / response actions** | Taken from the report's **Timeline** and **Investigation** sections (see the note at the end). |

## 🔍 Analysis

### Why forced browsing works
It is not a clever exploit of the software itself. It succeeds when the application **fails to check authorization on the server side** for each resource requested. If a page or file is "hidden" only because no link points to it, anyone who guesses or finds the URL can read it. This maps to **Broken Access Control**, which OWASP lists among the top web-application risks.

### How the recommendations address the root cause
| Weakness | Control | Effect |
|---|---|---|
| Resources reachable without proper authorization | **Access control mechanisms** | Every request is checked against the user's permissions, so knowing a URL is no longer enough |
| Vulnerability existed undetected | **Routine vulnerability scans** | Similar weaknesses are found and fixed before an attacker uses them |

This follows the NIST principle that post-incident activity should fix the *cause*, not only the symptoms.

## 🔄 Where This Fits: NIST Incident Response Lifecycle
1. Preparation
2. Detection & Analysis
3. Containment, Eradication & Recovery
4. **Post-Incident Activity**: the final report, lessons learned, and recommendations to prevent recurrence. This is the stage covered here.

A good final report gives a comprehensive review of the incident: an **executive summary**, the **investigation** with root cause, a **timeline**, and **recommendations**.

## 🧠 Skills Demonstrated
Reading and evaluating an incident final report · root cause analysis · understanding web application access-control failures · linking remediation to root cause · NIST IR lifecycle knowledge.

## 📁 Repository Structure
```
.
├── README.md                          # review of the final report
└── post_incident_report_template.md   # reusable report template
```

*Note: the "when" and "response actions" details come from the report's timeline, which is not summarised here. Add them from your copy of the report before publishing if you want a complete review.*
