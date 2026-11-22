# 🔍 Secure Code Review: Lessons from My Own Game-Server Scripts

[![Topic: Secure Code Review](https://img.shields.io/badge/Topic-Secure%20Code%20Review-blue.svg)](#)
[![Language: JavaScript](https://img.shields.io/badge/Language-JavaScript%20(KubeJS)-yellow.svg)](#)
[![Method: Threat Modelling](https://img.shields.io/badge/Method-Threat%20Modelling-red.svg)](#)

## 📌 Overview
I administered a Minecraft roleplay server and wrote automation for it in **KubeJS** (JavaScript): quests, jobs, a bounty system, faction logic and admin commands. About 60 scripts, roughly 10,000 lines, written **together with an AI assistant**.

Later, while learning security, I reviewed that code as if it belonged to someone else. This repo is the result: what I found, how bad it could be, and how I'd fix it. It is a hobby project, not production software, but the *patterns* are the same ones behind real vulnerabilities (injection, weak authorisation, silent failures).

> **What this is not:** the scripts themselves are not published (they are tied to a private server, its lore and its players). I only show small generic snippets and runnable demos. I read the code but did **not** test exploits on a live server, so findings are marked by how sure I am.

## 🧭 Scope and threat model
| | |
|---|---|
| **System** | Server-side scripts that react to chat, commands, item use, deaths and ticks |
| **Assets** | In-game currency and item rewards, bounty/faction data, admin power, other players' experience |
| **Actors** | Normal player · player with a special *tag* (e.g. bounty manager) · admin/OP · script author (me) |
| **Trust boundaries** | Command arguments typed by a user → my code → console commands run with server authority |
| **Main question** | Can someone make a script do more than its role allows? |

## 🚨 Findings
Severity is my estimate **for this context** (small private server). Confidence: *High* = clearly visible in code, *Medium* = visible but impact not tested.

| ID | Finding | Category | Severity | Confidence |
|---|---|---|---|---|
| F-01 | Free-text command arguments (`GREEDY_STRING`) pasted into console commands, in 26 script files | Injection (CWE-77) | Medium | High (pattern) / Medium (impact) |
| F-02 | Same pattern reachable by a *non-OP* role: the bounty command takes a quoted-string name and uses it in `tag <name> add …` run with server authority | Injection / privilege boundary | Medium | Medium |
| F-03 | Authorisation by entity **tags** and by OP level mixed together (`rbtCanManage`) | Access control (CWE-285) | Low–Medium | High |
| F-04 | Bounties keyed by **username**, not UUID | Identity (CWE-639 style) | Low–Medium | High |
| F-05 | Gag ("mute") only cancels the chat event, not other speech channels | Incomplete control | Low | High |
| F-06 | 267 empty `catch {}` blocks | Error handling (CWE-390) | Low | High |
| F-07 | Same currency table duplicated with *different* values in two systems | Logic / economy | Low | Medium (not traced end to end) |

### F-01 · Command injection via string concatenation
**Pattern:** an admin command registered with `Arguments.GREEDY_STRING` builds commands like
```js
server.runCommandSilent(`execute at ${target} run playsound ... master ${target} ...`);
```
Whatever the admin types, including selectors such as `@a` or `@e[...]`, becomes part of a command. There were ~1,000 `runCommand` calls and 26 files taking greedy strings.

**What the demo shows** ([`examples/injection_demo.js`](examples/injection_demo.js)): a "single target" command silently hits **every player** with `@a`. Appending extra command text produces a malformed command, because the rest of my template is glued on after it. I believe that usually makes the game reject it, but I haven't proven a full arbitrary-command exploit, and clever inputs may exist. That uncertainty is the point: **don't rely on the template saving you.**

**Impact:** the commands require OP level 2, so the realistic attacker is a compromised or careless admin account. Impact: mass effects on players, unintended entity targeting, and a foothold if the same helper is ever exposed to a lower role.

**Fix:** validate against a whitelist and reject anything else (demo: `^[A-Za-z0-9_]{3,16}$` plus `@s`/`@p`), or better, use the engine's typed argument (player/entity selector arguments) so the game parses the target, not my string concatenation. *(The typed-argument version I haven't tested on a live server.)*

### F-02 · Same pattern, lower privilege
The bounty command accepts `Arguments.STRING` (which allows quoted text with spaces) and later runs `tag <name> add wanted_tag` through the server. Because the command is available to a **tag-based role, not only OPs**, the injection boundary is no longer "trusted admin". The fixed `tag` prefix limits what an attacker can do (selectors like `@a` are the obvious abuse; I could not build a full command), but the design is the problem: user input crosses a privilege boundary unvalidated.
**Fix:** validate the name, resolve it to a real online/known player (UUID) first, and never pass raw input to a console-level command.

### F-03 · Authorisation split across two mechanisms
`rbtCanManage()` grants access if the source is OP **or** carries a tag. Tags are just strings on an entity, set by `/tag` or by any script bug. Having two sources of truth makes it hard to answer "who can do this?" and easy to leave one door open.
**Good news:** permission checks are written to **fail closed** (`try { return source.hasPermission(2) } catch { return false }`).
**Fix:** one documented permission model (e.g. permission levels or a single role registry), audited in one place, with logging when a privileged action is used.

### F-04 · Identity by name
Data was stored as `bounties[username]`. Usernames can change, and an old name can be taken by someone else, who then **inherits** the old bounty while the real player loses it ([`examples/identity_demo.js`](examples/identity_demo.js)).
**Fix:** key by UUID, store the last known name only for display.

### F-05 · Control that covers only one channel
The gag command cancels `PlayerEvents.chat`. A gagged player may still talk through other channels (private-message or emote commands, signs, books, depending on the server setup). A control that protects one path while its purpose ("this player can't speak") spans many is an *incomplete mediation* problem.
**Fix:** list every path that must be covered, block them centrally, and test each one.

### F-06 · Silent failures
267 empty `catch {}` blocks. Some are deliberate (probing which API method exists in a modded environment), but they also hide real errors, including failed permission or data-saving steps. If something breaks, there is no trace.
**Fix:** at minimum log with context (`console.warn`), and let *security-relevant* failures stop the action.

### F-07 · Duplicated constants
Two systems each define a coin-value table, with different numbers for the same coins. If they ever exchange currency, the difference is an **arbitrage/duplication** opportunity. I did not trace whether they do.
**Fix:** one shared definition, and a test that a payout and a conversion round-trip to the same value.

## ✅ Things done reasonably well
- Admin commands use `.requires(...)` and fail closed.
- Bounty amounts are clamped (`Math.max(0, Math.min(MAX, …))`).
- Cooldowns on job switching; one-time-use items for sensitive choices.
- No hard-coded secrets, tokens or addresses (I scanned for them).

## 🧠 Lessons learned
1. **Never build commands or queries from raw input.** Whitelist, or use typed arguments.
2. **Authorise in one place**, and fail closed.
3. **Identify things by immutable IDs**, not display names.
4. **A control must cover every path** to the thing it protects.
5. **Don't swallow errors**: silent failure turns a bug into an invisible vulnerability.
6. **AI-written code needs review too.** The assistant produced working code fast, and the same shortcuts (string concatenation, broad `try/catch`) repeated across dozens of files. Reviewing is my job, not the tool's.

## 🔧 Run the demos
```bash
node examples/injection_demo.js     # vulnerable vs fixed command building (mock server, executes nothing)
node examples/identity_demo.js      # name-keyed vs UUID-keyed data
```
Checklist for future scripts: [`SECURE_SCRIPTING_CHECKLIST.md`](SECURE_SCRIPTING_CHECKLIST.md).

## 📚 References
- CWE-77 Command Injection · CWE-285 Improper Authorization · CWE-390 Detection of Error Condition Without Action
- OWASP Top 10: A01 Broken Access Control, A03 Injection

## 📁 Repository Structure
```
.
├── README.md                          # review and findings
├── SECURE_SCRIPTING_CHECKLIST.md      # checklist from the lessons
└── examples/
    ├── injection_demo.js              # F-01/F-02 demo (Node.js)
    └── identity_demo.js               # F-04 demo (Node.js)
```
