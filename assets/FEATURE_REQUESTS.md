# Feature Requests

Missing capabilities, recurring manual workarounds, user-requested improvements, and agent-spotted skill opportunities that should become part of a deliberate user-involved loop.

Use this file only for capability gaps that are worth revisiting. Do not use it for ordinary bugs, one-off wishes, vague preferences, or implementation tasks already being completed now.

---

## When To Add A Feature Request

Create or update a feature request when one of these is true:

1. The user explicitly asks for a capability that does not exist yet.
2. The agent hits a limitation that blocks or meaningfully weakens the task, and the missing capability would be reusable.
3. A repeated manual workaround shows that automation or better tooling would save future effort.
4. The agent notices a concrete opportunity for a small reusable skill, workflow, hook, template, or automation.

Before adding a new request, search existing entries by capability name, problem area, affected tool, trigger condition, and related error or learning ID. Update a matching request instead of creating a duplicate.

## User-Involved Loop

Feature requests are not passive notes. They are the moderation gate for future capability growth and agent-created skills.

1. Detect the missing capability, limitation, repeated workaround, or agent-spotted skill opportunity.
2. Search `.learnings/FEATURE_REQUESTS.md` for an existing matching request.
3. Clarify with one short question if the request is too vague to make actionable.
4. Form the request with observed friction, requested capability, user need, expected benefit, trigger conditions, expected behavior, workaround, implementation direction, approval needed, and reminder rule.
5. Use `user_formed` when the user clearly requested the capability and the request is ready.
6. Use `agent_formed` when the agent noticed the opportunity and the request is ready enough for user review.
7. Tell the user immediately when a request reaches `user_formed`, `agent_formed`, `accepted`, `rejected`, or `resolved`.
8. Remind the user later when a related task, problem, error, or workaround appears.

Draft requests stay quiet unless the user returns to the topic or clarification is needed. User-formed, agent-formed, accepted, and in-progress requests should be surfaced when they are relevant.

## Skill Creation Gate

If an agent spots an opportunity to grow, it must create or update an `agent_formed` feature request before creating a skill. The request must be ready for user review, not a vague idea.

Only after the user accepts the request should the agent use `assets/SKILL-TEMPLATE.md` and `scripts/extract-skill.sh` to create a reusable skill, when a skill is the right implementation path. After implementation, mark the request `resolved` and record `Skill-Path` or implemented files in the resolution.

## Status Values

- `draft` - needs more context before it is actionable.
- `user_formed` - user clearly requested the capability and the request is ready.
- `agent_formed` - agent noticed a useful opportunity and formed a request that is ready for user review.
- `accepted` - user has agreed it should be implemented eventually.
- `in_progress` - actively being worked on.
- `resolved` - implemented or otherwise satisfied.
- `rejected` - intentionally not planned; include the reason.
- `superseded` - replaced by another request; link the replacement.

## Entry Format

```markdown
## [FEAT-YYYYMMDD-XXX] capability_name

**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical
**Status**: draft | user_formed | agent_formed | accepted | in_progress | resolved | rejected | superseded
**Area**: frontend | backend | infra | tests | docs | config | agent-workflow | toolchain

### Requested Capability
What should exist.

### Observed Friction
For agent_formed requests, the concrete limitation, repeated workaround, or opportunity the agent observed. For user_formed requests, summarize the user's stated friction.

### User Need
Why the user needs it and what outcome it would improve.

### Expected Benefit
What improves if this request is accepted and implemented.

### Trigger Conditions
When future agents should recognize that this request is relevant again.

### Expected Behavior
What the capability should do when implemented.

### Current Workaround
What the agent or user has to do manually right now.

### Suggested Implementation
Concrete implementation direction, likely files, tools, hooks, or workflow changes.

### Approval Needed
For agent_formed requests, what user approval is required before implementation or skill creation. For user_formed requests, note whether the request is already approved for immediate work or only captured for later.

### User Communication
What the agent told the user when this request became user_formed, agent_formed, accepted, updated, rejected, or resolved.

### Reminder Rule
When future agents should remind the user about this request.

### Metadata
- Frequency: first_time | recurring
- Source: user_request | agent_limitation | repeated_workaround | agent_opportunity
- Related Errors:
- Related Learnings:
- Related Files:
- See Also:

---
```

## Communication Examples

When an agent-formed request is created:

```text
I added FEAT-YYYYMMDD-001 to .learnings/FEATURE_REQUESTS.md as agent_formed because this recurring workaround looks like a reusable automation opportunity. It is ready for your review; I will not create a skill or tool for it unless you accept it.
```

When a related task appears later:

```text
This touches existing request FEAT-YYYYMMDD-001: automatic related-request reminders. It may be worth accepting for implementation now, rejecting, or keeping pending.
```

When a request is updated instead of duplicated:

```text
I updated existing request FEAT-YYYYMMDD-001 instead of adding a duplicate, because this task has the same trigger and expected behavior.
```
