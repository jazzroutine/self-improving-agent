# self-improving-agent

My version of the self-improvement skill for OpenClaw and other coding agents. It helps agents capture corrections, command failures, missing capabilities, and reusable lessons in `.learnings/` files so future sessions can improve instead of rediscovering the same problems. Invested quite some time in it to make it actually useful.

## What This Repo Contains

- `SKILL.md` - agent-facing instructions loaded by compatible agent runtimes
- `assets/` - starter templates for learning, error, feature request, and extracted skill files, including the canonical `SKILL-TEMPLATE.md` used for skill extraction
- `hooks/openclaw/` - optional OpenClaw hook implementation
- `scripts/activator.sh` - reminder hook script
- `scripts/error-detector.sh` - optional command-error detection hook script
- `scripts/extract-skill.sh` - helper for turning proven learnings into reusable skills from the canonical template variants
- `references/` - extended setup notes and examples

## Attribution

Remade for OpenClaw from the original self-improvement skill work:

- https://github.com/pskoett/pskoett-ai-skills
- https://github.com/pskoett/pskoett-ai-skills/tree/main/skills/self-improvement

## OpenClaw Installation

Install through ClawdHub when available:

```bash
clawdhub install self-improving-agent
```

Or install manually:

```bash
git clone https://github.com/peterskoett/self-improving-agent.git ~/.openclaw/skills/self-improving-agent
```

After installation, restart or reload your OpenClaw agent session so the skill registry can discover `SKILL.md`.

## OpenClaw Workspace Setup

OpenClaw commonly injects workspace files like these into sessions:

```text
~/.openclaw/workspace/
├── AGENTS.md
├── SOUL.md
├── TOOLS.md
├── MEMORY.md
├── memory/
│   └── YYYY-MM-DD.md
└── .learnings/
    ├── LEARNINGS.md
    ├── ERRORS.md
    └── FEATURE_REQUESTS.md
```

Create the learning directory if it does not exist:

```bash
mkdir -p ~/.openclaw/workspace/.learnings
```

Then create only the missing log files, or copy the starter files from `assets/` after checking whether local files already exist:

```bash
test -f ~/.openclaw/workspace/.learnings/LEARNINGS.md || cp assets/LEARNINGS.md ~/.openclaw/workspace/.learnings/LEARNINGS.md
test -f ~/.openclaw/workspace/.learnings/ERRORS.md || cp assets/ERRORS.md ~/.openclaw/workspace/.learnings/ERRORS.md
test -f ~/.openclaw/workspace/.learnings/FEATURE_REQUESTS.md || cp assets/FEATURE_REQUESTS.md ~/.openclaw/workspace/.learnings/FEATURE_REQUESTS.md
```

Never overwrite existing `.learnings/` files without reviewing and preserving their entries.

## Optional OpenClaw Hook Activation

The hook is optional. Enable it when you want OpenClaw to remind agents to evaluate whether a task produced a learning.

Copy the hook into OpenClaw's hooks directory:

```bash
cp -r hooks/openclaw ~/.openclaw/hooks/self-improvement
```

Enable it:

```bash
openclaw hooks enable self-improvement
```

See `references/openclaw-integration.md` for complete OpenClaw-specific notes.

## Generic Agent Setup

For Claude Code, Codex, Copilot, or another agent environment, create `.learnings/` in the project or workspace root:

```bash
mkdir -p .learnings
test -f .learnings/LEARNINGS.md || cp assets/LEARNINGS.md .learnings/LEARNINGS.md
test -f .learnings/ERRORS.md || cp assets/ERRORS.md .learnings/ERRORS.md
test -f .learnings/FEATURE_REQUESTS.md || cp assets/FEATURE_REQUESTS.md .learnings/FEATURE_REQUESTS.md
```

Add a short reminder to the relevant agent instruction file, such as `AGENTS.md`, `CLAUDE.md`, or `.github/copilot-instructions.md`:

```markdown
## Self-Improvement

After corrections, command failures, missing capability requests, or useful recurring discoveries, check `.learnings/` for existing matching entries before writing. Capture concise, redacted entries first; for feature requests, form the user need and reminder rule, tell the user when a request becomes actionable, and remind them when related tasks appear. Promote only proven recurring guidance to the appropriate durable instruction file or reusable skill.
```

## Claude Code / Codex Hook Example

Hook support depends on the local agent runtime. If your runtime supports command hooks, an activator-only setup can remind agents after each prompt.

Example `.claude/settings.json` or `.codex/settings.json` pattern:

```json
{
  "hooks": {
    "UserPromptSubmit": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "./skills/self-improvement/scripts/activator.sh"
      }]
    }]
  }
}
```

For command-error detection, add the optional detector only if you are comfortable with hook scripts inspecting command output for error patterns:

```json
{
  "hooks": {
    "UserPromptSubmit": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "./skills/self-improvement/scripts/activator.sh"
      }]
    }],
    "PostToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "./skills/self-improvement/scripts/error-detector.sh"
      }]
    }]
  }
}
```

See `references/hooks-setup.md` for detailed hook configuration and troubleshooting.

## Core Workflow

The skill logic is capture-first, then dedupe, then promote only when the evidence justifies it. `.learnings/` should stay useful as a compact working index, not become a transcript archive.

1. Capture corrections, knowledge gaps, better approaches, missing capabilities, and command/tool/API failures in the appropriate `.learnings/` file.
2. Before adding a new entry, search existing learnings, feature requests, and especially error entries for matching headings, exact error text, command names, affected integrations, likely root causes, `Pattern-Key`, and active rules.
3. If the same error pattern already exists, update the canonical entry instead of adding a duplicate. Update recurrence fields, representative errors, context examples, lesson, suggested fix, and avoidance rule as needed.
4. For feature requests, update an existing matching request when possible; otherwise create a request only when the missing capability is explicit, reusable, or tied to a repeated workaround.
5. Keep entries short, redacted, actionable, and free of secrets, tokens, raw transcripts, environment variables, and unnecessary command output.
6. Add `See Also` links when entries are related but have different root causes.
7. Promote broadly applicable or repeated patterns into durable agent guidance only after they are proven enough to help future agents.

## Entry Types

Use `SKILL.md` as the source of truth for exact formats. In summary:

| File | Use For | Key Rule |
|------|---------|----------|
| `.learnings/LEARNINGS.md` | Corrections, knowledge gaps, insights, and recurring best practices | Search for near-duplicates before adding. |
| `.learnings/ERRORS.md` | Command, tool, API, integration, and operation failures | Dedupe first; maintain one canonical entry per recurring root cause. |
| `.learnings/FEATURE_REQUESTS.md` | Missing capabilities, reusable limitations, and repeated workaround automation ideas | Treat requests as a user-involved loop: form the need, notify when actionable, and remind when related work appears. |

Error entries should use the current canonical shape: `Representative Errors`, `Context Examples`, `Lesson`, `Suggested Fix`, `Avoidance Rule`, and recurrence metadata such as `Pattern-Key`, `First-Seen`, `Last-Seen`, and `Recurrence-Count`.

## Feature Request Loop

Feature requests are useful only when they are actionable and visible. Use `.learnings/FEATURE_REQUESTS.md` for capability gaps that should be revisited, not for ordinary bugs, vague preferences, or work already being done.

Create or update a request when the user asks for a missing capability, the agent hits a reusable limitation that weakens the task, or a repeated manual workaround shows automation would help. Search existing requests first by capability, affected tool, problem area, trigger condition, and related error or learning ID.

A formed feature request should include:

- requested capability
- user need
- trigger conditions
- expected behavior
- current workaround
- suggested implementation
- user communication
- reminder rule

When a request reaches `formed`, `accepted`, is materially updated, or is resolved, the agent should tell the user immediately. Later, if a task, problem, error, or workaround matches a formed request's trigger conditions, the agent should briefly remind the user by ID and explain why it is relevant.

Use these statuses for feature requests: `draft`, `formed`, `accepted`, `in_progress`, `resolved`, `declined`, and `superseded`. Only `formed`, `accepted`, and `in_progress` requests should trigger proactive reminders.

## Promotion and Skill Extraction

Keep one-off corrections, narrow incidents, and unverified ideas in `.learnings/`. Promote only when a lesson prevents repeated mistakes, documents a durable convention, or belongs in guidance future agents already read.

Common promotion targets include `AGENTS.md`, `TOOLS.md`, `CLAUDE.md`, `.github/copilot-instructions.md`, `SOUL.md`, or another engine-specific instruction file. Choose the target by behavior: agent workflow belongs in agent guidance, local tool gotchas belong in tool guidance, behavioral rules belong in behavior guidance, and project conventions belong in the instruction file that the local engine actually loads.

For reusable triggered procedures, extract a skill from `assets/SKILL-TEMPLATE.md` with:

```bash
scripts/extract-skill.sh skill-name --dry-run
scripts/extract-skill.sh skill-name --template main
scripts/extract-skill.sh skill-name --template minimal
scripts/extract-skill.sh skill-name --template scripts
```

Before extraction, search existing skills for duplicate triggers or use cases. After extraction, update the source learning to `promoted_to_skill` and record `Skill-Path`.

## Gitignore Choices

For personal local logs, ignore `.learnings/`:

```gitignore
.learnings/
```

For team-shared learning history, commit the `.learnings/*.md` files instead.

For a hybrid approach, keep templates while ignoring local entries:

```gitignore
.learnings/*.md
!.learnings/.gitkeep
```

## Usage Notes

Once active, agents should use `SKILL.md` as the source of truth for:

- when to log a learning, error, or feature request
- what format each entry should use
- how to resolve and promote entries
- when to extract a recurring lesson into a reusable skill

Humans should use this `README.md` for installation, activation, and repository orientation.
