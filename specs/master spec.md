Wanderers of the Void - Master RPG Specification v2.0

Solo Dev \& AI-Native Edition

Version: 2.0

Date: 06 October 2026

Target Executor: Solo Developer + AI Assistant (LLM)

Status: The only authoritative source. Replaces wanderers-master-specs-v1.0 completely.

Philosophy: Maximum perceived depth with minimum state complexity.

TABLE OF CONTENTS

1\. Philosophy and Limitations

2\. Global State Model

3\. Narrative Architecture

4\. Factions

5\. NPC: Archetypes and Contexts

6\. Dialogues

7\. Quests: Modular System

8\. Skills and Specializations

9\. Equipment

10\. Economy

11\. Exploration

12\. Player Agency

13\. Systemic Depth: Orthogonal Systems

14\. AI Content Pipeline

15\. Acceptance Criteria

16\. Appendices: JSON Schemas

PHILOSOPHY AND LIMITATIONS

1.1 Why v2.0

Original v1.0 specs were unrealizable by a single developer with AI. v2.0 retains 90% of perceived depth at 20% state complexity.

1.2 Three Pillars

Flat State: Maximum 2 levels of nesting in data. No Faction.Subfaction.Leader.Mood.

Tags instead of Trees: World state is described by flat tags and flags, not nested objects.

AI as a Conveyor: AI generates content ONLY in valid JSON format according to a strict schema.

1.3 HARD BLOCKS (Never violate)

HB-01: JSON nesting depth > 2. Reason: AI loses context, debugging is impossible.

HB-02: Dynamic supply/demand simulation. Reason: Impossible to balance solo.

HB-03: Individual memory for every NPC. Reason: Thousands of lines, AI will start repeating.

HB-04: Fully emergent quest generation. Reason: AI will create softlocks.

HB-05: Manual editing of AI content. Reason: Death by routine.

HB-06: A system affecting >3 other systems directly. Reason: Combinatorial explosion.

HB-07: Dialogue that is neither anchor nor atmospheric. Reason: Dead content.

HB-08: Skill check failure = dead end / reload. Reason: Kills agency.

1.4 Production Rule

JSON SCHEMA -> AI PROMPT -> VALIDATED JSON -> AUTO-IMPORT -> RUNTIME

GLOBAL STATE MODEL

2.1 Principle

The entire world state is a single flat JSON object with string: value keys.

2.2 WorldState Structure

{

"ferrum\_war\_active": false,

"ferrum\_tension": 45,

"faction\_a\_rep": 30,

"faction\_b\_rep": -10,

"faction\_c\_rep": 0,

"economy\_price\_multiplier": 1.0,

"economy\_fuel\_shortage": false,

"station\_ferrum\_alert\_level": 0,

"player\_knows\_secret\_reactor": false,

"player\_knows\_smuggler\_route": false,

"npc\_archetype\_smuggler\_hostile": false,

"main\_story\_act": 1,

"main\_story\_flags": \["met\_curator", "found\_drive"],

"zone\_slum\_tension": "normal",

"zone\_dock\_access": "open",

"zone\_market\_status": "normal"

}

2.3 Naming Rules

Rule: snake\_case. Example: faction\_a\_rep. Forbidden: factionARep.

Rule: System prefix. Example: economy\_, faction\_, zone\_, player\_, main\_story\_. Forbidden: rep\_a.

Rule: Booleans = is\_ or verb. Example: economy\_fuel\_shortage. Forbidden: fuel.

Rule: Numbers = 0-100. Example: ferrum\_tension: 45. Forbidden: tension: 4500.

Rule: Enum = string from list. Example: zone\_slum\_tension: "high". Forbidden: tension: 7.

2.4 PlayerState

{

"credits": 1500,

"skills\_engineering": 2,

"skills\_hacking": 3,

"skills\_persuasion": 1,

"skills\_combat": 2,

"skills\_navigation": 1,

"tags": \["saved\_station", "killed\_guard", "has\_encrypted\_drive"],

"inventory": \["plasma\_cutter", "encrypted\_drive", "medkit"],

"equipment\_slots": {

"weapon": "plasma\_cutter",

"scanner": "basic\_scanner",

"engine": "stock\_engine"

}

}

2.5 How systems read state

Each system reads ONLY its own keys + maximum 3 keys from other systems.

Dialogue\_Check:

reads\_own: \["npc\_archetype\_smuggler\_hostile"]

reads\_external: \["faction\_a\_rep", "player\_knows\_secret\_reactor", "zone\_slum\_tension"]

NARRATIVE ARCHITECTURE

3.1 Structure: 3 acts, elastic transitions

Act 1: Arrival. Essence: Meet factions. Activation: Always (start of game).

Act 2: Escalation. Essence: Conflict worsens. Activation: ferrum\_tension >= 60 OR main\_story\_flags contains "triggered\_escalation".

Act 3: Resolution. Essence: Final confrontation. Activation: main\_story\_flags contains "act3\_ready" (set of 3+ flags).

3.2 Act 3 Activation Matrix

{

"act3\_triggers": {

"required\_any\_3\_of": \[

"player\_knows\_secret\_reactor", "faction\_a\_rep >= 50", "faction\_b\_rep >= 50",

"has\_item\_reactor\_key", "completed\_quest\_sabotage", "economy\_fuel\_shortage == true"

]

}

}

3.3 Narrative Circuit Breakers

Broken path: Key NPC curator killed.

Breaker reaction: Deputy becomes curator (same archetype, different lines).



12345

3.4 Oracle System

Oracle\_Responses:

ignored\_quest\_save\_ambassador:

world\_change: "ambassador\_dead"

npc\_dialogue\_override: "You didn't come. The ambassador is dead. But his death gave us a pretext for war."

state\_changes: { "ferrum\_tension": 20, "faction\_a\_rep": -10 }

FACTIONS

4.1 Model: 3 factions, flat parameters

factions:

faction\_a:

name: The Collective

rep: 30

power: 60

economy\_interest: fuel\_trade

tech\_specialty: engineering

internal\_split: hawks\_vs\_doves

secret: reactor\_sabotage

faction\_b:

name: Free Traders

rep: -10

power: 40

economy\_interest: smuggling

tech\_specialty: navigation

internal\_split: loyalists\_vs\_independents

secret: hidden\_route

faction\_c:

name: Station Authority

rep: 0

power: 50

economy\_interest: taxes

tech\_specialty: security

internal\_split: corrupt\_vs\_honest

secret: embezzlement

4.2 Faction Interaction: Conflict Matrix

faction\_conflicts:

a: faction\_a, b: faction\_b, type: economic, intensity: high

a: faction\_a, b: faction\_c, type: political, intensity: medium

a: faction\_b, b: faction\_c, type: criminal, intensity: medium

4.3 Anti-Cosmetic Rule for Factions

Reputation is not the only metric. Two players with faction\_a\_rep = 50 can have different experiences:

Player action: Helped "hawks" inside faction. Tag: helped\_hawks. Effect: Access to military missions, "doves" are hostile.

Player action: Helped "doves". Tag: helped\_doves. Effect: Access to diplomatic missions, "hawks" are hostile.

Player action: Exposed faction secret. Tag: exposed\_faction\_a\_secret. Effect: Reputation drops, but independent NPCs respect you.

4.4 Faction Reactions

Faction\_Reactions:

player\_attacks\_faction\_a\_npc:

state\_changes: { "faction\_a\_rep": -20, "station\_ferrum\_alert\_level": 1 }

dialogue\_override\_archetype: "authority"

dialogue\_line: "You attacked ours. This will not be forgotten."

player\_completes\_faction\_b\_quest:

state\_changes: { "faction\_b\_rep": 10, "faction\_a\_rep": -5 }

NPC: ARCHETYPES AND CONTEXTS

5.1 Principle: No unique NPCs

Every NPC = Archetype + Location Context + Player Relationship Tag.

5.2 Archetypes (8 total)

trader: Trade, economic info. Skills: Persuasion, Navigation.

mechanic: Repair, engineering quests. Skills: Engineering.

informant: Secrets, rumors, hidden quests. Skills: Hacking, Persuasion.

guard: Security, checkpoints. Skills: Combat, Persuasion.

smuggler: Contraband, illegal routes. Skills: Navigation, Hacking.

medic: Healing, biological data. Skills: Engineering.

official: Bureaucracy, permits, laws. Skills: Persuasion.

drifter: Atmosphere, random advice, rumors. Skills: Any.

5.3 Contexts (4 total)

normal: Peacetime. Effect: Standard dialogues and services.

tension: Rising conflict. Effect: Prices +20%, some services unavailable.

war: Open conflict. Effect: Half of NPCs unavailable, checkpoints.

crisis: Disaster (fire, decompression). Effect: Emergency dialogues only.

5.4 NPC Generation Matrix

NPC\_Generation\_Matrix:

archetype: \[trader, mechanic, informant, guard, smuggler, medic, official, drifter]

context: \[normal, tension, war, crisis]

player\_relation: \[neutral, friendly, hostile, indebted]

5.5 Generated NPC Example

{

"npc\_id": "npc\_trader\_ferrum\_dock\_03",

"archetype": "trader",

"location": "ferrum\_dock",

"context": "tension",

"name": "Generated by AI",

"greeting": {

"neutral": "What do you want? Prices went up, not my fault.",

"friendly": "Glad to see a regular. Discount for you, even now.",

"hostile": "Get out. I don't trade with those who hurt business.",

"indebted": "You saved my cargo. Pick what you want, first one is free."

},

"services": \["buy", "sell", "trade\_info"],

"dialogue\_tree\_id": "trader\_tension\_generic"

}

5.6 NPC Memory: At archetype and zone level

NPC\_Memory\_Check:

archetype: trader

zone: ferrum\_dock

checks:

\- if PlayerState.tags contains "stole\_from\_trader":

override\_greeting: "hostile"

price\_modifier: 1.5

\- if WorldState.zone\_dock\_tension == "high":

override\_context: "war"

DIALOGUES

6.1 Two types of dialogues

Anchor: 20%. Changes state? Yes, >= 1 flag/tag. Goal: Key story points, quest decisions.

Atmospheric: 80%. Changes state? No. Goal: Mood, lore, hints, humor.

6.2 Anti-Cosmetic Rule (adapted)

An anchor dialogue MUST change at least one of:

\- WorldState.\* (flag or number)

\- PlayerState.tags (add/remove tag)

\- PlayerState.inventory (give/take item)

If it changes none of these, it is atmospheric. That is normal.

6.3 Dialogue Node Structure (JSON)

{

"dialogue\_id": "dlg\_informant\_reactor\_secret",

"type": "anchor",

"npc\_archetype": "informant",

"required\_context": "normal",

"required\_tags": \["player\_met\_informant"],

"blocking\_tags": \["player\_knows\_secret\_reactor"],

"lines": \[

{

"npc": "Heard you are digging under the reactor. Dangerous topic.",

"player\_options": \[

{

"text": "\[Persuasion 3] Tell me what you know. I will pay.",

"skill\_check": {"skill": "persuasion", "level": 3},

"success": {

"npc": "Fine. The reactor was sabotaged from the inside. Here is the data.",

"state\_changes": {"player\_knows\_secret\_reactor": true, "player\_credits": -200},

"add\_tags": \["knows\_reactor\_sabotage"],

"next\_node": "dlg\_informant\_reactor\_details"

},

"failure": {

"npc": "Unconvincing. Come back when you are serious. Or pay more.",

"state\_changes": {},

"failure\_forward": {"add\_tags": \["informant\_wants\_more\_money"], "next\_node": "dlg\_informant\_bribe\_option"}

}

},

{

"text": "Forget it. I don't want trouble.",

"state\_changes": {},

"next\_node": null

}

]

}

]

}

QUESTS: MODULAR SYSTEM

7.1 Principle: Mad Libs

Quest = Objective + Complication + Reward + Context. AI picks from approved enum lists.

7.2 Enum Lists

objectives: \[deliver\_cargo, eliminate\_target, steal\_data, escort\_npc, sabotage\_equipment, gather\_intel, repair\_system, negotiate\_deal]

complications: \[rival\_faction\_interferes, time\_limit, target\_is\_informant, location\_is\_hostile, cargo\_is\_contraband, npc\_lies, trap\_at\_destination, weather\_hazard]

rewards: \[credits, faction\_rep, equipment, knowledge\_tag, access\_tag, skill\_xp]

approaches: \[combat, stealth, persuasion, hacking, engineering, trade]

7.3 Quest Structure (JSON)

{

"quest\_id": "q\_deliver\_fuel\_complication\_rival",

"objective": "deliver\_cargo",

"complication": "rival\_faction\_interferes",

"reward\_type": "credits",

"reward\_amount": 500,

"min\_approaches": 3,

"approaches": \[

{

"type": "combat",

"description": "Fight through Faction B ambush.",

"required\_skill": {"skill": "combat", "level": 2},

"risk": "high",

"consequences": {"faction\_b\_rep": -10, "station\_ferrum\_alert\_level": 1}

},

{

"type": "stealth",

"description": "Bypass ambush via tech tunnels.",

"required\_skill": {"skill": "navigation", "level": 3},

"risk": "medium",

"consequences": {"station\_ferrum\_alert\_level": 0}

},

{

"type": "persuasion",

"description": "Convince ambush that cargo is not their business.",

"required\_skill": {"skill": "persuasion", "level": 3},

"risk": "low",

"consequences": {"faction\_b\_rep": -5},

"failure\_forward": {"fallback\_approach": "combat", "penalty": {"faction\_b\_rep": -15}}

}

],

"giver\_archetype": "trader",

"giver\_context": "normal",

"required\_tags": \[],

"blocking\_tags": \["completed\_q\_deliver\_fuel\_complication\_rival"]

}

7.4 Anti-Rail Rule (adapted)

Every quest with reward\_amount >= 300 (major) MUST have min\_approaches >= 3.

Minor quests (reward\_amount < 300) may have 1 approach (routine).

SKILLS AND SPECIALIZATIONS

8.1 Principle: Skill = new verbs

Level 0: Skill absent. Cannot choose option.

Level 1: Basic. \[Engineering 1] Fix simple mechanism.

Level 2: Competent. \[Engineering 2] Diagnose malfunction.

Level 3: Expert. \[Engineering 3] Bypass reactor security.

Level 4: Master. \[Engineering 4] Redesign system.

Level 5: Legendary. \[Engineering 5] Create new device from scrap.

8.2 5 Skills (AND THAT'S IT)

engineering: Fix, diagnose, bypass, redesign. Interacts with: Equipment, exploration, quests.

hacking: Hack, decrypt, forge, scan. Interacts with: Dialogues, info, economy.

persuasion: Convince, bargain, intimidate, deceive. Interacts with: Dialogues, factions, quests.

combat: Attack, defend, tactically assess. Interacts with: Fights, checkpoints, risk.

navigation: Plot route, find caches, pilot. Interacts with: Exploration, economy, access.

8.3 Anti-Stat Rule

FORBIDDEN: Engineering +10% repair speed.

ALLOWED: Engineering 3 -> \[new dialogue option] "Diagnose unknown reactor fault and choose safe repair path".

EQUIPMENT

9.1 Principle: Equipment = new actions

9.2 Anti-Stat Rule (strict)

An item is REJECTED if its only effect is: +damage, +armor, +speed, +cargo, -cooldown. These are allowed as additions, but not as the main value.

9.3 Item Structure

{

"item\_id": "plasma\_cutter",

"name": "Plasma Cutter",

"type": "equipment",

"slot": "weapon",

"base\_stats": {"damage": 15},

"verbs": \[

{

"verb": "melt\_through",

"description": "Cut through metal barrier",

"requires": {"target\_tag": "metal\_barrier"},

"unlocks": "new\_path",

"risk": "noise\_alert"

},

{

"verb": "cauterize",

"description": "Cauterize wound (instead of medkit)",

"requires": {"player\_health": "< 50%"},

"unlocks": "heal\_30\_percent",

"risk": "pain\_penalty\_combat\_-1"

}

],

"tags": \["tool", "weapon", "engineering\_synergy"],

"faction\_interaction": {"faction\_a": "legal", "faction\_c": "restricted"}

}

ECONOMY

10.1 Principle: Static multipliers by triggers

NO dynamic supply/demand. NO real-time market simulation.

10.2 Model

Price\_Calculation:

base\_price: item.base\_price

multipliers:

\- if WorldState.economy\_fuel\_shortage == true: x 1.5 (for fuel)

\- if WorldState.faction\_war\_active == true: x 1.3 (for weapons)

\- if PlayerState.tags contains "trusted\_trader": x 0.9

\- if PlayerState.tags contains "faction\_hostile": x 1.5

final\_price: base\_price \* product(all\_applicable\_multipliers)

10.3 Player Economic Actions

Buy/Sell: Standard trade at final\_price. Effect on WorldState: None.

Smuggling: Buy in Zone A, sell in Zone B with multiplier. Effect: Risk: station\_ferrum\_alert\_level += 1.

Bribery: Spend credits on faction\_rep. Effect: credits -= N, faction\_X\_rep += M.

EXPLORATION

11.1 Principle: Convertible Knowledge

Every discovery has the Convertible\_Knowledge tag and at least 2 uses in other systems.

11.2 Discovery Structure

{

"discovery\_id": "disc\_nav\_fragment\_07",

"location": "derelict\_ship\_sector\_4",

"item\_given": "encrypted\_nav\_data",

"tags": \["Convertible\_Knowledge", "navigation\_data"],

"conversions": \[

{"system": "economy", "action": "sell", "value": 500},

{"system": "dialogue", "action": "blackmail\_smuggler", "requires\_tag": "met\_smuggler"},

{"system": "exploration", "action": "reveal\_hidden\_route", "unlocks": "zone\_asteroid\_field"}

],

"skill\_check": {

"skill": "navigation",

"level": 2,

"success": "Get item + conversions",

"failure\_forward": "Get damaged version (sell for 100, no blackmail)"

}

}

PLAYER AGENCY

12.1 Player Loop (adapted)

OBSERVE (see hints, hear rumors)

\-> SET GOAL (choose quest or create own)

\-> PREPARE (check skills, equipment, info)

\-> CHOOSE APPROACH (min. 3 for major tasks)

\-> ACT (skill check / dialogue / combat)

\-> GET CONSEQUENCES (WorldState change)

\-> REASSESS (new opportunities or problems)

12.2 8 Pillars of Agency (simplified)

Goal Agency: Player chooses quests from pool; can ignore story.

Approach Agency: >= 3 approaches for major quests.

Information Agency: Knowledge = tags that unlock options.

Capability Agency: Skills unlock new verbs.

Risk Agency: Each approach has different risk and consequences.

Social Agency: Reputation + internal faction tags.

Economic Agency: Trade, smuggling, speculation, bribery.

Identity Agency: Player tags form a "history" (killer, diplomat, thief).

SYSTEMIC DEPTH: ORTHOGONAL SYSTEMS

13.1 Rule of One Degree of Separation

Each system affects others ONLY through WorldState. Never directly.

BAD: Combat -> changes economy -> changes dialogues -> changes quests (3 degrees, combinatorial explosion).

GOOD: Combat -> changes WorldState.faction\_a\_rep -> faction\_a\_rep affects Price\_Multiplier (economy) and Dialog\_Tree (dialogues). (1 degree: all read one key).

13.2 Failure Forward Matrix

Stealth check fail: Detected -> alert\_level += 1. New path: Combat encounter OR escape.

Persuasion check fail: NPC refuses -> demands bribe. New path: Economic path (pay) OR leave.

Hacking check fail: Terminal locks. New path: Engineering path (physical bypass) OR find another terminal.

Combat check fail: Wounded -> -30% HP. New path: Retreat + medic quest OR desperate last stand.

AI CONTENT PIPELINE

14.1 Conveyor Architecture

Developer creates JSON Schema (by hand, once).

Developer writes master prompt (by hand, once).

Script sends prompt + schema to LLM API.

LLM returns JSON.

Script validates JSON against schema.

If valid -> saves to Game/Data/.

If invalid -> retries request (max 3 times).

On game start -> auto-load all JSON from Game/Data/.

14.2 Developer Tools (Mandatory)

State Debugger (F1): Overlay of all WorldState and PlayerState flags in real time.

Dev Console: /set\_flag, /add\_tag, /reload\_data, /spawn\_quest.

JSON Validator Script: Automatic check on start: schema + dangling links.

14.3 Rules for AI Generation

\- AI generates ONLY data (JSON). Developer writes code.

\- Each request is ONE type of content.

\- Prompt contains FULL enum list of allowed values and FULL JSON Schema.

\- If result is bad -> CHANGE PROMPT, do not edit text manually.

\- Maximum 50 content units per request.

ACCEPTANCE CRITERIA

15.1 For each content unit

\[ ] JSON is valid against schema (auto-check)

\[ ] No dangling links (all required\_tags, item\_id, dialogue\_id exist)

\[ ] No HARD BLOCKS violations

\[ ] Anchor dialogues change >= 1 flag/tag

\[ ] Major quests (reward >= 300) have >= 3 approaches

\[ ] Each approach has failure\_forward

\[ ] Items have >= 1 verb (not just stats)

\[ ] Discoveries have Convertible\_Knowledge with >= 2 uses

15.2 For the system as a whole

\[ ] Maximum JSON nesting depth <= 2

\[ ] Each system reads <= 3 keys from other systems

\[ ] Dev Console allows changing any flag without restart

\[ ] "Intentional break" test: player kills key NPC -> breaker triggers -> game continues

\[ ] 90% of content generated by AI via conveyor without manual editing

APPENDICES: JSON SCHEMAS

16.1 quest\_schema.json

{

"schema": "http://json-schema.org/draft-07/schema#",

"type": "object",

"required": \["quest\_id", "objective", "complication", "reward\_type", "approaches"],

"properties": {

"quest\_id": {"type": "string", "pattern": "^q\_\[a-z0-9\_]+"},

"objective": {"type": "string", "enum": \["deliver\_cargo", "eliminate\_target", "steal\_data", "escort\_npc", "sabotage\_equipment", "gather\_intel", "repair\_system", "negotiate\_deal"]},

"complication": {"type": "string", "enum": \["rival\_faction\_interferes", "time\_limit", "target\_is\_informant", "location\_is\_hostile", "cargo\_is\_contraband", "npc\_lies", "trap\_at\_destination", "weather\_hazard"]},

"reward\_type": {"type": "string", "enum": \["credits", "faction\_rep", "equipment", "knowledge\_tag", "access\_tag", "skill\_xp"]},

"reward\_amount": {"type": "integer", "minimum": 50, "maximum": 5000},

"approaches": {

"type": "array",

"minItems": 1,

"items": {

"type": "object",

"required": \["type", "description", "risk", "consequences"],

"properties": {

"type": {"type": "string", "enum": \["combat", "stealth", "persuasion", "hacking", "engineering", "trade"]},

"description": {"type": "string", "maxLength": 200},

"required\_skill": {"type": "object", "properties": {"skill": {"type": "string"}, "level": {"type": "integer", "minimum": 1, "maximum": 5}}},

"risk": {"type": "string", "enum": \["low", "medium", "high"]},

"consequences": {"type": "object"},

"failure\_forward": {"type": "object"}

}

}

}

}

}

16.2 dialogue\_schema.json

{

"schema": "http://json-schema.org/draft-07/schema#",

"type": "object",

"required": \["dialogue\_id", "type", "npc\_archetype", "lines"],

"properties": {

"dialogue\_id": {"type": "string", "pattern": "^dlg\_\[a-z0-9\_]+"},

"type": {"type": "string", "enum": \["anchor", "atmospheric"]},

"npc\_archetype": {"type": "string", "enum": \["trader", "mechanic", "informant", "guard", "smuggler", "medic", "official", "drifter"]},

"required\_context": {"type": "string", "enum": \["normal", "tension", "war", "crisis"]},

"required\_tags": {"type": "array", "items": {"type": "string"}},

"blocking\_tags": {"type": "array", "items": {"type": "string"}},

"lines": {"type": "array", "items": {"type": "object"}}

}

}

16.3 item\_schema.json

{

"schema": "http://json-schema.org/draft-07/schema#",

"type": "object",

"required": \["item\_id", "name", "type", "verbs"],

"properties": {

"item\_id": {"type": "string", "pattern": "^\[a-z0-9\_]+"},

"name": {"type": "string"},

"type": {"type": "string", "enum": \["equipment", "consumable", "knowledge", "quest\_item"]},

"slot": {"type": "string", "enum": \["weapon", "scanner", "engine", "armor", "utility"]},

"base\_stats": {"type": "object"},

"verbs": {

"type": "array",

"minItems": 1,

"items": {

"type": "object",

"required": \["verb", "description", "unlocks"],

"properties": {

"verb": {"type": "string"},

"description": {"type": "string"},

"requires": {"type": "object"},

"unlocks": {"type": "string"},

"risk": {"type": "string"}

}

}

},

"tags": {"type": "array", "items": {"type": "string"}}

}

}

FINAL NOTE

This document is the ONLY spec. If anything from v1.0 contradicts v2.0, v2.0 is authoritative.

You are not building Dwarf Fortress. You are building a SMART RPG that LOOKS deep, because every system reads and writes to one flat WorldState, and AI fills the forms with content according to strict schemas.

Fewer states. More tags. Strict schemas. Automatic validation. Failure Forward everywhere.

