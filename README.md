# self-improving-agent

My version of the self-improvement skill for OpenClaw and other coding agents. It helps agents capture corrections, command failures, missing capabilities, and reusable lessons in `.learnings/` files so future sessions can improve instead of rediscovering the same problems. Invested quite some time in it to make it actually useful.

With many thanks to the adaptation creator: https://github.com/peterskoett/self-improving-agent

## What This Repo Contains

- `SKILL.md` - agent-facing instructions loaded by compatible agent runtimes
- `assets/` - starter templates for learning, error, feature request, and extracted skill files, including the canonical `SKILL-TEMPLATE.md` used for skill creation and extraction
- `hooks/openclaw/` - optional OpenClaw hook implementation
- `scripts/activator.sh` - reminder hook script
- `scripts/error-detector.sh` - optional command-error detection hook script
- `scripts/extract-skill.sh` - helper for turning approved feature requests or proven learnings into reusable skills from the canonical template variants
- `references/` - extended setup notes and examples

## Attribution

Remade for OpenClaw from the original self-improvement skill work:

- https://github.com/pskoett/pskoett-ai-skills
- https://github.com/pskoett/pskoett-ai-skills/tree/main/skills/self-improvement


## Installation

Manual installation:

```bash
git clone https://github.com/jazzroutine/self-improving-agent.git ~/.openclaw/skills/self-improving-agent
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

After corrections, reusable or recurring command failures, missing capability requests, or useful recurring discoveries, search the relevant `.learnings/` file with 3-5 strong identifiers before writing. Capture concise, redacted entries first; for feature requests, form the user need, observed friction, expected behavior, trigger conditions, approval need, implementation direction, and reminder rule. Use `user_formed` for user-requested capabilities and `agent_formed` for agent-spotted opportunities. Treat `.learnings/FEATURE_REQUESTS.md` as the moderation gate before creating agent-proposed skills or automations.
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

This skill gives agents a small memory system for improving their future work. It records useful experience in `.learnings/` files, avoids duplicate notes, and can create a dedicated skill when an issue becomes useful beyond a single incident.

1. When a user corrects the agent, a command fails, a capability is missing, or a useful recurring pattern appears, the agent checks whether the event is worth recording.
2. The agent searches the relevant `.learnings/` file with 3-5 strong identifiers before writing, so repeated issues update the same entry instead of creating scattered duplicates.
3. Corrections, knowledge gaps, and reusable working habits go in `.learnings/LEARNINGS.md`.
4. Command, tool, API, and integration failures go in `.learnings/ERRORS.md` only when reusable, repeated, surprising, high-impact, or likely to recur and not already covered; group them by root cause when possible.
5. Missing capabilities, repeated workaround ideas, and agent-spotted automation or skill opportunities go in `.learnings/FEATURE_REQUESTS.md`.
6. If a recurring error needs a reusable capability, the agent creates or updates a feature request and keeps the full error entry active until that request is complete enough to take over tracking.
7. Entries stay short and useful: what happened, what to do differently, and any safe context needed later. They should not include secrets, raw transcripts, tokens, environment variables, or long command output.
8. When an entry is fixed, promoted, superseded, stale, or handed off, the agent compacts it to a one-line tombstone instead of preserving a bulky history log.
9. If the same issue becomes a general rule, the agent can copy that rule into the instruction file future agents actually load, such as `AGENTS.md`, `TOOLS.md`, `SOUL.md` for OpenClaw, or a new issue-specific skill. The `.learnings/` entry then stays active only while useful, or shrinks to a tombstone that keeps the promoted target traceable.

## Entry Types

`SKILL.md` is the source of the main logic. In summary:

| File | Use For | Key Rule |
|------|---------|----------|
| `.learnings/LEARNINGS.md` | Corrections, knowledge gaps, insights, and recurring best practices | Search for near-duplicates before adding; promote or supersede active lessons into tombstones when the durable rule lives elsewhere. |
| `.learnings/ERRORS.md` | Reusable, repeated, surprising, high-impact, or likely-recurring command/tool/API/integration failures | Maintain one entry per root cause; escalate repeated patterns; tombstone fixed, promoted, stale, superseded, or feature-handed-off errors. |
| `.learnings/FEATURE_REQUESTS.md` | Missing capabilities, reusable limitations, repeated workaround automation ideas, and agent-spotted skill opportunities | Act as the moderation gate before new skills or automations; search active entries and tombstones before proposing duplicate capability work. |

Error entries use the shape: `Representative Errors`, `Context Examples`, `Lesson`, `Issue`, `Suggested Fix`, `Avoidance Rule`, and recurrence metadata such as `Pattern-Key`, `First-Seen`, `Last-Seen`, and `Recurrence-Count`.

## Retention and Handoff Logic

The `.learnings/` files are working memory, not permanent archives. Full entries stay only while they help future agents decide what to do. Once the useful rule or capability is captured elsewhere, the original entry should shrink to a one-line tombstone with the target, date, and reason.

Use this flow for recurring errors that need tooling, automation, or a new skill:

1. Keep one canonical `ERR-*` entry for the recurring root cause.
2. Create or update one matching `FEAT-*` entry instead of proposing a fresh capability each time.
3. Make the feature request actionable by filling `Need`, `Expected Behavior`, `Trigger Conditions`, `Implementation Direction`, `Status`, and `Related Errors`.
4. Only then compact the source error to `moved_to_feature`, pointing at the `FEAT-*` ID.

Feature-request tombstones matter for duplicate prevention. If a request was resolved by an existing skill, tool, script, workflow, commit, or guidance file, the tombstone note must name that target clearly enough that a later agent can find it before proposing or creating the same capability again.

## Skill-Creation and Promotion Logic

The skill separates small local notes from durable guidance. `.learnings/` keeps the source record: corrections, errors, feature requests, and short lessons. When a lesson becomes generally useful, the agent can move the distilled rule into the instruction file future agents already load, such as `AGENTS.md`, `TOOLS.md`, `CLAUDE.md`, `.github/copilot-instructions.md`, `SOUL.md`, or another engine-specific guidance file.

Use the target that matches the behavior: agent workflow belongs in agent guidance, local command and integration gotchas belong in tool guidance, communication rules belong in behavior guidance, and project conventions belong in the project instruction file. The `.learnings/` entry remains active only while useful; after promotion or supersession, it should shrink to a tombstone that records the promoted target.

New reusable skills follow the feature-request loop. The agent uses `.learnings/FEATURE_REQUESTS.md` when a missing capability, recurring limitation, repeated workaround, or concrete agent-spotted opportunity deserves future attention. Before adding a request, it searches active requests and tombstones by capability, affected tool, problem area, trigger condition, related error or learning ID, and prior implementation target, then updates a matching request instead of creating a duplicate.

Feature requests use these statuses:

- `draft` - needs more context before it is actionable.
- `user_formed` - user clearly requested the capability and the request is ready.
- `agent_formed` - agent noticed a useful opportunity and formed a request that is ready for user review.
- `in_progress` - approved work is actively being implemented.
- `resolved` - implemented or otherwise satisfied; record guidance targets, skill paths, files, commits, or PRs in the resolution notes.
- `rejected` - intentionally not planned; include the reason.
- `superseded` - replaced by another request; link the replacement.

A ready request includes the capability name, need, friction, expected behavior, trigger conditions, current workaround, implementation direction, approval state, user communication, reminder rule, and related errors or learnings when applicable.

`agent_formed` is the moderation state for agent-spotted ideas. It means the agent has made the opportunity clear enough for user review: what friction was observed, what capability is proposed, why it would help, and what approval is needed. The agent tells the user only when a feature-request change affects action: status becomes `user_formed`, `agent_formed`, `in_progress`, `resolved`, or `rejected`, or scope, trigger conditions, approval need, implementation target, or resolution changes. It can also remind when a later task matches an active request's reminder rule.

The agent will not create a new skill from an agent-spotted opportunity until the user approves the matching feature request. After user approval, the request moves directly to `in_progress` status while the implementation is underway. If a reusable skill is the right implementation path, the agent previews and extracts it with `scripts/extract-skill.sh` from `assets/SKILL-TEMPLATE.md`:

```bash
scripts/extract-skill.sh skill-name --dry-run
scripts/extract-skill.sh skill-name --template main
scripts/extract-skill.sh skill-name --template minimal
scripts/extract-skill.sh skill-name --template scripts
```

Before extraction, the agent searches existing skills, active feature requests, and feature-request tombstones for duplicate triggers or use cases. When the capability ships, it marks the source request `resolved` and records the `Skill-Path`, changed files, commit, or PR so future agents can find the existing solution.

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

Use this `README.md` for installation, activation, and repository orientation.
