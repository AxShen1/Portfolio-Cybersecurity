// Demo: keying data by a mutable name vs. by an immutable ID (Node.js)
// Run: node demos/identity_demo.js
// The bounty script stored data like  bounties[username] = amount.
// Usernames can change hands; UUIDs identify the account.

const bountiesByName = {};
const bountiesByUuid = {};

const alice = { uuid: '11111111-1111-1111-1111-111111111111', name: 'Alice_PL' };

// A bounty is placed on Alice.
bountiesByName[alice.name] = 5_000_000;
bountiesByUuid[alice.uuid] = { amount: 5_000_000, lastKnownName: alice.name };

// Alice renames her account; someone else registers the old name.
const newOwnerOfOldName = { uuid: '22222222-2222-2222-2222-222222222222', name: 'Alice_PL' };
alice.name = 'Alice_2';

console.log('Keyed by NAME  -> new owner of "Alice_PL" has bounty:', bountiesByName[newOwnerOfOldName.name]);   // inherited!
console.log('Keyed by NAME  -> real Alice ("Alice_2") has bounty:  ', bountiesByName[alice.name]);              // lost
console.log('Keyed by UUID  -> new owner has bounty:', bountiesByUuid[newOwnerOfOldName.uuid]?.amount ?? 0);
console.log('Keyed by UUID  -> real Alice has bounty:', bountiesByUuid[alice.uuid]?.amount ?? 0);
