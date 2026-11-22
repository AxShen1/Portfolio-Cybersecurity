# ✅ Secure Scripting Checklist

Use before publishing or deploying any script that runs with extra authority (server scripts, admin tools, automation).

**Input**
- [ ] Every value typed by a user is validated against a whitelist (type, length, characters).
- [ ] No command, query or path is built by concatenating raw input; typed arguments or parameter binding are used instead.
- [ ] Selectors/wildcards (e.g. `@a`, `*`) are rejected unless explicitly intended.

**Access control**
- [ ] One documented permission model; checks happen before the action, in one place.
- [ ] Checks fail closed (error → deny).
- [ ] Privileged actions are logged (who, what, when).
- [ ] Roles stored as editable strings/tags are treated as sensitive.

**Identity and data**
- [ ] Records keyed by immutable IDs (UUID), not display names.
- [ ] Amounts and counters are clamped and validated (no negative or huge values).
- [ ] Constants (prices, limits) are defined once.

**Controls**
- [ ] For every restriction, I listed all the paths around it and covered each one.

**Errors and logging**
- [ ] No empty `catch`. Failures are logged with context.
- [ ] Security-relevant failures stop the action instead of continuing.

**Hygiene**
- [ ] No secrets, tokens, IPs or personal data in the code or in the repo.
- [ ] AI-generated code reviewed line by line, with the same standards as human code.
