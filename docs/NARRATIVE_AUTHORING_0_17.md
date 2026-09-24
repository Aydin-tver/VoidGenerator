# Void Event Engine 0.17 — Narrative Authoring Contract

0.17 freezes a deterministic, merge-friendly contract for parallel narrative authoring.

## Unit of work

One narrative arc is one owned content unit:

```text
stories/act_02/kairos/signal.json
```

The file contains an authoring envelope plus the runtime narrative definition. The envelope declares ownership, stable ID prefixes, localization keys and dependencies before the content is accepted.

## Required metadata

- `schemaVersion = 1`
- `contractVersion = 1`
- `contentId`
- `storyId`
- `namespace`
- `version`
- `owner.agentId`
- `source.path`
- stable node/choice ID prefixes
- localization key list
- event/consequence/narrative dependencies

## Stable IDs

IDs are never regenerated. An authoring agent must preserve them across edits. New nodes/choices receive new IDs under the declared prefix. Renaming an ID is a content migration, not a formatting change.

Recommended pattern:

```text
story: act02.kairos.signal
node:  act02.kairos.signal.node.start
choice: act02.kairos.signal.choice.investigate
```

## Ownership

`owner.agentId` identifies the authoring worker responsible for the content unit. Parallel agents should edit separate content units. Cross-unit references are expressed through `dependencies.narratives`; agents must not silently modify another unit's IDs.

## Contracts first

A narrative may reference only catalogued event and consequence types. If an agent needs a new semantic event or consequence, it must update the relevant contract/catalog in a separate change and add fixtures. The narrative cannot invent domain types locally.

## Localization

Every narrative node must have a `textKey`, and every referenced key must appear in `localization.keys`. Unused declared keys are warnings so agents can clean up stale content without failing a build.

## Merge rules

1. Do not reorder IDs to resolve merge conflicts.
2. Do not reuse deleted IDs.
3. Do not edit another agent's owned content unit without an explicit handoff.
4. Keep dependency declarations explicit.
5. Run structural schema validation and semantic authoring validation before merge.
6. Run narrative graph validation after authoring validation.
7. Keep event/consequence additions separate from story content where possible.

## CI gates

A narrative change should pass:

1. JSON schema validation.
2. Authoring contract validation.
3. Narrative graph/content validation.
4. Event catalog membership validation.
5. Consequence catalog membership validation.
6. Localization key validation.
7. Deterministic simulator fixtures for critical branches.

## Deliberate boundary

The contract does not validate game-domain reachability such as faction reputation, ship capability or world-state values. Those belong to the future Wanderers integration branch.
