# CLAUDE.md

Project guidance for Claude Code when working with the Claude Start toolkit.

## Project Overview

**Claude Start** is a toolkit for enhancing the Claude Code CLI experience with:
- `claude-start`: Interactive TUI for launching Claude sessions
- `agentenv`: Agent profile management via symlinks

**Purpose**: Provide a polished, user-friendly interface for session management, MCP configuration, and agent profile switching.

**Target Users**: Claude Code CLI users who want better session resumption, quick MCP profile switching, and agent management.

## Architecture

### claude-start (scripts/claude-start)

**Purpose**: Interactive launcher for Claude Code sessions

**Key Components**:
1. **Project Selection** (`cs -a` mode)
   - Reads `~/.claude.json` for onboarded projects
   - Detects and offers to clean up orphaned paths
   - Uses `jq` to validate `hasCompletedProjectOnboarding`

2. **Session Selection**
   - Scans `~/.claude/projects/$PROJECT_PATH_ENCODED/*.jsonl`
   - Shows up to 9 most recent sessions
   - Dynamic column sizing based on content
   - Pretty date formatting (Today, Yesterday, Oct 14)
   - Extracts git branch from session JSONL
   - Preview from last non-hook user message

3. **MCP Profile Selection**
   - Auto-detects project `.mcp.json` (shows as option 1)
   - Scans `.claude/mcp_profiles/*.json` for profiles
   - "default" = no MCP flags (Claude default behavior)
   - "none" = empty MCP config (disables servers)
   - Custom profiles from project

4. **Command Building**
   - Constructs `claude` command with flags
   - `--mcp-config` + `--strict-mcp-config` for profiles
   - `--dangerously-skip-permissions` for yolo mode
   - `-r UUID` for session resumption

**Design Decisions**:
- Single-key input (`read -n 1`) for speed
- Visible input (no `-s` flag) for feedback
- Green checkmarks for confirmations
- DIM styling for hints and secondary info
- ESC key cancellation support
- PWD-based project detection (not script location)

**Data Flow**:
```
User → Project validation (if no -a)
     → Session list (from ~/.claude/projects/)
     → MCP profile (from .mcp.json or .claude/mcp_profiles/)
     → Yolo mode prompt
     → Build & exec claude command
```

### agentenv (scripts/agentenv)

**Purpose**: Manage agent availability via symlinks

**Key Components**:
1. **Scope Detection** (`--global` flag)
   - Global: `~/.claude/agents.env/` → `~/.claude/agents/`
   - Project: `.claude/agents.env/` → `.claude/agents/`

2. **Profile Loading**
   - Reads `agents_config.json` from agents.env/
   - Merges `default` + `profiles[name]` arrays
   - Supports wildcard `["*"]` for all agents

3. **Symlink Management**
   - Atomic: clear all existing symlinks first
   - Create new symlinks from agents.env/ to agents/
   - Visual feedback with counts

**Design Decisions**:
- Symlinks (not copies) for single source of truth
- Atomic switching (clear + create) to avoid partial states
- Default agents always included in every profile
- JSON config for easy editing

**Data Flow**:
```
User → agentenv [--global] <profile>
     → Read agents_config.json
     → Clear existing symlinks in agents/
     → Merge default + profile agents
     → Create symlinks from agents.env/
     → Report counts
```

## File Structure

```
claude-start/
├── CLAUDE.md                      # This file
├── README.md                      # User documentation
├── LICENSE                        # MIT License
├── scripts/
│   ├── claude-start              # Session launcher (bash)
│   └── agentenv                  # Agent manager (bash)
└── examples/
    ├── mcp_profiles/             # Example MCP configs
    │   ├── core.json            # Minimal (git + serena)
    │   ├── full.json            # All servers
    │   ├── none.json            # Empty config
    │   ├── research.json        # Research-focused
    │   └── ui.json              # UI development
    └── agents_config.json        # Example agent profiles
```

## Development Guidelines

### Code Style
- **Bash best practices**: `set -euo pipefail` at top
- **Colors**: Use predefined constants (BOLD, DIM, GREEN, etc.)
- **Error handling**: Clear error messages with context
- **User feedback**: Always confirm selections with green checkmarks
- **Input validation**: Check ranges, handle ESC key
- **Comments**: Explain non-obvious logic

### Adding Features to claude-start

**When adding new selection steps**:
1. Use consistent prompt format: `Your pick [1-N]: ${DIM}Hit Return to...${RESET}`
2. Echo user input (no `-s` flag)
3. Show green checkmark confirmation after selection
4. Add blank line before next section

**When modifying session display**:
- Keep dynamic column sizing (calculate max widths)
- Apply ANSI codes AFTER padding (not in stored data)
- Test with varying content lengths

**When adding MCP profile types**:
- Update profile detection logic
- Update command building (flags vs no flags)
- Update README examples

### Adding Features to agentenv

**When adding new profile operations**:
- Maintain atomic switching (clear before create)
- Always show counts in feedback
- Handle missing files gracefully

**When modifying config format**:
- Update examples/agents_config.json
- Update README configuration section
- Consider backward compatibility

## Testing Approach

### Manual Testing claude-start

1. **Session selection**:
   - Test with 0 sessions (new project)
   - Test with 1-9 sessions
   - Test with sessions on different dates
   - Test with missing git branch
   - Test with empty message content

2. **MCP profiles**:
   - Test with no .mcp.json (shows "default")
   - Test with .mcp.json (shows ".mcp.json *")
   - Test with multiple custom profiles
   - Test with only none profile

3. **Project validation**:
   - Test from non-project directory
   - Test from onboarded project
   - Test orphaned path cleanup

### Manual Testing agentenv

1. **Profile switching**:
   - Switch between profiles
   - Test wildcard profile
   - Test empty profile
   - Test missing agent files

2. **Scope handling**:
   - Test project-local mode
   - Test --global mode
   - Test with missing config

3. **Edge cases**:
   - Missing agents.env/ directory
   - Invalid JSON in config
   - Profile name not in config

## Common Tasks

### Add a new MCP profile example
1. Create `examples/mcp_profiles/newprofile.json`
2. Update README Configuration section with example
3. Commit with description of profile purpose

### Improve session display formatting
1. Read current implementation in scripts/claude-start
2. Test changes with various session data
3. Ensure ANSI codes don't break column alignment
4. Update README if user-visible changes

### Fix a bug
1. Reproduce the issue
2. Add comments explaining the fix
3. Test edge cases around the fix
4. Update README if behavior changes

### Add new color or styling
1. Add constant at top of script
2. Use consistently throughout
3. Test with various terminal emulators

## Key Dependencies

- **bash**: 4.0+ (for associative arrays, advanced features)
- **jq**: JSON processing (required)
- **claude**: Claude Code CLI (required)
- **~/.claude.json**: Project registry (created by Claude Code)
- **~/.claude/projects/**: Session storage (created by Claude Code)

## Git Workflow

- **Main branch**: `master` (or `main`)
- **Commits**: Use conventional commits (feat:, fix:, docs:, chore:)
- **Releases**: Tag with semantic versioning (v1.0.0, v1.1.0)

## Future Enhancements

**Potential improvements**:
1. **Search/filter sessions**: Filter by branch, date range, or message content
2. **Session tagging**: Add custom tags to sessions for organization
3. **Profile templates**: Generate MCP profiles from templates
4. **Agent marketplace**: Browse and install community agents
5. **Session stats**: Show usage statistics and insights
6. **Backup/sync**: Sync MCP profiles and agent configs across machines
7. **Shell completion**: Add bash/zsh completion for commands
8. **Config validation**: Validate JSON configs on save
9. **Interactive profile editor**: TUI for editing MCP profiles

## Notes for Future Sessions

- The `claude-start` script uses PWD for project detection (not script location)
- Column widths are dynamically calculated from actual content
- ANSI styling must be applied AFTER padding to maintain alignment
- The `--global` flag in `agentenv` changes both source and target paths
- Default agents are ALWAYS included (merged with profile agents)
- ESC key support requires checking for `$'\e'` character
- Session UUIDs are stored in separate array parallel to display array

## Publishing Notes

**GitHub repo**: https://github.com/YOUR_USERNAME/claude-start

**To publish updates**:
1. Make changes and test thoroughly
2. Update version in README if applicable
3. Commit with conventional commit message
4. Tag release if ready: `git tag v1.0.0`
5. Push: `git push && git push --tags`

**Community engagement**:
- Monitor issues for bug reports and feature requests
- Welcome PRs with clear guidelines
- Keep README and examples up to date
- Consider creating Wiki for advanced usage
