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
- Missing capability, reusable limitation, or repeated manual workaround?

If yes: Log/update .learnings/ using the self-improvement skill format.
For feature requests: search first, form actionable requests, notify the user when formed/updated/resolved, and remind later only for formed/accepted/in_progress related requests.
If high-value (recurring, broadly applicable): Consider skill extraction.
</self-improvement-reminder>
EOF
