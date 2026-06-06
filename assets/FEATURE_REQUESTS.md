# Feature Requests

Missing capabilities, recurring manual workarounds, and user-requested improvements that should become part of a deliberate user-involved loop.

Use this file only for capability gaps that are worth revisiting. Do not use it for ordinary bugs, one-off wishes, vague preferences, or implementation tasks already being completed now.

---

## When To Add A Feature Request

Create or update a feature request when one of these is true:

1. The user explicitly asks for a capability that does not exist yet.
2. The agent hits a limitation that blocks or meaningfully weakens the task, and the missing capability would be reusable.
3. A repeated manual workaround shows that automation or better tooling would save future effort.

Before adding a new request, search existing entries by capability name, problem area, affected tool, trigger condition, and related error or learning ID. Update a matching request instead of creating a duplicate.

## User-Involved Loop

Feature requests are not passive notes. When the skill creates or updates a formed request, it must keep the user in the loop.

1. Detect the missing capability, limitation, or repeated workaround.
2. Search `.learnings/FEATURE_REQUESTS.md` for an existing matching request.
3. Clarify with one short question if the request is too vague to make actionable.
4. Form the request with user need, trigger conditions, expected behavior, workaround, and implementation direction.
5. Tell the user immediately when a request reaches `formed` status or stronger.
6. Remind the user later when a related task, problem, error, or workaround appears.

Draft requests stay quiet unless the user returns to the topic or clarification is needed. Formed, accepted, and in-progress requests should be surfaced when they are relevant.

## Status Values

- `draft` - needs more user context before it is actionable.
- `formed` - complete enough to notify the user and remind on related work.
- `accepted` - user has agreed it should be implemented eventually.
- `in_progress` - actively being worked on.
- `resolved` - implemented or otherwise satisfied.
- `declined` - intentionally not planned; include the reason.
- `superseded` - replaced by another request; link the replacement.

## Entry Format

```markdown
## [FEAT-YYYYMMDD-XXX] capability_name

**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical
**Status**: draft | formed | accepted | in_progress | resolved | declined | superseded
**Area**: frontend | backend | infra | tests | docs | config | agent-workflow | toolchain

### Requested Capability
What should exist.

### User Need
Why the user needs it and what outcome it would improve.

### Trigger Conditions
When future agents should recognize that this request is relevant again.

### Expected Behavior
What the capability should do when implemented.

### Current Workaround
What the agent or user has to do manually right now.

### Suggested Implementation
Concrete implementation direction, likely files, tools, hooks, or workflow changes.

### User Communication
What the agent told the user when this request became formed, accepted, updated, or resolved.

### Reminder Rule
When future agents should remind the user about this request.

### Metadata
- Frequency: first_time | recurring
- Source: user_request | agent_limitation | repeated_workaround
- Related Errors:
- Related Learnings:
- Related Files:
- See Also:

---
```

## Communication Examples

When a request is formed:

```text
I added FEAT-YYYYMMDD-001 to .learnings/FEATURE_REQUESTS.md for automatic related-request reminders. I will mention it when future tasks touch feature-request logging, reminders, or repeated workaround detection.
```

When a related task appears later:

```text
This touches existing request FEAT-YYYYMMDD-001: automatic related-request reminders. It may be worth implementing now or keeping it pending.
```

When a request is updated instead of duplicated:

```text
I updated existing request FEAT-YYYYMMDD-001 instead of adding a duplicate, because this task has the same trigger and expected behavior.
```
