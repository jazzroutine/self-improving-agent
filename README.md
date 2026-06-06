# self-improving-agent

Self-improvement skill for OpenClaw and other coding agents. It helps agents capture corrections, command failures, missing capabilities, and reusable lessons in `.learnings/` files so future sessions can improve instead of rediscovering the same problems.

## What This Repo Contains

- `SKILL.md` - agent-facing instructions loaded by compatible agent runtimes
- `assets/` - starter templates for learning, error, feature request, and extracted skill files
- `hooks/openclaw/` - optional OpenClaw hook implementation
- `scripts/activator.sh` - reminder hook script
- `scripts/error-detector.sh` - optional command-error detection hook script
- `scripts/extract-skill.sh` - helper for turning proven learnings into reusable skills
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

Then create the three log files, or copy the starter files from `assets/`:

```bash
cp assets/LEARNINGS.md ~/.openclaw/workspace/.learnings/LEARNINGS.md
cp assets/ERRORS.md ~/.openclaw/workspace/.learnings/ERRORS.md
cp assets/FEATURE_REQUESTS.md ~/.openclaw/workspace/.learnings/FEATURE_REQUESTS.md
```

If those files already exist, review before overwriting them.

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
cp assets/LEARNINGS.md .learnings/LEARNINGS.md
cp assets/ERRORS.md .learnings/ERRORS.md
cp assets/FEATURE_REQUESTS.md .learnings/FEATURE_REQUESTS.md
```

Add a short reminder to the relevant agent instruction file, such as `AGENTS.md`, `CLAUDE.md`, or `.github/copilot-instructions.md`:

```markdown
## Self-Improvement

After corrections, command failures, missing capability requests, or useful recurring discoveries, consider logging a concise entry to `.learnings/` using the self-improvement skill format. Promote broadly useful lessons into durable project guidance.
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
