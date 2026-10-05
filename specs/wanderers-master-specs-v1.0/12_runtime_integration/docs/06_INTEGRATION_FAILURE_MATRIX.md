# Integration Failure Matrix

| Failure | Expected response |
|---|---|
| Unknown event ID | Build failure |
| Unknown effect | Build failure |
| Missing adapter capability | Controlled integration error |
| Missing localization | Build failure for shipping language |
| Duplicate effect | Idempotent no-op |
| Save version mismatch | Migration path |
| Invalid evidence gate | Mission remains unavailable |
| Unsupported gameplay action | Never fake success |
| Missing character context | Fallback dialogue/context |
| Replay | No duplicated consequences |

The most important rule is:

> Never simulate a successful gameplay action when the host cannot actually perform it.
