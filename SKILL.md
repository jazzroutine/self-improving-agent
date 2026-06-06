---
name: self-improvement
description: "Captures learnings, errors, and corrections to enable continuous improvement. Use when: (1) A command or operation fails unexpectedly, (2) User corrects the agent, (3) User requests a capability that does not exist, (4) An external API or tool fails, (5) The agent discovers outdated or incorrect knowledge, (6) A better recurring approach is discovered. Also review learnings before major tasks."
metadata:
---

# Self-Improvement Skill

Use this skill to preserve useful corrections, failures, feature requests, and recurring patterns so future agents can avoid repeating the same mistakes.

## Operating Rules

- Capture fresh errors immediately, but do not append to `.learnings/ERRORS.md` until checking for an existing matching entry.
- Prefer short summaries or redacted excerpts over full transcripts or raw command output.
- Never log secrets, tokens, private keys, credentials, environment variables, or sensitive personal data.
- Do not overwrite existing `.learnings/` files.
- Before writing to `.learnings/ERRORS.md`, search existing error headings, `Pattern-Key`, representative error text, and Active Rules. If the failure matches an existing entry, update that entry instead of creating a new one.
- Search existing learnings and feature requests before adding near-duplicate entries.
- Promote broadly applicable learnings into durable agent guidance when they become proven patterns.
- Keep entries specific enough that a future agent can reproduce, fix, or apply the lesson.

## First-Use Initialization

Before logging, ensure the current project or workspace has a `.learnings/` directory with these files:

```bash
mkdir -p .learnings
[ -f .learnings/LEARNINGS.md ] || printf "# Learnings\n\nCorrections, insights, and knowledge gaps captured during development.\n\n**Categories**: correction | insight | knowledge_gap | best_practice\n\n---\n" > .learnings/LEARNINGS.md
[ -f .learnings/ERRORS.md ] || printf "# Errors\n\nCommand failures and integration errors.\n\n---\n" > .learnings/ERRORS.md
[ -f .learnings/FEATURE_REQUESTS.md ] || printf "# Feature Requests\n\nMissing capabilities, user-requested improvements, and agent-spotted skill opportunities that should become part of a user-involved loop.\n\n---\n" > .learnings/FEATURE_REQUESTS.md
```

## Quick Reference

| Situation | Action |
|-----------|--------|
| Command or operation fails | Log to `.learnings/ERRORS.md` |
| User corrects the agent | Log to `.learnings/LEARNINGS.md` with category `correction` |
| User requests a missing capability | Run the feature request workflow; create or update a `user_formed` request once it is actionable |
| Agent notices a reusable capability or skill opportunity | Run the feature request workflow; create or update an `agent_formed` request when it is ready for user review |
| API or external tool fails | Log to `.learnings/ERRORS.md` with integration details |
| Knowledge was outdated or wrong | Log to `.learnings/LEARNINGS.md` with category `knowledge_gap` |
| Better recurring approach is found | Log to `.learnings/LEARNINGS.md` with category `best_practice` |
| Similar error already exists | Update the canonical error entry; do not create a duplicate |
| Related but distinct issue exists | Add `See Also` links between entries |
| Learning is broadly applicable | Promote to an appropriate agent guidance file |

## Detection Triggers

Log a learning when the user says or implies:

- "No, that's not right..."
- "Actually, it should be..."
- "You're wrong about..."
- "That's outdated..."

Run the feature request workflow when the user asks for a capability the agent or toolchain does not currently have, when a missing reusable capability blocks or weakens the task, when a repeated manual workaround shows that automation would help, or when the agent spots an opportunity for a small reusable skill or workflow improvement.

Log a knowledge gap when documentation, behavior, or user-provided information contradicts what the agent expected.

Log an error when a command returns a non-zero exit code, an exception appears, a tool times out, or output is unexpectedly unusable.

## Feature Request Workflow

Use `.learnings/FEATURE_REQUESTS.md` as the moderated backlog for missing capabilities and future skill creation. Feature requests are part of a user-involved loop, not silent notes and not automatic permission to create new tools.

Create or update a feature request only when one of these is true:

1. The user explicitly asks for a capability that does not exist yet.
2. The agent hits a limitation that blocks or meaningfully weakens the task, and the missing capability would be reusable.
3. A repeated manual workaround shows that automation or better tooling would save future effort.
4. The agent notices a concrete opportunity for a small reusable skill, workflow, hook, template, or automation.

Do not log ordinary bugs, vague preferences, one-off wishes, or tasks already being implemented in the current change.

Before adding anything to `.learnings/FEATURE_REQUESTS.md`:

1. Search existing feature requests by capability name, problem area, affected tool, trigger condition, and related error or learning ID.
2. If a matching request exists, update it instead of creating a duplicate. Add context, recurrence, related entries, or a stronger reminder rule as needed.
3. If the request is too vague to make actionable, ask one short clarification question before writing a user_formed or agent_formed request.
4. If the need is real but still unclear, create or keep the entry as `draft` and do not proactively remind the user about it.
5. Use `user_formed` when the user clearly requested the capability and the request is ready.
6. Use `agent_formed` when the agent noticed the opportunity and the request is ready enough for user review.
7. Tell the user immediately when a request becomes `user_formed`, `agent_formed`, `accepted`, materially updated, `rejected`, or `resolved`.

A `user_formed` request must include requested capability, user need, trigger conditions, expected behavior, current workaround, suggested implementation, user communication, and reminder rule.

An `agent_formed` request must be more than a vague idea. It must include observed friction, proposed capability, expected benefit, why approval is needed, trigger conditions, expected behavior, current workaround, suggested implementation, user communication, and reminder rule.

Approval and skill-creation behavior:

- `FEATURE_REQUESTS.md` is the pre-moderation gate for agent-grown capabilities.
- If the agent spots an opportunity to grow, it first creates or updates an `agent_formed` request and tells the user about it.
- The agent must not create a new skill from an agent-spotted opportunity until the user accepts the request.
- After user approval, change the request to `accepted`, then use `assets/SKILL-TEMPLATE.md` and `scripts/extract-skill.sh` when skill extraction is the right implementation path.
- When the skill or capability ships, change the current status to `resolved` and record the resolution.

Reminder behavior:

- Only `user_formed`, `agent_formed`, `accepted`, and `in_progress` feature requests trigger proactive reminders.
- Remind the user when a later task, error, workaround, or limitation matches the request's trigger conditions.
- Keep reminders brief and actionable: name the feature request ID, summarize why it is relevant, and ask or recommend whether to implement, accept, reject, defer, or keep pending.
- Do not remind about `draft`, `resolved`, `rejected`, or `superseded` requests unless the user asks about them directly.

User communication examples:

```text
I added FEAT-YYYYMMDD-001 to .learnings/FEATURE_REQUESTS.md as agent_formed because this recurring workaround looks like a reusable automation opportunity. It is ready for your review; I will not create a skill or tool for it unless you accept it.
```

```text
This touches existing request FEAT-YYYYMMDD-001: automatic related-request reminders. It may be worth accepting for implementation now, rejecting, or keeping pending.
```

## Error Deduplication Workflow

Before adding anything to `.learnings/ERRORS.md`:

1. Read the `Active Rules From Past Errors` section if present.
2. Search existing entries by command/tool name, exact error text, likely root cause, affected path or integration, and `Pattern-Key`.
3. Decide whether the failure is `same_pattern`, `related_pattern`, or `new_pattern`.
4. For `same_pattern`, update the existing entry instead of creating a new `ERR-*` entry. Update `Last-Seen`, `Recurrence-Count`, representative error excerpts, context examples, `Lesson`, `Suggested Fix`, and `Avoidance Rule` as needed.
5. For `related_pattern`, keep a separate entry but add `See Also` links in both entries when practical.
6. For `new_pattern`, create a new entry using the canonical format below.
7. Promote repeated operational fixes into the appropriate guidance file, then mark the error as `promoted`.

Prefer one strong canonical error entry over many chronological incident reports.

## Learning Entry Format

Append to `.learnings/LEARNINGS.md`:

```markdown
## [LRN-YYYYMMDD-XXX] category

**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical
**Status**: pending
**Area**: frontend | backend | infra | tests | docs | config

### Summary
One-line description of what was learned

### Details
Full context: what happened, what was wrong, what's correct

### Suggested Action
Specific fix or improvement to make

### Metadata
- Source: conversation | error | user_feedback
- Related Files: path/to/file.ext
- Tags: tag1, tag2
- See Also: LRN-20250110-001 (if related to existing entry)
- Pattern-Key: simplify.dead_code | harden.input_validation (optional, for recurring-pattern tracking)
- Recurrence-Count: 1 (optional)
- First-Seen: 2025-01-15 (optional)
- Last-Seen: 2025-01-15 (optional)

---
```

## Error Entry Format

Append to `.learnings/ERRORS.md` only when the deduplication workflow says the failure is a `new_pattern`:

````markdown
## [ERR-YYYYMMDD-XXX] skill_or_command_name

**Logged**: ISO-8601 timestamp
**Priority**: high
**Status**: pending
**Area**: frontend | backend | infra | tests | docs | config

### Summary
Brief description of what failed

### Representative Errors
```text
Short exact error message or redacted output excerpt
```

### Context Examples
- Command/operation attempted
- Input or parameters used
- Environment details if relevant
- Summary or redacted excerpt of relevant output

### Lesson
What the failure teaches.

### Suggested Fix
If identifiable, what might resolve this.

### Avoidance Rule
Concrete prevention rule future agents should follow.

### Metadata
- Pattern-Key: tool.sandbox.rtk_missing
- Reproducible: yes | no | unknown
- First-Seen: YYYY-MM-DD
- Last-Seen: YYYY-MM-DD
- Recurrence-Count: 1
- Related Files: path/to/file.ext
- See Also: ERR-20250110-001

---
````

## Feature Request Entry Format

Append to `.learnings/FEATURE_REQUESTS.md` only after the feature request workflow says the capability gap is worth capturing:

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

## ID Generation

Use `TYPE-YYYYMMDD-XXX`:

- `LRN` for learnings
- `ERR` for errors
- `FEAT` for feature requests
- `YYYYMMDD` for the current date
- `XXX` as a sequential number or short random suffix

Examples: `LRN-20250115-001`, `ERR-20250115-A3F`, `FEAT-20250115-002`.

## Resolving Entries

When an issue is fixed:

1. Change `current status` to `**Status**: resolved`.
2. Add a resolution block after metadata.

```markdown
### Resolution
- **Resolved**: 2025-01-16T09:00:00Z
- **Commit/PR**: abc123 or #42
- **Notes**: Brief description of what was done
```

Other status values:

- `draft` - Feature request needs more context before it is actionable.
- `user_formed` - User clearly requested the capability and the request is ready.
- `agent_formed` - Agent noticed a useful opportunity and formed a request that is ready for user review.
- `accepted` - User has agreed the feature should be implemented eventually.
- `in_progress` - Actively being worked on.
- `rejected` or `wont_fix` - Decided not to address; include a reason in resolution notes.
- `superseded` - Replaced by another entry; link the replacement.
- `promoted` - Elevated to durable agent guidance.
- `promoted_to_skill` - Extracted into a reusable skill

## Promotion Guidance

Promote learnings when they are broadly applicable, prevent repeated mistakes, document project conventions, or should be known by future contributors and agents.

Common promotion targets:

| Target | What Belongs There |
|--------|-------------------|
| `CLAUDE.md` | Project facts, conventions, gotchas for Claude interactions |
| `AGENTS.md` | Agent workflows, tool usage patterns, automation rules |
| `.github/copilot-instructions.md` | Project context and conventions for GitHub Copilot |
| `SOUL.md` | Behavioral guidelines, communication style, principles |
| `TOOLS.md` | Tool capabilities, usage patterns, integration gotchas |

Promotion target decision:

- Keep one-off corrections, narrow incidents, and unverified ideas in `.learnings/`.
- Promote repeated operational rules to `TOOLS.md`, `AGENTS.md`, or another durable guidance file that future agents already read.
- Promote reusable procedures with clear triggers, steps, and verification into a skill using `assets/SKILL-TEMPLATE.md`.

Promotion workflow:

1. Distill the learning into a concise rule, fact, or reusable procedure.
2. Choose the promotion target with the decision rule above.
3. Search the target and existing skills for similar guidance before adding new content.
4. Add the distilled content to the appropriate target.
5. Update the original learning status to `promoted` or `promoted_to_skill`.
6. Record the target path or `Skill-Path` in the original entry.

## Recurring Pattern Detection

When a matching error recurs, update the canonical entry. Do not append a new entry merely because the date, command path, or surrounding task changed.

Before logging a similar issue, search `.learnings/` for a relevant keyword, exact error excerpt, command/tool name, affected integration, and `Pattern-Key`.

If the same pattern exists:

1. Increment `Recurrence-Count`.
2. Update `Last-Seen`.
3. Add one short representative example if it improves future recognition.
4. Strengthen `Lesson`, `Suggested Fix`, or `Avoidance Rule` if the prior wording was incomplete.
5. Consider increasing priority.
6. Consider promotion when the pattern repeats across tasks.

If a related but distinct entry exists, add `See Also` references instead of merging unrelated root causes.

Promote recurring patterns when all are true:

- `Recurrence-Count >= 3`
- Seen across at least two distinct tasks
- Occurred within a 30-day window

Write promoted rules as short prevention rules, not incident reports.

## Error Log Hygiene

Keep `.learnings/ERRORS.md` as an error index, not a transcript.

During any error write:

- Remove or merge duplicate entries when the same root cause is already captured.
- Keep only short representative error excerpts.
- Move durable prevention rules into an `Active Rules From Past Errors` section.
- Mark entries `promoted` once their lesson is captured in durable guidance.
- Avoid storing full command output unless the exact output is needed to diagnose the pattern.

## Periodic Review

Review `.learnings/` before major tasks, after completing substantial features, when working near prior mistakes, and during regular maintenance.

During review:

- Resolve fixed items.
- Promote applicable learnings.
- Merge duplicate error entries into canonical entries.
- Link related entries.
- Escalate recurring issues.

## Skill Extraction

Skill extraction is a moderated capability-growth path, not an automatic reaction to every useful idea.

If the user explicitly asks to create a skill, follow the request directly while still checking for duplicate skills and recording the result in `.learnings/` when appropriate.

If the agent spots an opportunity to grow from a recurring limitation, missing workflow, repeated workaround, or useful small automation opportunity, it must first create or update a feature request:

1. Search `.learnings/FEATURE_REQUESTS.md` and existing skills for the same trigger, workflow, or use case.
2. Create or update an `agent_formed` feature request that includes observed friction, proposed capability, expected benefit, approval needed, trigger conditions, expected behavior, current workaround, suggested implementation, user communication, and reminder rule.
3. Tell the user the request is ready for review and that no skill will be created unless they accept it.
4. If the user accepts it, change the request status to `accepted`.
5. Run `scripts/extract-skill.sh skill-name --dry-run` to preview the scaffold from `assets/SKILL-TEMPLATE.md` when a reusable skill is the right implementation path.
6. Create the skill with `scripts/extract-skill.sh skill-name`, then customize the generated `SKILL.md` while preserving the template sections unless a section is genuinely irrelevant.
7. Update the accepted request to `resolved` when the skill or capability is implemented, and record `Skill-Path` or the implemented files in the resolution.
8. Verify the new skill is self-contained in a fresh session.

Quality gates before extraction:

- User has accepted the feature request unless the user explicitly asked for immediate skill creation.
- The request is actionable and has clear trigger conditions.
- Solution is tested or otherwise verified.
- Description is clear without the original conversation and includes trigger conditions.
- Code examples are self-contained.
- No project-specific hardcoded values leak into a general skill.
- Skill name follows lowercase hyphenated naming conventions.
- No existing skill already covers the same trigger or reusable procedure.
