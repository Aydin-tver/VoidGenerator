# Dialogue Authoring Guide v0.7

## Required fields

```text
id
speaker
listener
station
type
purpose
conditions
nodes
choices
effects
evidence
mission_links
follow_up
localization_keys
```

## Writing rules

### NPC voice
Each recurring NPC needs:
- vocabulary;
- sentence rhythm;
- attitude;
- what they avoid;
- what they misunderstand;
- what they know.

### Player voice
The player is a ship AI.

Player choices should allow different stances without creating a morality meter:
- direct;
- cautious;
- investigative;
- protective;
- opportunistic;
- withholding.

These are narrative choices, not alignment scores.

### Information
Distinguish:

```text
FACT
CLAIM
BELIEF
EVIDENCE
INTERPRETATION
SECRET
```

### Choice labels
Choice text should describe an actual response/action.

Avoid:
- Good
- Bad
- Moral
- Evil

Prefer:
- "Report the correction."
- "Keep the route private."
- "Ask who authorized it."
- "Show Nova the scan."

## Length

Most functional dialogue:
- 2–6 exchanges.

Major scene:
- 6–15 exchanges.

Important revelation:
- short, precise, followed by an action or choice.

Long monologues should be rare.
