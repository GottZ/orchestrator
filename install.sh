#!/bin/bash
#
# install.sh - Install Project Orchestrator agents and commands
#
# Usage: ./install.sh [--copy|--symlink]
#   --symlink  Use symlinks (default, updates propagate automatically)
#   --copy     Copy files (standalone, no auto-updates)
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
AGENTS_DIR="${CLAUDE_DIR}/agents"
COMMANDS_DIR="${CLAUDE_DIR}/commands"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default to symlinks
MODE="symlink"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --copy)
            MODE="copy"
            shift
            ;;
        --symlink)
            MODE="symlink"
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Usage: $0 [--copy|--symlink]"
            exit 1
            ;;
    esac
done

echo "Project Orchestrator Installer"
echo "==============================="
echo ""
echo "Mode: ${MODE}"
echo "Source: ${SCRIPT_DIR}"
echo "Target: ${CLAUDE_DIR}"
echo ""

# Create directories
echo -n "Creating directories... "
mkdir -p "${AGENTS_DIR}" "${COMMANDS_DIR}"
echo -e "${GREEN}done${NC}"

# Install function
install_file() {
    local src="$1"
    local dst="$2"
    local name="$(basename "$src")"

    if [[ "${MODE}" == "symlink" ]]; then
        # Remove existing file/link
        rm -f "${dst}"
        ln -sf "${src}" "${dst}"
        echo -e "  ${name} -> ${GREEN}symlinked${NC}"
    else
        cp "${src}" "${dst}"
        echo -e "  ${name} -> ${GREEN}copied${NC}"
    fi
}

# Install agents
echo ""
echo "Installing agents:"
for agent in "${SCRIPT_DIR}/agents"/*.md; do
    if [[ -f "$agent" ]]; then
        install_file "$agent" "${AGENTS_DIR}/$(basename "$agent")"
    fi
done

# Install commands
echo ""
echo "Installing commands:"
for cmd in "${SCRIPT_DIR}/commands"/*.md; do
    if [[ -f "$cmd" ]]; then
        install_file "$cmd" "${COMMANDS_DIR}/$(basename "$cmd")"
    fi
done

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Start a new Claude Code session"
echo "  2. Run '/help' to verify commands are available"
echo "  3. Try '/plan \"Test project\"' to test the planner"
echo ""
echo "Available commands:"
echo "  /plan [description]     - Plan a new project"
echo "  /orchestrate [path]     - Execute a project plan"
echo "  /task [path]            - Run a single task"
