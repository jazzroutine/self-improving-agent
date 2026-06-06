# OpenClaw Integration

Complete setup and usage guide for integrating the self-improvement skill with OpenClaw.

## Overview

OpenClaw uses workspace-based prompt injection combined with event-driven hooks. Context is injected from workspace files at session start, and hooks can trigger on lifecycle events.

## Workspace Structure

```
~/.openclaw/                      
├── workspace/                   # Working directory
│   ├── AGENTS.md               # Multi-agent coordination patterns
│   ├── SOUL.md                 # Behavioral guidelines and personality
│   ├── TOOLS.md                # Tool capabilities and gotchas
│   ├── MEMORY.md               # Long-term memory (main session only)
│   └── memory/                 # Daily memory files
│       └── YYYY-MM-DD.md
├── skills/                      # Installed skills
│   └── <skill-name>/
│       └── SKILL.md
└── hooks/                       # Custom hooks
    └── <hook-name>/
        ├── HOOK.md
        └── handler.ts
```

## Quick Setup

### 1. Install the Skill

```bash
clawdhub install self-improving-agent
```

Or copy manually:

```bash
cp -r self-improving-agent ~/.openclaw/skills/
```

### 2. Install the Hook (Optional)

Copy the hook to OpenClaw's hooks directory:

```bash
cp -r hooks/openclaw ~/.openclaw/hooks/self-improvement
```

Enable the hook:

```bash
openclaw hooks enable self-improvement
```

### 3. Create Learning Files

Create the `.learnings/` directory in your workspace:

```bash
mkdir -p ~/.openclaw/workspace/.learnings
```

Or in the skill directory:

```bash
mkdir -p ~/.openclaw/skills/self-improving-agent/.learnings
```

## Injected Prompt Files

### AGENTS.md

Purpose: Multi-agent workflows and delegation patterns.

```markdown
# Agent Coordination

## Delegation Rules
- Use explore agent for open-ended codebase questions
- Spawn sub-agents for long-running tasks
- Use sessions_send for cross-session communication

## Session Handoff
When delegating to another session:
1. Provide full context in the handoff message
2. Include relevant file paths
3. Specify expected output format
```

### SOUL.md

Purpose: Behavioral guidelines and communication style.

```markdown
# Behavioral Guidelines

## Communication Style
- Be direct and concise
- Avoid unnecessary caveats and disclaimers
- Use technical language appropriate to context

## Error Handling
- Admit mistakes promptly
- Provide corrected information immediately
- Log significant errors to learnings
```

### TOOLS.md

Purpose: Tool capabilities, integration gotchas, local configuration.

```markdown
# Tool Knowledge

## Self-Improvement Skill
Log learnings to `.learnings/` for continuous improvement.

## Local Tools
- Document tool-specific gotchas here
- Note authentication requirements
- Track integration quirks
```

## Learning Workflow

### Capture First

1. Log corrections, knowledge gaps, and better approaches to `.learnings/LEARNINGS.md`.
2. Log command, tool, API, and operation failures to `.learnings/ERRORS.md`.
3. Log missing capability requests to `.learnings/FEATURE_REQUESTS.md`.
4. Before adding an error entry, search existing entries by exact error text, tool or command name, affected integration, likely root cause, and `Pattern-Key`. Update the canonical entry when the pattern already exists.
5. Keep entries short, redacted, actionable, and free of secrets, tokens, raw transcripts, and unnecessary command output.

### Promotion Decision Tree

```text
Start with the captured `.learnings/` entry.

Is this a one-off or unverified observation?
├── Yes -> Keep it in `.learnings/` until there is more evidence.
└── No -> Has the pattern repeated enough to become durable guidance?
    ├── No -> Keep tracking recurrence fields in `.learnings/`.
    └── Yes -> Choose the promotion target.

Promotion target:
├── Behavioral or style rule -> SOUL.md, equivalent behavior file, or engine-specific instruction file
├── Tool, command, integration, or local environment gotcha -> TOOLS.md or equivalent tool guidance
├── Agent workflow, delegation, review, or operating rule -> AGENTS.md or equivalent agent guidance
└── Reusable triggered procedure with steps and verification -> extract a skill from assets/SKILL-TEMPLATE.md
```

Promotion should preserve universality where possible. Use OpenClaw-specific files for OpenClaw-specific behavior, but do not bake OpenClaw names into general skill logic.

### Promotion Format Examples

**From learning:**
> Git push to GitHub fails when authentication is not configured.

**To a durable tool guidance file:**
```markdown
## Git
- Before pushing, verify the intended branch, remote default branch, and authentication state.
- Use the local engine's approved auth check before attempting network Git operations.
```

## Inter-Agent Communication

OpenClaw provides tools for cross-session communication:

Use these only when cross-session sharing is explicitly needed and the environment is trusted. Prefer short sanitized summaries over raw transcripts, command output, or secret-bearing content.

### sessions_list

View active and recent sessions:
```
sessions_list(activeMinutes=30, messageLimit=3)
```

### sessions_history

Read transcript from another session:
```
sessions_history(sessionKey="session-id", limit=50)
```

Only read another session's transcript when the user explicitly wants shared context or continuation across sessions.

### sessions_send

Send message to another session:
```
sessions_send(sessionKey="session-id", message="Learning: API requires X-Custom-Header")
```

Prefer sending a concise learning summary plus relevant paths rather than forwarding raw transcript content.

### sessions_spawn

Spawn a background sub-agent:
```
sessions_spawn(task="Research X and report back", label="research")
```

## Available Hook Events

| Event | When It Fires |
|-------|---------------|
| `agent:bootstrap` | Before workspace files inject |
| `command:new` | When `/new` command issued |
| `command:reset` | When `/reset` command issued |
| `command:stop` | When `/stop` command issued |
| `gateway:startup` | When gateway starts |

## Detection Triggers

### Standard Triggers
- User corrections ("No, that's wrong...")
- Command failures (non-zero exit codes)
- API errors
- Knowledge gaps

### OpenClaw-Specific Triggers

| Trigger | Action |
|---------|--------|
| Tool call error | Log or update `.learnings/ERRORS.md` first; promote repeated tool gotchas to `TOOLS.md` |
| Session handoff confusion | Log or update `.learnings/LEARNINGS.md` first; promote repeated workflow rules to `AGENTS.md` |
| Model behavior surprise | Log or update `.learnings/LEARNINGS.md` first; promote proven behavior rules to `SOUL.md` or equivalent behavior guidance |
| Skill issue | Log to `.learnings/`; if it is a reusable triggered procedure, extract a skill with `assets/SKILL-TEMPLATE.md` or report upstream |

## Verification

Check hook is registered:

```bash
openclaw hooks list
```

Check skill is loaded:

```bash
openclaw status
```

## Troubleshooting

### Hook not firing

1. Ensure hooks enabled in config
2. Restart gateway after config changes
3. Check gateway logs for errors

### Learnings not persisting

1. Verify `.learnings/` directory exists
2. Check file permissions
3. Ensure workspace path is configured correctly

### Skill not loading

1. Check skill is in skills directory
2. Verify SKILL.md has correct frontmatter
3. Run `openclaw status` to see loaded skills
