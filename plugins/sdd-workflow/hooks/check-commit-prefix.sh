#!/bin/bash
# check-commit-prefix.sh
# PostToolUse hook script (after Bash tool execution)
# Checks commit message conventions
#
# Prerequisites: SessionStart hook sets the following environment variables
#   - SDD_DOCS_ROOT: Documentation root (default: .sdd)

# Get executed command from environment variable
if command -v jq &> /dev/null; then
    COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // empty' 2>/dev/null)
else
    COMMAND=$(echo "$TOOL_INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
fi

# Exit if not a git commit command
if [[ ! "$COMMAND" == *"git commit"* ]]; then
    exit 0
fi

# Get settings from environment variables (set by SessionStart), use defaults if not set
DOCS_ROOT="${SDD_DOCS_ROOT:-.sdd}"

# Get latest commit message
COMMIT_MSG=$(git log -1 --format="%s" 2>/dev/null)

if [ -z "$COMMIT_MSG" ]; then
    exit 0
fi

# Get changed files
CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r HEAD 2>/dev/null)

# Check if documentation files are included
HAS_DOCS_FILES=false
HAS_SPEC_FILES=false
HAS_DESIGN_FILES=false

for file in $CHANGED_FILES; do
    if [[ "$file" == "${DOCS_ROOT}/"* ]] || [[ "$file" == *"_spec.md" ]] || [[ "$file" == *"_design.md" ]]; then
        HAS_DOCS_FILES=true
    fi
    if [[ "$file" == *"_spec.md" ]]; then
        HAS_SPEC_FILES=true
    fi
    if [[ "$file" == *"_design.md" ]]; then
        HAS_DESIGN_FILES=true
    fi
done

# Only check if documentation files were changed
if [ "$HAS_DOCS_FILES" = true ]; then
    # Check for prefix
    if [[ ! "$COMMIT_MSG" =~ ^\[(docs|spec|design)\] ]]; then
        echo "[AI-SDD Warning] Commit message for documentation changes is missing a prefix." >&2
        echo "" >&2
        echo "Recommended prefixes:" >&2
        echo "  [docs]   - Add/update documentation" >&2
        echo "  [spec]   - Add/update specifications (*_spec.md)" >&2
        echo "  [design] - Add/update design documents (*_design.md)" >&2
        echo "" >&2

        # Suggest more appropriate prefix
        if [ "$HAS_SPEC_FILES" = true ] && [ "$HAS_DESIGN_FILES" = false ]; then
            echo "This commit includes *_spec.md files." >&2
            echo "Recommended: [spec] ${COMMIT_MSG}" >&2
        elif [ "$HAS_DESIGN_FILES" = true ] && [ "$HAS_SPEC_FILES" = false ]; then
            echo "This commit includes *_design.md files." >&2
            echo "Recommended: [design] ${COMMIT_MSG}" >&2
        else
            echo "Recommended: [docs] ${COMMIT_MSG}" >&2
        fi

        exit 0
    fi

    # Check prefix-file consistency
    if [[ "$COMMIT_MSG" =~ ^\[spec\] ]] && [ "$HAS_SPEC_FILES" = false ]; then
        echo "[AI-SDD Warning] [spec] prefix used but no *_spec.md files included." >&2
    fi

    if [[ "$COMMIT_MSG" =~ ^\[design\] ]] && [ "$HAS_DESIGN_FILES" = false ]; then
        echo "[AI-SDD Warning] [design] prefix used but no *_design.md files included." >&2
    fi
fi

# Exit normally
exit 0
