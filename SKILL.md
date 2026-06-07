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
- Search before every write with 3-5 strong identifiers. Update matching entries instead of duplicating them.
- Keep `.learnings/ERRORS.md` an index of patterns, not an incident dump.
- Feature requests are moderated capability-growth records, not permission to create tools/skills.
- Agent-spotted skills/tools require user approval before implementation.
- Notify the user only for feature-request changes that affect action: status becomes `user_formed`, `agent_formed`, `in_progress`, `resolved`, or `rejected`, or scope, trigger conditions, approval need, implementation target, or resolution changes.

## Initialize

Before logging, ensure `.learnings/` exists. If starter assets are available, copy only missing files from:

- `assets/LEARNINGS.md` -> `.learnings/LEARNINGS.md`
- `assets/ERRORS.md` -> `.learnings/ERRORS.md`
- `assets/FEATURE_REQUESTS.md` -> `.learnings/FEATURE_REQUESTS.md`

If assets are unavailable, create minimal files with these headings: `# Learnings`, `# Errors`, `# Feature Requests`.

## Trigger Router

- User correction, outdated knowledge, better recurring approach -> `.learnings/LEARNINGS.md`.
- Command failure, exception, timeout, unusable tool/API output -> `.learnings/ERRORS.md` only when reusable, repeated, surprising, high-impact, or likely to recur and not already covered.
- Missing reusable capability, repeated workaround, agent-spotted workflow/tool/skill opportunity -> `.learnings/FEATURE_REQUESTS.md`.
- Pattern appears broad, repeated, or already proven -> promotion review.

Learning categories: `correction`, `insight`, `knowledge_gap`, `best_practice`.

## Write Protocol

Before writing:

1. Read the relevant `.learnings/` file, including `Active Rules From Past Errors` when present.
2. Search with 3-5 strongest identifiers: title/capability, exact error text, command/tool/API, affected path/integration, trigger condition, `Pattern-Key`, or related IDs.
3. Classify the candidate as `same_pattern`, `related_pattern`, or `new_pattern`.
4. For `same_pattern`, update the canonical entry.
5. For `related_pattern`, keep separate entries and add `See Also` links when useful.
6. For `new_pattern`, append a concise entry using the matching asset format.

ID format: `LRN-YYYYMMDD-XXX`, `ERR-YYYYMMDD-XXX`, `FEAT-YYYYMMDD-XXX`; `XXX` may be sequential or a short suffix.

## Entry Requirements

Learning entry minimum fields:

- ID, category, logged timestamp, priority.
- Lesson and action.
- Metadata: source, optional `Pattern-Key`, related files, tags, see-also.
- No `Area`; no routine `Status`.
- When promoted or superseded, replace the full entry with a one-line tombstone.

Error entry minimum fields:

- ID, command/tool/integration name, logged timestamp, priority.
- Summary, shortest useful redacted error excerpt.
- Context, lesson, fix, avoidance rule.
- Metadata: `Pattern-Key`, reproducible, first/last seen, recurrence count, related files, see-also.
- Keep full entries only while active/recent; after fix, promotion, or feature-request handoff, replace with a one-line tombstone.

Feature request entry minimum fields:

- ID, capability name, logged timestamp, priority, status.
- Need, friction, expected behavior, trigger conditions.
- Workaround, implementation direction, approval state, user communication, reminder rule.
- Metadata: frequency, source, related errors/learnings/files, see-also.
- No `Area`; use related files/tags only when they improve retrieval.

Use `assets/*.md` as canonical blank formats when available.

## Error Deduplication

For recurring failures, update one canonical `ERR-*` entry:

- Increment `Recurrence-Count`.
- Update `Last-Seen`.
- Add one short representative example only if it improves recognition.
- Strengthen `Lesson`, `Fix`, or `Avoidance Rule` if incomplete.
- Raise priority if recurrence or impact justifies it.
- Promote prevention rules when the pattern is proven.

Treat changed dates, paths, or surrounding tasks as the same pattern when root cause and fix are the same.

Error escalation:

Escalate an error pattern when any condition is true:

- `Recurrence-Count >= 3`.
- Same pattern appears across 2+ distinct tasks.
- Impact is high/critical.
- Fix needs missing tooling, automation, a skill, user action, or environment change.

Escalation target:

- Prevention rule -> `Active Rules From Past Errors`, `AGENTS.md`, `TOOLS.md`, or a skill.
- Missing reusable capability -> create/update `.learnings/FEATURE_REQUESTS.md`, link `Related Errors`, and keep the error active until the feature request has enough detail to take over tracking.
- User-owned environment problem -> ask the user directly; keep the error active until fixed or handed off.

Error retention:

- Keep `ERRORS.md` as active/recent error memory, not history.
- Keep full entries only while they help avoid, diagnose, or escalate a live/recent pattern.
- After fix, promotion, supersession, stale cleanup, or feature-request handoff, shrink the entry to a one-line tombstone.
- Use the `Resolution` tombstone format.
- Do not create archive files unless the user explicitly asks.

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
- When created from recurring errors, link `Related Errors` and let the feature request become the canonical tracker only after it has `Need`, `Expected Behavior`, `Trigger Conditions`, `Implementation Direction`, `Status`, and `Related Errors`.
- After the feature request is canonical, tombstone the source error as `moved_to_feature` and point to the `FEAT-*` ID.

Reminder rules:

- Only `user_formed`, `agent_formed`, and `in_progress` can trigger proactive reminders.
- Remind when a later task/error/workaround/limitation matches trigger conditions.
- Reminder content: request ID, why relevant now, recommended action: implement, reject, defer, or keep pending.
- Do not remind for `draft`, `resolved`, `rejected`, or `superseded` unless asked.

Feature request retention:

- Keep full entries for `draft`, `user_formed`, `agent_formed`, and `in_progress` while they are actionable or reminder-relevant.
- Keep `resolved`, `rejected`, and `superseded` entries full only while their details are still useful.
- When inactive entries no longer need full detail, shrink them to a one-line tombstone.
- Use the `Resolution` tombstone format.
- For resolved skills, tools, scripts, or workflows, the tombstone note must name the existing skill path or created files clearly enough to prevent duplicate proposals or duplicate creation later.
- Search active entries and tombstones before proposing, creating, or approving a similar capability.

## Skill Extraction Gate

Skill extraction is moderated capability growth.

If the user explicitly asks to create a skill, proceed while checking for duplicates and recording the result when useful.

If the agent spots the opportunity:

1. Search `.learnings/FEATURE_REQUESTS.md` active entries, tombstones, and existing skills for the same trigger/workflow/use case.
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

1. Update feature request `**Status**` when applicable.
2. For errors, replace inactive full entries with a one-line tombstone naming status, target, date, and reason.
3. For learnings, do not append lifecycle metadata to active entries. Replace promoted or superseded entries with a one-line tombstone.
4. For feature requests, keep inactive full entries only while details are useful; then replace them with a one-line tombstone that prevents duplicate capability work.
5. Tombstone formats:
   - `## [LRN-ID] short_title - promoted|superseded: target, YYYY-MM-DD. Note: reason.`
   - `## [ERR-ID] short_title - fixed|promoted|moved_to_feature|superseded|stale: target, YYYY-MM-DD. Note: reason.`
   - `## [FEAT-ID] capability_name - resolved|rejected|superseded: outcome_or_target, YYYY-MM-DD. Note: reason.`

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
4. For learnings and errors, apply the `Resolution` tombstone rules.

Learning retention:

- Keep `LEARNINGS.md` as active working memory, not history.
- Keep only active behavior-changing lessons as full entries.
- After promotion or supersession, shrink the entry to a one-line tombstone.
- Prefer merging duplicate/overlapping lessons into one stronger active entry.
- Do not create archive files unless the user explicitly asks.

Recurring error patterns follow Error Deduplication escalation rules.

## Periodic Review

Review `.learnings/` before major tasks, after substantial work, when near prior mistakes, and during maintenance. Major means multi-step, risky, long-running, repeated-failure-adjacent, or touching agent/workspace behavior. Resolve fixed entries, merge duplicates, link related items, promote proven rules, and escalate recurring issues.
