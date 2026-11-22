// Demo: command injection through string concatenation (Node.js, no dependencies)
// Run: node demos/injection_demo.js
//
// Models the pattern found in my own game-server scripts: an admin-level command
// takes free text (a "greedy string") and pastes it into a console command.
// The mock server below only LOGS what it would run, so nothing is executed.

const sent = [];
const server = { runCommandSilent: (cmd) => { sent.push(cmd); return 1; } };

// ---------- VULNERABLE (the original pattern) ----------
function effectVulnerable(server, rawTarget) {
  const target = String(rawTarget).trim();
  server.runCommandSilent(`execute at ${target} run playsound minecraft:block.amethyst_block.chime master ${target} ~ ~ ~ 1 1`);
  server.runCommandSilent(`effect give ${target} minecraft:nausea 6 1 true`);
}

// ---------- FIXED: whitelist validation before building the command ----------
// Java Edition names: 3-16 chars of letters, digits and underscore.
const NAME_RE = /^[A-Za-z0-9_]{3,16}$/;
// Allow only the simple selectors we really need (no [filters]).
const SELECTORS = new Set(['@s', '@p']);

function validTarget(raw) {
  const t = String(raw);                       // do NOT trim away surprises silently
  return NAME_RE.test(t) || SELECTORS.has(t);
}

function effectFixed(server, rawTarget) {
  if (!validTarget(rawTarget)) return 0;       // fail closed: reject, don't "clean"
  server.runCommandSilent(`execute at ${rawTarget} run playsound minecraft:block.amethyst_block.chime master ${rawTarget} ~ ~ ~ 1 1`);
  server.runCommandSilent(`effect give ${rawTarget} minecraft:nausea 6 1 true`);
  return 1;
}

const inputs = [
  'Steve',                                 // normal
  '@a',                                    // selector: affects EVERY player, not one "target"
  '@e[type=!player,distance=..50]',        // selector with filters
  'Steve run say injected',                // extra command text after the name
];

for (const [label, fn] of [['VULNERABLE', effectVulnerable], ['FIXED', effectFixed]]) {
  console.log(`\n=== ${label} ===`);
  for (const input of inputs) {
    sent.length = 0;
    const result = fn(server, input);
    console.log(`input: ${JSON.stringify(input)}`);
    console.log(sent.length ? sent.map(c => '   -> ' + c).join('\n') : '   (rejected, nothing sent)');
  }
}
