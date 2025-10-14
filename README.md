# Claude Start

A comprehensive toolkit for launching Claude Code sessions with enhanced UX and intelligent configuration management.

## Features

### `claude-start` - Session Launcher TUI
An interactive terminal UI for starting Claude Code sessions with:

- **Session Management**
  - Pretty date formatting (Today, Yesterday, Oct 14)
  - Dynamic column sizing based on content
  - Latest session marked with asterisk (*)
  - Git branch display with smart truncation
  - Show up to 9 recent sessions

- **MCP Profile Selection**
  - Auto-detect project `.mcp.json`
  - Dynamic profile discovery from `.claude/mcp_profiles/`
  - Quick switching between profiles
  - Support for "none" (empty config) and "default" (Claude defaults)

- **Project Validation**
  - Validates against `~/.claude.json` onboarded projects
  - Interactive cleanup of orphaned project paths
  - Clear error messages for invalid projects

- **User Experience**
  - Visible input feedback
  - Range-based prompts: "Your pick [1-7]"
  - Green checkmark confirmations
  - ESC key support for cancellation

### `agentenv` - Agent Profile Manager
Manage Claude Code agent profiles with symlink-based activation:

- **Profile Management**
  - Project-local or global (`--global`) agent profiles
  - JSON-configured profiles with default agents
  - Wildcard support for "all agents" profile

- **Features**
  - List available profiles and agents
  - Atomic profile switching (clear + create)
  - Visual feedback with counts and confirmations

## Installation

### Prerequisites
- Claude Code CLI (`claude` command)
- `jq` for JSON processing
- Bash 4.0+

### Setup

1. **Clone or download this repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/claude-start.git
   cd claude-start
   ```

2. **Install scripts**
   ```bash
   # Make scripts executable
   chmod +x scripts/claude-start scripts/agentenv

   # Add to PATH (choose one method):

   # Option 1: Symlink to ~/.local/bin
   ln -s "$(pwd)/scripts/claude-start" ~/.local/bin/cs
   ln -s "$(pwd)/scripts/agentenv" ~/.local/bin/agentenv

   # Option 2: Add to PATH in your shell rc file
   echo 'export PATH="$HOME/path/to/claude-start/scripts:$PATH"' >> ~/.bashrc
   echo 'alias cs="claude-start"' >> ~/.bashrc
   ```

3. **Set up MCP profiles** (per project)
   ```bash
   # Copy example profiles to your project
   mkdir -p your-project/.claude/mcp_profiles
   cp examples/mcp_profiles/*.json your-project/.claude/mcp_profiles/

   # Customize profiles as needed
   ```

4. **Set up agent profiles** (optional)
   ```bash
   # For global agent management
   mkdir -p ~/.claude/agents.env
   cp examples/agents_config.json ~/.claude/agents.env/

   # Add your agent .md files to ~/.claude/agents.env/

   # For project-local management
   mkdir -p your-project/.claude/agents.env
   cp examples/agents_config.json your-project/.claude/agents.env/
   ```

## Usage

### claude-start

#### Basic Usage
```bash
# From within a Claude project
cs

# Select from all onboarded projects
cs -a    # or cs --all
```

#### Session Selection
The launcher shows recent sessions with:
- Date/time (Today, Yesterday, or Oct 14)
- Git branch in brackets: `[develop]`, `[feature/foo]`
- Preview of last message
- Asterisk (*) on most recent session

```
Select Session:
1) Today, 12:30 *  [develop]        "implement feature X..."
2) Yesterday, 15:45 [feature/auth]  "fix login bug..."
3) Oct 13, 09:20   [main]           "refactor parser..."
0) New session

Your pick [1-3]: Hit Return to select latest
> 1
✓ Selected: Today, 12:30 abc1234
```

#### MCP Profile Selection
Choose MCP server configuration:

```
Select MCP Profile:
1) default *
2) core
3) full
4) research
0) none

Your pick [1-4]: Hit Return to select default
> 2
✓ Selected: core
```

**Profile Types:**
- **default**: Uses Claude's default MCP behavior (no flags)
- **.mcp.json**: Uses project's `.mcp.json` if present (shows as option 1)
- **none**: Empty MCP config (disables all servers)
- **custom**: Any profile from `.claude/mcp_profiles/`

#### Yolo Mode
Skip permission prompts:
```
Yolo mode (skip permissions)? [y/N] y
```

### agentenv

#### List Profiles
```bash
# Project-local profiles
agentenv

# Global profiles
agentenv --global
```

Output:
```
Scope: project

Available profiles:
  bmad: business-analyst, architect
  product: business-analyst, product-manager
  full: *
  none:

Default agents (always included):
context-gathering, context-refinement, logging

Available agents in .claude/agents.env:
  • architect
  • business-analyst
  • code-review
  • product-manager
  • test-automator
```

#### Activate Profile
```bash
# Project-local
agentenv bmad

# Global
agentenv --global full
```

Output:
```
Agent Environment: bmad (project)

Clearing 3 existing symlink(s)...
  ✓ context-gathering
  ✓ context-refinement
  ✓ logging
  ✓ business-analyst
  ✓ architect

✓ Cleared 3 symlink(s), created 5 symlink(s) for profile: bmad
```

## Configuration

### MCP Profiles

Create profile files in `.claude/mcp_profiles/*.json`:

**Example: `core.json`**
```json
{
  "mcpServers": {
    "git": {
      "command": "mcp-server-git",
      "args": ["--repository", "."]
    },
    "serena": {
      "command": "npx",
      "args": ["-y", "mcp-serena"]
    }
  }
}
```

**Example: `none.json`**
```json
{
  "mcpServers": {}
}
```

### Agent Profiles

Configure in `agents_config.json`:

```json
{
  "default": [
    "context-gathering",
    "context-refinement",
    "logging"
  ],
  "profiles": {
    "bmad": [
      "business-analyst",
      "architect"
    ],
    "product": [
      "business-analyst",
      "product-manager"
    ],
    "full": ["*"],
    "none": []
  }
}
```

**Fields:**
- `default`: Agents included in all profiles
- `profiles.<name>`: List of agents for that profile
- `"*"`: Wildcard - includes all agents from `agents.env/`

## Project Structure

```
claude-start/
├── README.md
├── LICENSE
├── scripts/
│   ├── claude-start      # Session launcher TUI
│   └── agentenv          # Agent profile manager
└── examples/
    ├── mcp_profiles/     # Example MCP configurations
    │   ├── core.json     # Git + Serena only
    │   ├── full.json     # All MCP servers
    │   ├── none.json     # Empty config
    │   ├── research.json # Research-focused servers
    │   └── ui.json       # UI development servers
    └── agents_config.json # Example agent profiles
```

## Requirements

- **Claude Code**: Latest version with MCP support
- **jq**: JSON processor (`sudo apt install jq` or `brew install jq`)
- **bash**: Version 4.0 or higher
- **~/.claude.json**: Claude project registry (created by Claude Code)

## Tips

1. **Alias for speed**
   ```bash
   alias cs="claude-start"
   ```

2. **Quick project switching**
   ```bash
   cs -a  # Lists all onboarded projects
   ```

3. **Create custom MCP profiles** for different workflows:
   - `dev.json`: Development servers (git, serena, filesystem)
   - `review.json`: Code review tools only
   - `minimal.json`: Bare minimum servers

4. **Agent profile strategy**:
   - Use global profiles for common setups
   - Use project profiles for specialized needs
   - Keep `default` agents minimal (always loaded)

## Troubleshooting

### "Not in an onboarded Claude project"
- Run `cs -a` to select a valid project
- Or navigate to a project directory with `.claude/` folder

### Orphaned project paths
- `cs -a` will detect and prompt to remove non-existent paths
- Cleans up `~/.claude.json` automatically with permission

### MCP profile not loading
- Verify JSON syntax: `jq . .claude/mcp_profiles/your-profile.json`
- Check file permissions
- Ensure `.mcp.json` or selected profile exists

### Agent symlinks not working
- Verify `agents_config.json` exists
- Check that agent `.md` files exist in `agents.env/`
- Run `agentenv` with no args to list available agents

## License

MIT License - see [LICENSE](LICENSE) for details

## Contributing

Contributions welcome! Please open an issue or pull request.

## Acknowledgments

Built for the Claude Code community to enhance the CLI experience.
