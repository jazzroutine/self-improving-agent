# Errors Log

Active/recent pattern index for command/tool/API failures. No transcripts. Not history.

## Active Rules From Past Errors

Add proven prevention rules here; link canonical `ERR-*` when useful.

## Rules

- Search before writing by command/tool/API, exact redacted error, root cause, affected path/integration, `Pattern-Key`, and related IDs.
- Same cause + same fix = update one canonical entry; increment `Recurrence-Count` and `Last-Seen`.
- Keep full entries only while they help avoid, diagnose, or escalate an active/recent pattern.
- Escalate when recurrence is `>= 3`, appears across 2+ tasks, impact is high/critical, or fix needs missing tooling/user action.
- Missing reusable capability -> create/update `FEATURE_REQUESTS.md`, link `Related Errors`, and keep the error active until the feature request is canonical.
- A feature request is canonical when it has `Need`, `Behavior`, `Triggers`, `Implementation`, `Status`, and `Related Errors`; then tombstone the error as `moved_to_feature` pointing to the `FEAT-*` ID.
- Proven prevention rule -> move to `Active Rules From Past Errors`, durable guidance, or a skill, then tombstone the error.
- Fixed/superseded/stale entries become one-line tombstones; do not create archive files unless user asks.

## Tombstone

```markdown
## [ERR-YYYYMMDD-XXX] short_title - fixed|promoted|moved_to_feature|superseded|stale: target, YYYY-MM-DD. Note: reason.
```

## Entry Format

````markdown
## [ERR-YYYYMMDD-XXX] command_or_integration

**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical

### Summary
Failure + impact in one sentence.

### Error
```text
Shortest useful redacted excerpt.
```

### Context
- Operation:
- Environment:
- Trigger:

### Lesson
Reusable cause or constraint.

### Fix
Preferred fix, workaround, or escalation action.

### Avoid
Prevention rule.

### Metadata
- Pattern-Key:
- Reproducible: yes | no | unknown
- First-Seen: YYYY-MM-DD
- Last-Seen: YYYY-MM-DD
- Recurrence-Count: 1
- Related Feature Requests:
- Related Files:
- See Also:
````

---
