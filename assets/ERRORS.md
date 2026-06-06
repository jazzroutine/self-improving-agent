# Errors Log

Command failures, exceptions, and unexpected behaviors. Keep this file as a compact error index, not a transcript.

## Active Rules From Past Errors

Add short prevention rules here after an error pattern repeats or is promoted. Keep each rule actionable and point to the canonical `ERR-*` entry when useful.

---

## Canonical Error Entries

Before adding a new entry, search this file by command/tool name, exact error text, root cause, affected path or integration, and `Pattern-Key`. If the same pattern already exists, update that entry instead of creating a duplicate.

````markdown
## [ERR-YYYYMMDD-XXX] skill_or_command_name

### Summary
Brief description of what failed.

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
