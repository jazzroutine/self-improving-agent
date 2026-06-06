---
name: self-improvement
description: "Captures learnings, errors, and corrections to enable continuous improvement. Use when: (1) A command or operation fails unexpectedly, (2) User corrects the agent, (3) User requests a capability that does not exist, (4) An external API or tool fails, (5) The agent discovers outdated or incorrect knowledge, (6) A better recurring approach is discovered. Also review learnings before major tasks."
metadata:
---

# Self-Improvement Skill

Use this skill to preserve useful corrections, failures, feature requests, and recurring patterns so future agents can avoid repeating the same mistakes.

## Operating Rules

- Log immediately when the trigger is fresh.
- Prefer short summaries or redacted excerpts over full transcripts or raw command output.
- Never log secrets, tokens, private keys, credentials, environment variables, or sensitive personal data.
- Do not overwrite existing `.learnings/` files.
- Search existing learnings before adding a near-duplicate entry.
- Promote broadly applicable learnings into durable agent guidance when they become proven patterns.
- Keep entries specific enough that a future agent can reproduce, fix, or apply the lesson.

## First-Use Initialization

Before logging, ensure the current project or workspace has a `.learnings/` directory with these files:

```bash
mkdir -p .learnings
[ -f .learnings/LEARNINGS.md ] || printf "# Learnings\n\nCorrections, insights, and knowledge gaps captured during development.\n\n**Categories**: correction | insight | knowledge_gap | best_practice\n\n---\n" > .learnings/LEARNINGS.md
[ -f .learnings/ERRORS.md ] || printf "# Errors\n\nCommand failures and integration errors.\n\n---\n" > .learnings/ERRORS.md
[ -f .learnings/FEATURE_REQUESTS.md ] || printf "# Feature Requests\n\nCapabilities requested by the user.\n\n---\n" > .learnings/FEATURE_REQUESTS.md
```

## Quick Reference

| Situation | Action |
|-----------|--------|
| Command or operation fails | Log to `.learnings/ERRORS.md` |
| User corrects the agent | Log to `.learnings/LEARNINGS.md` with category `correction` |
| User requests a missing capability | Log to `.learnings/FEATURE_REQUESTS.md` |
| API or external tool fails | Log to `.learnings/ERRORS.md` with integration details |
| Knowledge was outdated or wrong | Log to `.learnings/LEARNINGS.md` with category `knowledge_gap` |
| Better recurring approach is found | Log to `.learnings/LEARNINGS.md` with category `best_practice` |
| Similar entry already exists | Link with `See Also`, then consider increasing priority |
| Learning is broadly applicable | Promote to an appropriate agent guidance file |

## Detection Triggers

Log a learning when the user says or implies:

- "No, that's not right..."
- "Actually, it should be..."
- "You're wrong about..."
- "That's outdated..."

Log a feature request when the user asks for a capability the agent or toolchain does not currently have.

Log a knowledge gap when documentation, behavior, or user-provided information contradicts what the agent expected.

Log an error when a command returns a non-zero exit code, an exception appears, a tool times out, or output is unexpectedly unusable.

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

Append to `.learnings/ERRORS.md`:

````markdown
## [ERR-YYYYMMDD-XXX] skill_or_command_name

**Logged**: ISO-8601 timestamp
**Priority**: high
**Status**: pending
**Area**: frontend | backend | infra | tests | docs | config

### Summary
Brief description of what failed

### Error
```text
Actual error message or redacted output excerpt
```

### Context
- Command/operation attempted
- Input or parameters used
- Environment details if relevant
- Summary or redacted excerpt of relevant output

### Suggested Fix
If identifiable, what might resolve this

### Metadata
- Reproducible: yes | no | unknown
- Related Files: path/to/file.ext
- See Also: ERR-20250110-001 (if recurring)

---
````

## Feature Request Entry Format

Append to `.learnings/FEATURE_REQUESTS.md`:

```markdown
## [FEAT-YYYYMMDD-XXX] capability_name

**Logged**: ISO-8601 timestamp
**Priority**: medium
**Status**: pending
**Area**: frontend | backend | infra | tests | docs | config

### Requested Capability
What the user wanted to do

### User Context
Why they needed it, what problem they're solving

### Complexity Estimate
simple | medium | complex

### Suggested Implementation
How this could be built, what it might extend

### Metadata
- Frequency: first_time | recurring
- Related Features: existing_feature_name

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

1. Change `**Status**: pending` to `**Status**: resolved`.
2. Add a resolution block after metadata.

```markdown
### Resolution
- **Resolved**: 2025-01-16T09:00:00Z
- **Commit/PR**: abc123 or #42
- **Notes**: Brief description of what was done
```

Other status values:

- `in_progress` - Actively being worked on
- `wont_fix` - Decided not to address; include a reason in resolution notes
- `promoted` - Elevated to durable agent guidance
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

Promotion workflow:

1. Distill the learning into a concise rule or fact.
2. Add it to the appropriate target file.
3. Update the original learning status to `promoted`.
4. Record the target path in the original entry.

## Recurring Pattern Detection

Before logging a similar issue, search `.learnings/` for a relevant keyword or `Pattern-Key`.

If a related entry exists:

1. Add a `See Also` reference.
2. Increment `Recurrence-Count` when present.
3. Update `Last-Seen`.
4. Consider increasing priority.
5. Consider promotion when the pattern repeats across tasks.

Promote recurring patterns when all are true:

- `Recurrence-Count >= 3`
- Seen across at least two distinct tasks
- Occurred within a 30-day window

Write promoted rules as short prevention rules, not incident reports.

## Periodic Review

Review `.learnings/` before major tasks, after completing substantial features, when working near prior mistakes, and during regular maintenance.

During review:

- Resolve fixed items.
- Promote applicable learnings.
- Link related entries.
- Escalate recurring issues.

## Skill Extraction

A learning can become a reusable skill when it is recurring, verified, non-obvious, broadly applicable, or explicitly requested by the user.

Extraction workflow:

1. Identify a qualifying learning.
2. Run `scripts/extract-skill.sh skill-name --dry-run` if available.
3. Create or customize the extracted `SKILL.md`.
4. Update the learning status to `promoted_to_skill` and add `Skill-Path`.
5. Verify the new skill is self-contained in a fresh session.

Quality gates before extraction:

- Solution is tested or otherwise verified.
- Description is clear without the original conversation.
- Code examples are self-contained.
- No project-specific hardcoded values leak into a general skill.
- Skill name follows lowercase hyphenated naming conventions.
