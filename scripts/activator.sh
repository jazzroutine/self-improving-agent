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
For feature requests: search first, use user_formed for user requests and agent_formed for agent-spotted opportunities, include observed friction/benefit/approval needed, notify the user when user_formed/agent_formed/accepted/updated/rejected/resolved, and remind later only for user_formed/agent_formed/accepted/in_progress related requests.
For agent-spotted skill ideas: create/update FEATURE_REQUESTS.md first; only extract a skill from assets/SKILL-TEMPLATE.md after user acceptance.
</self-improvement-reminder>
EOF
