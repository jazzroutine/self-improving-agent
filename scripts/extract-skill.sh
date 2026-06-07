#!/bin/bash
# Skill Extraction Helper
# Creates a new skill from a learning entry
# Usage: ./extract-skill.sh <skill-name> [--dry-run] [--template main|minimal|scripts]

set -e

# Configuration
SKILLS_DIR="./skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_PATH="$REPO_ROOT/assets/SKILL-TEMPLATE.md"

# Colors for interactive output
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    NC=''
fi

usage() {
    cat << USAGE
Usage: $(basename "$0") <skill-name> [options]

Create a new skill from a learning entry.

Arguments:
  skill-name     Name of the skill (lowercase, hyphens for spaces)

Options:
  --dry-run      Show what would be created without creating files
  --output-dir   Relative output directory under current path (default: ./skills)
  --template     Template variant from assets/SKILL-TEMPLATE.md: main, minimal, scripts (default: main)
  -h, --help     Show this help message

Examples:
  $(basename "$0") docker-m1-fixes
  $(basename "$0") api-timeout-patterns --dry-run
  $(basename "$0") pnpm-setup --output-dir ./skills/custom
  $(basename "$0") api-helper --template scripts

The skill will be created in: \$SKILLS_DIR/<skill-name>/
USAGE
}

log_info() {
    printf "%b\n" "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    printf "%b\n" "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    printf "%b\n" "${RED}[ERROR]${NC} $1" >&2
}

# Parse arguments
SKILL_NAME=""
DRY_RUN=false
TEMPLATE_KIND="main"

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --output-dir)
            if [ -z "${2:-}" ] || [[ "${2:-}" == -* ]]; then
                log_error "--output-dir requires a relative path argument"
                usage
                exit 1
            fi
            SKILLS_DIR="$2"
            shift 2
            ;;
        --template)
            if [ -z "${2:-}" ] || [[ "${2:-}" == -* ]]; then
                log_error "--template requires one of: main, minimal, scripts"
                usage
                exit 1
            fi
            TEMPLATE_KIND="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            if [ -z "$SKILL_NAME" ]; then
                SKILL_NAME="$1"
            else
                log_error "Unexpected argument: $1"
                usage
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate skill name
if [ -z "$SKILL_NAME" ]; then
    log_error "Skill name is required"
    usage
    exit 1
fi

# Validate skill name format (lowercase, hyphens, no spaces)
if ! [[ "$SKILL_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    log_error "Invalid skill name format. Use lowercase letters, numbers, and hyphens only."
    log_error "Examples: 'docker-fixes', 'api-patterns', 'pnpm-setup'"
    exit 1
fi

# Validate template choice.
case "$TEMPLATE_KIND" in
    main|minimal|scripts)
        ;;
    *)
        log_error "Invalid template: $TEMPLATE_KIND"
        log_error "Use one of: main, minimal, scripts"
        exit 1
        ;;
esac

# Validate output path to avoid writes outside current workspace.
if [[ "$SKILLS_DIR" = /* ]]; then
    log_error "Output directory must be a relative path under the current directory."
    exit 1
fi

if [[ "$SKILLS_DIR" =~ (^|/)\.\.(/|$) ]]; then
    log_error "Output directory cannot include '..' path segments."
    exit 1
fi

SKILLS_DIR="${SKILLS_DIR#./}"
SKILLS_DIR="./$SKILLS_DIR"

SKILL_PATH="$SKILLS_DIR/$SKILL_NAME"
SKILL_TITLE="$(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')"

if [ ! -f "$TEMPLATE_PATH" ]; then
    log_error "Canonical skill template not found: $TEMPLATE_PATH"
    exit 1
fi

template_heading() {
    case "$TEMPLATE_KIND" in
        main) echo "SKILL.md Template" ;;
        minimal) echo "Minimal Template" ;;
        scripts) echo "Template with Scripts" ;;
    esac
}

render_template() {
    local heading
    heading="$(template_heading)"

    awk -v heading="$heading" '
        { sub(/\r$/, "") }
        $0 == "## " heading { in_section = 1; next }
        in_section && /^```markdown$/ { in_block = 1; next }
        in_block && /^```$/ { exit }
        in_block { print }
    ' "$TEMPLATE_PATH" | sed \
        -e "s/^name: skill-name-here$/name: $SKILL_NAME/" \
        -e "s/^# Skill Name$/# $SKILL_TITLE/" \
        -e "s/skill-name\/scripts\//${SKILL_NAME}\/scripts\//g" \
        -e 's/\\`/`/g'
}

TEMPLATE_PREVIEW="$(render_template)"
if [ -z "$TEMPLATE_PREVIEW" ]; then
    log_error "Canonical template block '$TEMPLATE_KIND' not found or empty: $TEMPLATE_PATH"
    exit 1
fi

# Check if skill already exists
if [ -d "$SKILL_PATH" ] && [ "$DRY_RUN" = false ]; then
    log_error "Skill already exists: $SKILL_PATH"
    log_error "Use a different name or remove the existing skill first."
    exit 1
fi

# Dry run output
if [ "$DRY_RUN" = true ]; then
    log_info "Dry run - would create:"
    echo "  $SKILL_PATH/"
    echo "  $SKILL_PATH/SKILL.md"
    echo ""
    echo "Canonical template: $TEMPLATE_PATH"
    echo "Template variant: $TEMPLATE_KIND"
    echo ""
    echo "Rendered SKILL.md would be:"
    printf "%s\n" "$TEMPLATE_PREVIEW"

    if [ -d "$SKILL_PATH" ]; then
        log_warn "Skill directory already exists: $SKILL_PATH"
    fi

    exit 0
fi

# Create skill directory structure
log_info "Creating skill: $SKILL_NAME"

mkdir -p "$SKILL_PATH"
if [ "$TEMPLATE_KIND" = "scripts" ]; then
    mkdir -p "$SKILL_PATH/scripts"
fi

# Create SKILL.md from the canonical template.
printf "%s\n" "$TEMPLATE_PREVIEW" > "$SKILL_PATH/SKILL.md"

log_info "Created: $SKILL_PATH/SKILL.md"

# Suggest next steps
echo ""
log_info "Skill scaffold created successfully!"
echo ""
echo "Next steps:"
echo "  1. Edit $SKILL_PATH/SKILL.md"
echo "  2. Fill in the template sections with content from your learning"
echo "  3. Search existing skills for duplicate triggers or use cases"
echo "  4. Add references/ folder if you have detailed documentation"
echo "  5. Add scripts/ folder if you have executable code"
echo "  6. Update the original learning entry with:"
echo "     **Status**: promoted"
echo "     **Skill-Path**: skills/$SKILL_NAME"
