# cc-toys

<p align="center">
  <img src="assets/shape_sorter.png" alt="cc-toys" width="180">
</p>

Small, friendly CLI helpers for Claude Code.

They're not a framework. They're not even a toolkit.
Just a couple of shell toys that make Claude sessions a little easier to live with.

Generated end-to-end with Claude Code. I just pressed Enter and pretended to supervise.
Use at your own risk (and curiosity).

---

## Why cc-toys?

Because getting back into a Claude Code session shouldn't feel like a ritual.

By default, you have to launch Claude first, then /resume, then guess which session you were in. ccup flips that around — it shows your sessions before Claude opens, with timestamps, branches, and message previews, so you can jump straight to what you were doing.

It also handles MCP overhead. Each extra server quietly eats into your context, even if you're just checking a note. With ccup, you can pick a lighter MCP profile or run with none at all. Pair it with agentenv to toggle agents per project, and you'll stop wasting tokens on idle ones.

Less juggling, more continuity.

---

## Commands

- **ccup** — resume or start a Claude Code session (with MCP profiles, project switching, scaffolding)
- **agentenv** — switch agent profiles via symlinks (project or global scope)

---

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/gulp/cc-toys/main/install.sh | bash
```

Or pin to a version:
```bash
VERSION=v0.1.0 bash -c "$(curl -fsSL https://raw.githubusercontent.com/gulp/cc-toys/main/install.sh)"
```

### Manual Install

```bash
git clone https://github.com/gulp/cc-toys.git
cd cc-toys
chmod +x scripts/*
ln -s "$(pwd)/scripts/ccup" ~/.local/bin/ccup
ln -s "$(pwd)/scripts/agentenv" ~/.local/bin/agentenv
```

---

## Usage

### ccup - Session Launcher

```bash
# From any Claude Code project
ccup

# Select from all onboarded projects
ccup -a

# Copy MCP profiles and demo agents to project
ccup --scaffold
```

**What it does:**
1. Shows your recent sessions (smart filtered, no orphans)
2. Let you pick MCP profile (or use project default)
3. Asks about yolo mode (skip permissions)
4. Launches Claude with your selections

**Features:**
- Pretty dates: "Today, 14:30", "Yesterday", "Oct 14"
- Git branch display with smart truncation
- Message previews from last input
- Latest session marked with `*`
- ESC key to cancel at any step
- Single-key navigation (1-9, 0)

**Example:**
```
Select Session:
1) Today, 14:30 *   [feature/auth]   "implement OAuth login..."
2) Today, 11:45     [develop]        "fix session bug..."
3) Yesterday, 16:20 [main]           "refactor API client..."
0) New session

Your pick [1-3]: Hit Return to select latest
> 1
✓ Selected: Today, 14:30 * abc1234

Select MCP Profile:
1) .mcp.json *
2) core
3) research
0) none

Your pick [1-3]: Hit Return to select .mcp.json
> 2
✓ Selected: core

Yolo mode (skip permissions)? [y/N] n

Running: claude --mcp-config ".claude/mcp_profiles/core.json" --strict-mcp-config -r abc1234
```

---

### agentenv - Agent Manager

```bash
# List available profiles
agentenv              # Project scope
agentenv --global     # Global scope

# Activate a profile
agentenv demo         # Project: activate pong, explainer, therapist
agentenv --global full  # Global: activate all agents

# Quick operations
agentenv --only pong         # Activate single agent
agentenv --clear             # Remove all agents
agentenv --global --only pong  # Global single agent

# Migrate from manual setup
agentenv --migrate           # Convert agents/ → agents.env/ structure
agentenv --global --migrate  # Migrate global agents
```

**What it does:**
- Manages which agents are available via symlinks
- Supports project-local or global agent profiles
- Atomic switching (clears old, creates new)
- Default agents always included in profile mode

**How it works:**
- Agents live in `.claude/agents.env/` (project) or `~/.claude/agents.env/` (global)
- Active agents are symlinked to `.claude/agents/` or `~/.claude/agents/`
- Profile config (`agents_config.json`) defines which agents to activate

**Operations:**
- `agentenv <profile>` - Switch to profile (includes default agents)
- `agentenv --only <agent>` - Activate single agent (no defaults)
- `agentenv --clear` - Remove all agents
- `agentenv --migrate` - Migrate from manual setup to managed structure

**Migration:**
If you have existing agents in `.claude/agents/`, use `--migrate` to convert to the managed structure:

```bash
$ agentenv --migrate

Agent Environment: migrate (project)

✓ Created .claude/agents.env/
✓ Copied 3 agents: code-review, context-gathering, logging
✓ Created agents_config.json with "core" profile
✓ Renamed .claude/agents/ → .claude/agents.backup/
✓ Activated "core" profile (3 symlinks created)

Migration complete!

Profile "core" contains:
  • code-review, context-gathering, logging

Cleanup (after verifying):
  rm -rf .claude/agents.backup/
```

**What migration does:**
1. Creates `agents.env/` directory
2. Copies real `.md` files from `agents/` (skips symlinks)
3. Creates `agents_config.json` with "core" profile
4. Renames `agents/` → `agents.backup/` (preserves originals)
5. Activates "core" profile automatically (creates symlinks)

**Edge cases:**
- Empty `agents/` directory → Suggests using `ccup --scaffold`
- Existing `agents.env/` without config → Creates config from existing files

---

### Scaffolding

**ccup --scaffold** copies examples to your project:

```bash
cd your-project
ccup --scaffold

# Choose:
# 1) MCP profiles (core, research, ui, full)
# 2) Demo agents (pong, explainer, therapist)
# 3) Both
```

**Creates:**
- `.claude/mcp_profiles/*.json` - Ready-to-use MCP configurations
- `.claude/agents.env/*.md` - Demo agents you can test immediately
- `.claude/agents.env/agents_config.json` - Agent profile configuration

---

## MCP Profiles

Included examples:

### core.json
Essential servers only:
```json
{
  "mcpServers": {
    "git": {...},
    "filesystem": {...}
  }
}
```

### research.json
Web research with AI search:
```json
{
  "mcpServers": {
    "git": {...},
    "fetch": {...},
    "puppeteer": {...},
    "exa": {...},         // Requires API key from exa.ai
    "context7": {...}
  }
}
```

### ui.json
Browser automation for UI work:
```json
{
  "mcpServers": {
    "git": {...},
    "filesystem": {...},
    "puppeteer": {...}
  }
}
```

### full.json
Comprehensive setup:
```json
{
  "mcpServers": {
    "git": {...},
    "filesystem": {...},
    "fetch": {...},
    "puppeteer": {...},
    "sqlite": {...}
  }
}
```

> **Note:** The `exa` server in research.json requires an API key. Get one from [exa.ai](https://exa.ai) and replace `YOUR_EXA_API_KEY`.

---

## Demo Agents

### [pong.md](examples/agents/pong.md)
Simple test agent to verify the agent system works.

```bash
agentenv demo
# Then use Task tool → pong agent
# Response: "🏓 Pong! Agent system is working!"
```

### [explainer.md](examples/agents/explainer.md)
Breaks down complex concepts into simple explanations.

**Format:**
1. One-sentence summary
2. Concrete example
3. Common misconception
4. Next step

### [therapist.md](examples/agents/therapist.md)
A tongue-in-cheek agent for when debugging gets existential.

**Crisis indicators:**
- More than 3 consecutive "sorry" messages
- Error contains both "undefined" AND "null"
- Commit message is just "fix" or "aaaaaa"
- "it worked on my machine"

**Sample mantras:**
- "You ship, therefore you are."
- "The semicolon didn't make you less worthy."
- "`npm install forgiveness`"

---

## Tips

**Speed optimization:**
```bash
# Hit Return 3 times → launched in ~1 second
ccup
# (Selects: latest session, default MCP, no yolo)
```

**Workflow patterns:**
```bash
# Resume yesterday's work
ccup

# New session with different MCP profile
ccup  # Pick 0 (new), then select profile

# Quick project switching
ccup -a

# Set up a fresh project
ccup --scaffold
```

**Custom profiles:**
Create your own in `.claude/mcp_profiles/`:
- `minimal.json` - No MCP servers (fastest)
- `dev.json` - Your daily drivers
- `review.json` - Git only for code reviews

---

## Troubleshooting

### "Not in a Claude Code project"
Run `ccup -a` to select a valid project, or navigate to a directory with `.claude/`

### Orphaned project paths
`ccup -a` detects missing directories and offers to remove them from `~/.claude.json`

### MCP profile not loading on resume
MCP selection only applies to **new sessions**. When resuming, the original session's MCP config is used (Claude Code limitation).

### Session won't resume
The script filters invalid sessions automatically. If you see one that won't resume:
1. Update to latest cc-toys
2. Report the issue with session UUID

---

## Project Structure

**Repository:**
```
cc-toys/
├── scripts/
│   ├── ccup            # Session launcher
│   └── agentenv        # Agent manager
├── install.sh          # One-line installer
├── uninstall.sh        # Clean removal
└── examples/
    ├── mcp_profiles/   # MCP configuration examples
    │   ├── core.json
    │   ├── research.json
    │   ├── ui.json
    │   └── full.json
    ├── agents/         # Demo agent examples
    │   ├── pong.md
    │   ├── explainer.md
    │   ├── therapist.md
    │   └── README.md
    └── agents_config.json
```

**Installed examples** (at `~/.local/share/cc-toys/examples/`):
```
examples/
├── mcp_profiles/
│   ├── core.json
│   ├── research.json
│   ├── ui.json
│   └── full.json
└── agents.env/
    ├── pong.md
    ├── explainer.md
    ├── therapist.md
    ├── agents_config.json
    └── README.md
```

---

## Requirements

- **Claude Code CLI** - The `claude` command ([download](https://claude.ai/download))
- **jq** - JSON processor
  - macOS: `brew install jq`
  - Ubuntu/Debian: `sudo apt install jq`
  - Arch: `sudo pacman -S jq`
- **Bash 4.0+**

---

## Uninstall

```bash
./uninstall.sh
```

Or manually:
```bash
rm ~/.local/bin/ccup ~/.local/bin/agentenv
```

---

## Contributing

Found a bug? Have an idea? [Open an issue](https://github.com/gulp/cc-toys/issues).

Want to add a tool? Keep it:
- Small (< 500 lines)
- Focused (does one thing well)
- Friendly (helpful errors, clear output)

---

## License

MIT - See [LICENSE](LICENSE)

---

**Made with Claude Code** 🤖
