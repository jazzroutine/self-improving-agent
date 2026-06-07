# Learnings

Active durable corrections, insights, knowledge gaps, and reusable practices. Keep this file small; it is working memory, not history.

## Rules

- Search before writing by title, lesson, source, files, tags, `Pattern-Key`, and related IDs.
- Update same lessons; merge overlap; link only useful related lessons with `See Also`.
- Keep full entries only while they actively change future behavior.
- After promotion or supersession, replace the full entry with a one-line tombstone.

Categories: `correction`, `insight`, `knowledge_gap`, `best_practice`.

## Active Entry

```markdown
## [LRN-YYYYMMDD-XXX] category: short_title

**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical

### Lesson
Reusable rule/fact.

### Action
Future behavior.

### Metadata
- Source: user_correction | agent_discovery | repeated_pattern | review
- Pattern-Key:
- Related Files:
- See Also:
```

## Tombstone

Use only after promotion or supersession. Replace the full entry with one line:

```markdown
## [LRN-YYYYMMDD-XXX] short_title - promoted|superseded: target, YYYY-MM-DD. Note: reason.
```

Examples of `target`: `AGENTS.md`, `TOOLS.md`, `SOUL.md`, `skills/name/SKILL.md`, `LRN-YYYYMMDD-XXX`, `deleted`.
Examples of `reason`: `moved after review`, `user asked`, `no longer valid`, `duplicate merged`.

---
