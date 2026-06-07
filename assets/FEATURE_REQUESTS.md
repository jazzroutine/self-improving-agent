# Feature Requests

Moderation log for reusable missing capabilities, repeated workarounds, and agent-spotted skill/tool/workflow opportunities. Do not log ordinary bugs, vague wishes, or work already being done.

## Rules

- Search before writing by capability, trigger, affected tool/path, related IDs, expected behavior, and tombstones.
- Update matches; do not duplicate active or previously resolved capabilities.
- Ask one short question if not actionable.
- Agent-spotted skill/tool ideas must be `agent_formed` here before implementation.
- Recurring errors that need reusable tooling/automation belong here; link `Related Errors`.
- When created from an error, this request becomes canonical only after `Need`, `Expected Behavior`, `Trigger Conditions`, `Implementation Direction`, `Status`, and `Related Errors` are filled enough for future agents to act without rereading full error history.
- After that, compact the source error to a `moved_to_feature` tombstone pointing to this `FEAT-*` ID.
- User approval is required before creating agent-spotted skills/tools.
- Notify the user only when a feature-request change affects action: status becomes `user_formed`, `agent_formed`, `in_progress`, `resolved`, or `rejected`, or scope, trigger conditions, approval need, implementation target, or resolution changes.

## Status

- `draft`: real need, not actionable; no reminders.
- `user_formed`: user requested; actionable.
- `agent_formed`: agent identified; ready for user review.
- `in_progress`: approved work active.
- `resolved`: satisfied; record outcome.
- `rejected`: not planned; record reason.
- `superseded`: replaced; link replacement.

Only `user_formed`, `agent_formed`, and `in_progress` may trigger reminders when later work matches triggers.

## Retention

Keep this file as an active capability tracker, not a permanent project history.

- Keep full entries for `draft`, `user_formed`, `agent_formed`, and `in_progress` while actionable or reminder-relevant.
- Keep `resolved`, `rejected`, and `superseded` entries full only while details are still useful.
- When inactive entries no longer need full detail, replace them with a one-line tombstone.
- For resolved skills, tools, scripts, or workflows, the tombstone note must name the existing skill path or created files clearly enough to prevent duplicate proposals or duplicate creation later.
- Search active entries and tombstones before proposing, creating, or approving a similar capability.

## Tombstone

Use only after a request is resolved, rejected, or superseded and no longer needs full detail:

```markdown
## [FEAT-YYYYMMDD-XXX] capability_name - resolved|rejected|superseded: outcome_or_target, YYYY-MM-DD. Note: reason.
```


## Skill Gate

Agent-spotted growth: create/update `agent_formed` request first. After approval, set `in_progress`; if skill is right, use `scripts/extract-skill.sh` + `assets/SKILL-TEMPLATE.md`. On completion, set `resolved` and record `Skill-Path` or files.

## Entry Format

```markdown
## [FEAT-YYYYMMDD-XXX] capability_name

**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical
**Status**: draft | user_formed | agent_formed | in_progress | resolved | rejected | superseded

### Need
Outcome/capability needed.

### Friction
Observed/user-stated pain.

### Expected Behavior
Expected behavior.

### Trigger Conditions
When future agents should surface this.

### Workaround
Current manual path.

### Implementation Direction
Likely approach/files/tool/hook/workflow/skill.

### Approval State
What must be approved before work, especially for `agent_formed`.

### User Communication
Brief status-change note.

### Reminder
When to surface again; omit for inactive statuses.

### Metadata
- Frequency: first_time | recurring
- Source: user_request | agent_limitation | repeated_workaround | agent_opportunity
- Related Errors:
- Related Learnings:
- Related Files:
- See Also:
```

---
