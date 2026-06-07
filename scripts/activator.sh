#!/bin/bash
# Self-Improvement Activator Hook
# Triggers on UserPromptSubmit to remind Claude about learning capture
# Keep output minimal (~50-100 tokens) to minimize overhead

set -e

# Output reminder as system context
cat << 'EOF'
<self-improvement-reminder>
After completing this task, evaluate if extractable knowledge emerged:
- Non-obvious solution discovered through investigation?
- Workaround for unexpected behavior?
- Project-specific pattern learned?
- Error required debugging to resolve?
- Missing capability, reusable limitation, repeated manual workaround, or agent-spotted skill opportunity?

If yes: Log/update .learnings/ using the self-improvement skill format.
For feature requests: search first, use user_formed for user requests and agent_formed for agent-spotted opportunities, include need, friction, expected behavior, trigger conditions, implementation direction, and approval state; notify only when a change affects action; remind later only for related user_formed/agent_formed/in_progress requests.
For agent-spotted skill ideas: create/update FEATURE_REQUESTS.md first; only extract a skill from assets/SKILL-TEMPLATE.md after user approval.
</self-improvement-reminder>
EOF
