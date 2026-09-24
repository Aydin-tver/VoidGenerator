# Shadow Run Plan

The new engine must observe real gameplay before it becomes authoritative.

## Phase A — dual observation

Publish the same domain event to:

- legacy `GameplayMissionUseCase.record()` adapter;
- Event Engine runtime.

Only the legacy path can grant rewards.

## Phase B — compare

After every relevant event, capture:

- completion;
- failure;
- objective progress;
- active objective IDs.

`ShadowRunComparator` reports mismatches.

## Phase C — quarantine

Mismatch categories:

- EVENT_CONTRACT_MISMATCH
- PROGRESS_MISMATCH
- COMPLETION_MISMATCH
- FAILURE_MISMATCH
- EFFECT_MISMATCH

Do not silently compensate for mismatches in the adapter.

## Phase D — cutover

For a migrated mission family:

1. enable event-engine authority behind a feature flag;
2. keep shadow comparison for telemetry;
3. disable legacy reward execution;
4. after stable verification, remove the legacy objective mapping.
