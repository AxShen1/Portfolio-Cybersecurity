# 📊 Bank Risk Assessment & Risk Register (NIST CSF)

[![Domain: GRC](https://img.shields.io/badge/Domain-GRC%20%26%20Risk%20Management-blue.svg)](#)
[![Framework: NIST CSF](https://img.shields.io/badge/Framework-NIST%20CSF-green.svg)](#)
[![Method: Likelihood x Severity](https://img.shields.io/badge/Method-Likelihood%20x%20Severity-orange.svg)](#)

## 📌 Overview
A practical risk assessment for a large commercial bank, carried out as a security analyst. I evaluated five risks to the bank's **funds**, scored each one for likelihood and severity, and ranked them to decide where security resources should go first. 

> **Disclaimer:** This is a training exercise. The bank (PKO Bank Polski) is used as a case study, and all figures below are assumptions made for the exercise. They are not real data, and this is not an assessment of the real institution.

## 🏢 Operational Environment (assumed)
- **Location:** Central European country, stable socioeconomic conditions, low violent crime.
- **People:** ~25,000 on-premise employees across many branches and ~5,000 remote/hybrid employees managing central IT.
- **Customers:** ~11,000,000 individual accounts and ~500,000 commercial/corporate accounts.
- **Visibility:** Marketed through professional sports leagues and local business partners, so the brand is highly recognisable.
- **Regulation:** Strict requirements (KNF, European Central Bank) to secure data and funds and hold enough cash and liquid assets every day.

## 🧮 Method
`Priority = Likelihood × Severity`, with both on a 1–3 scale (1 = low, 2 = moderate, 3 = high/catastrophic), giving a priority from 1 to 9.

| Likelihood ↓ / Severity → | Low (1) | Moderate (2) | Catastrophic (3) |
|---|:-:|:-:|:-:|
| **Certain (3)** | 3 | 6 | 9 |
| **Likely (2)** | 2 | 4 | 6 |
| **Rare (1)** | 1 | 2 | 3 |

## 🚨 Risk Register (asset: Funds)
| Risk | Description (vulnerability) | Likelihood | Severity | Priority |
|---|---|:-:|:-:|:-:|
| **Business email compromise** | An employee is tricked into sharing confidential information. | 3 | 2 | 🔴 **6** |
| **Financial records leak** | A database server holding backed-up data is publicly accessible. | 2 | 3 | 🔴 **6** |
| **Compromised user database** | Customer data is poorly encrypted. | 1 | 3 | 🟡 **3** |
| **Theft** | The bank's safe is left unlocked. | 1 | 3 | 🟡 **3** |
| **Supply chain disruption** | Delivery delays due to natural disasters. | 1 | 3 | 🟡 **3** |

## 📝 Analyst Notes
A bank this size manages the financial data of millions of customers and matters strategically to the national economy. Its mix of branch-based and remote staff widens the attack surface for advanced phishing and ransomware. High brand visibility also attracts financially or politically motivated criminal groups.

## ✅ Conclusions & Prioritisation
1. **Business email compromise (6)** is the most likely risk, since phishing needs no technical foothold. Focus on staff awareness training, MFA, and email filtering and verification procedures for payments.
2. **Financial records leak (6)** is less likely but catastrophic. An exposed backup server can mean regulatory fines, customer loss, and reputational damage. Focus on access controls, network segmentation, and regular exposure audits.
3. **Compromised user database, theft and supply chain disruption (3)** are rare events with high impact. Keep them under monitoring (strong encryption, physical access procedures, supplier contingency plans) but with lower priority.

*Mitigations above are my own suggestions, grouped under the NIST CSF functions Identify → Protect → Detect → Respond → Recover.*
