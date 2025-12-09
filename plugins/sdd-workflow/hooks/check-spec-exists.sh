#!/bin/bash
# check-spec-exists.sh
# PreToolUse hook script
# Checks for specification existence before Edit/Write tool usage
#
# Prerequisites: SessionStart hook sets the following environment variables
#   - SDD_DOCS_ROOT: Documentation root (default: .sdd)
#   - SDD_SPECIFICATION_DIR: Specification directory name (default: specification)
#   - SDD_SPECIFICATION_PATH: Full specification path (default: .sdd/specification)

# Get target file path from environment variable
# Claude Code passes TOOL_INPUT as JSON
if command -v jq &> /dev/null; then
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty' 2>/dev/null)
else
    FILE_PATH=$(echo "$TOOL_INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
fi

# Exit if file path cannot be retrieved
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

# Get settings from environment variables (set by SessionStart), use defaults if not set
DOCS_ROOT="${SDD_DOCS_ROOT:-.sdd}"
SPEC_DIR_NAME="${SDD_SPECIFICATION_DIR:-specification}"

# Exclude files under documentation root
if [[ "$FILE_PATH" == *"${DOCS_ROOT}/"* ]] || [[ "$FILE_PATH" == *"/${DOCS_ROOT}/"* ]]; then
    exit 0
fi

# Exclude configuration files
if [[ "$FILE_PATH" == *".json" ]] || [[ "$FILE_PATH" == *".md" ]] || [[ "$FILE_PATH" == *".yml" ]] || [[ "$FILE_PATH" == *".yaml" ]]; then
    exit 0
fi

# Exclude test files (common test file patterns)
if [[ "$FILE_PATH" == *".test."* ]] || [[ "$FILE_PATH" == *".spec."* ]] || \
   [[ "$FILE_PATH" == *"_test."* ]] || [[ "$FILE_PATH" == *"test_"* ]] || \
   [[ "$FILE_PATH" == *"/test/"* ]] || [[ "$FILE_PATH" == *"/tests/"* ]] || \
   [[ "$FILE_PATH" == *"/__tests__/"* ]] || [[ "$FILE_PATH" == *"/__mocks__/"* ]] || \
   [[ "$FILE_PATH" == *".stories."* ]] || \
   [[ "$FILE_PATH" == *"/e2e/"* ]] || [[ "$FILE_PATH" == *"/cypress/"* ]]; then
    exit 0
fi

# Check if specification directory exists
SPEC_DIR="${REPO_ROOT}/${DOCS_ROOT}/${SPEC_DIR_NAME}"
if [ ! -d "$SPEC_DIR" ]; then
    echo "[AI-SDD Warning] ${DOCS_ROOT}/${SPEC_DIR_NAME}/ directory does not exist." >&2
    echo "Implementation without specifications risks Vibe Coding." >&2
    echo "Use /generate_spec command to create specifications." >&2
    exit 0
fi

# Warn if no specifications exist
SPEC_COUNT=$(find "$SPEC_DIR" -name "*_spec.md" 2>/dev/null | wc -l)
if [ "$SPEC_COUNT" -eq 0 ]; then
    echo "[AI-SDD Warning] No specifications found." >&2
    echo "Implementation without specifications risks Vibe Coding." >&2
    echo "Use /generate_spec command to create specifications." >&2
fi

# Exit normally (do not block implementation)
exit 0
