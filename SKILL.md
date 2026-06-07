---
name: self-improvement
description: "Capture corrections, failures, missing capabilities, and recurring patterns. Use when commands/tools/APIs fail, the user corrects the agent, knowledge is outdated, a reusable workaround appears, or capability growth should be reviewed before skill/tool creation."
metadata:
---

# Self-Improvement Skill

Persist only reusable learning. Prefer short, redacted, deduplicated entries over chronological transcripts.

## Hard Rules

- Never log secrets, tokens, keys, credentials, env vars, sensitive personal data, raw transcripts, or long command output.
- Never overwrite existing `.learnings/` files. Create only missing files.
- Search before every write. Update matching entries instead of duplicating them.
- Keep `.learnings/ERRORS.md` an index of patterns, not an incident dump.
- Feature requests are moderated capability-growth records, not permission to create tools/skills.
- Agent-spotted skills/tools require user approval before implementation.
- Tell the user briefly when a feature request becomes `user_formed`, `agent_formed`, `in_progress`, materially updated, `resolved`, or `rejected`.

## Initialize

Before logging, ensure `.learnings/` exists. If starter assets are available, copy only missing files from:

- `assets/LEARNINGS.md` -> `.learnings/LEARNINGS.md`
- `assets/ERRORS.md` -> `.learnings/ERRORS.md`
- `assets/FEATURE_REQUESTS.md` -> `.learnings/FEATURE_REQUESTS.md`

If assets are unavailable, create minimal files with these headings: `# Learnings`, `# Errors`, `# Feature Requests`.

## Trigger Router

- User correction, outdated knowledge, better recurring approach -> `.learnings/LEARNINGS.md`.
- Command failure, exception, timeout, unusable tool/API output -> `.learnings/ERRORS.md`.
- Missing reusable capability, repeated workaround, agent-spotted workflow/tool/skill opportunity -> `.learnings/FEATURE_REQUESTS.md`.
- Pattern appears broad, repeated, or already proven -> promotion review.

Learning categories: `correction`, `insight`, `knowledge_gap`, `best_practice`.

## Write Protocol

Before writing:

1. Read the relevant `.learnings/` file, including `Active Rules From Past Errors` when present.
2. Search by title/capability, exact error text, command/tool/API, affected path/integration, trigger condition, `Pattern-Key`, and related IDs.
3. Classify the candidate as `same_pattern`, `related_pattern`, or `new_pattern`.
4. For `same_pattern`, update the canonical entry.
5. For `related_pattern`, keep separate entries and add `See Also` links when useful.
6. For `new_pattern`, append a concise entry using the matching asset format.

ID format: `LRN-YYYYMMDD-XXX`, `ERR-YYYYMMDD-XXX`, `FEAT-YYYYMMDD-XXX`; `XXX` may be sequential or a short suffix.

## Entry Requirements

Learning entry minimum fields:

- ID, category, logged timestamp, priority, status, area.
- Summary, details, suggested action.
- Metadata: source, related files, tags, see-also, optional `Pattern-Key`, recurrence fields.

Error entry minimum fields:

- ID, command/tool/integration name, logged timestamp, priority, status, area.
- Summary, short representative redacted error excerpt.
- Context examples, lesson, suggested fix, avoidance rule.
- Metadata: `Pattern-Key`, reproducible, first/last seen, recurrence count, related files, see-also.

Feature request entry minimum fields:

- ID, capability name, logged timestamp, priority, status, area.
- Requested capability, observed friction, user need, expected benefit.
- Trigger conditions, expected behavior, current workaround, suggested implementation.
- Approval needed, user communication, reminder rule.
- Metadata: frequency, source, related errors/learnings/files, see-also.

Use `assets/*.md` as canonical blank formats when available.

## Error Deduplication

For recurring failures, update one canonical `ERR-*` entry:

- Increment `Recurrence-Count`.
- Update `Last-Seen`.
- Add one short representative example only if it improves recognition.
- Strengthen `Lesson`, `Suggested Fix`, or `Avoidance Rule` if incomplete.
- Raise priority if recurrence or impact justifies it.
- Promote prevention rules when the pattern is proven.

Treat changed dates, paths, or surrounding tasks as the same pattern when root cause and fix are the same.

## Feature Request Workflow

Create/update a feature request only for actionable missing capability or reusable automation. Do not log ordinary bugs, vague preferences, one-off wishes, or work already being implemented.

Statuses:

- `draft`: real need, not yet actionable; no proactive reminders.
- `user_formed`: user requested it and it is ready.
- `agent_formed`: agent identified it and it is ready for user review.
- `in_progress`: user-approved work is being implemented.
- `resolved`: implemented or otherwise satisfied; record outcome.
- `rejected`: not pursuing; record reason.
- `superseded`: replaced; link replacement.

Formation rules:

- Use `user_formed` when the user clearly requested the capability and the request is actionable.
- Use `agent_formed` only when observed friction, expected benefit, trigger conditions, expected behavior, workaround, implementation direction, approval need, user communication, and reminder rule are clear.
- If vague, ask one short clarification question or keep `draft`.
- If matching request exists, update it with recurrence, context, related IDs, or stronger reminder rules.

Reminder rules:

- Only `user_formed`, `agent_formed`, and `in_progress` can trigger proactive reminders.
- Remind when a later task/error/workaround/limitation matches trigger conditions.
- Reminder content: request ID, why relevant now, recommended action: implement, reject, defer, or keep pending.
- Do not remind for `draft`, `resolved`, `rejected`, or `superseded` unless asked.

## Skill Extraction Gate

Skill extraction is moderated capability growth.

If the user explicitly asks to create a skill, proceed while checking for duplicates and recording the result when useful.

If the agent spots the opportunity:

1. Search `.learnings/FEATURE_REQUESTS.md` and existing skills for the same trigger/workflow/use case.
2. Create/update an `agent_formed` feature request.
3. Tell the user it is ready for review and no skill/tool will be created without approval.
4. After approval, set status `in_progress`.
5. If a skill is the right path, preview with `scripts/extract-skill.sh skill-name --dry-run`.
6. Create with `scripts/extract-skill.sh skill-name`.
7. Customize generated `SKILL.md`; preserve template sections unless irrelevant.
8. Mark request `resolved`; record `Skill-Path`, files, commit/PR, and notes.
9. Verify the new skill is self-contained in a fresh session.

Extraction quality gates:

- User approval exists unless the user explicitly requested immediate skill creation.
- Trigger conditions and expected behavior are clear.
- No existing skill covers the same procedure.
- Skill name is lowercase hyphenated.
- Examples are self-contained.
- No project-specific hardcoded values leak into a general skill.
- Implementation is tested or otherwise verified.

## Resolution

When an entry is fixed, implemented, rejected, superseded, or promoted:

1. Update `**Status**`.
2. Add `### Resolution` with date/time, commit/PR or file path if relevant, and short notes.
3. For promoted learnings/errors, record destination path or `Skill-Path`.

Learning and error entries may use `promoted` when their lesson has moved into durable guidance.

## Promotion

Promote when a lesson is broadly applicable, prevents repeated mistakes, documents conventions, or should be loaded by future agents.

Targets:

- `AGENTS.md`: agent workflows, repo rules, automation patterns.
- `TOOLS.md`: tool behavior, command gotchas, integrations.
- `SOUL.md`: behavior, communication, principles.
- `CLAUDE.md`: Claude-facing project facts/conventions.
- `.github/copilot-instructions.md`: Copilot-facing project facts/conventions.
- New skill: reusable procedure with clear triggers, steps, and verification.

Promotion workflow:

1. Distill to a concise rule/procedure.
2. Search target and existing skills for overlap.
3. Add only the durable guidance.
4. Mark source entry `promoted` and record target.

Promote recurring error patterns when `Recurrence-Count >= 3`, seen across at least two distinct tasks, and within a 30-day window.

## Periodic Review

Review `.learnings/` before major tasks, after substantial work, when near prior mistakes, and during maintenance. Resolve fixed entries, merge duplicates, link related items, promote proven rules, and escalate recurring issues.
