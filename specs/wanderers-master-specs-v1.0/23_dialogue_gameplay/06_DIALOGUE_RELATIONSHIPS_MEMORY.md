# Dialogue × NPC Memory v1.0

Conversations generate memory events.

Examples:

`npc.promise_created`
`npc.favor_owed`
`npc.secret_shared`
`npc.lie_suspected`
`npc.lie_exposed`
`npc.trust_changed`
`npc.respect_changed`
`npc.threat_received`
`npc.deal_made`

NPC memory should influence future conversations.

Example:

Player promised Nova to keep research confidential.

Later:
- player keeps promise → trust increases;
- player leaks it → betrayal memory;
- player sells it → relationship may become hostile.

Dialogue therefore creates persistent history.
