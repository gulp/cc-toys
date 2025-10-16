# cc-toys

Just a couple of shell toys that make Claude sessions a little easier to live with.

<p align="center">
<img src="assets/shape_sorter.png" alt="cc-toys" width="360">
</p>

Generated end-to-end with Claude Code. I just pressed Enter and pretended to supervise.

⚠️ Use at your own risk (and curiosity).

---

## Why cc-toys?

Because context switching shouldn’t feel like a ceremony.

Claude lets you `/resume`, sure — but unless you start with `-c`, you’ve already opened a new session by the time you get there.
`ccup` flips that. It shows all projects or recent sessions from a project folder before launch, so you can jump straight back to what you were doing.

It also helps trim the fat. Extra MCP servers and agents quietly eat into your context. With `ccup` and `agentenv`, you choose what runs and keep the rest off.

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

---

## Scaffolding

**ccup --scaffold** copies examples to your project:

```bash
cd your-project
ccup --scaffold

# Choose:
# 1) MCP profiles (core, research, ui, full)
# 2) Demo agents (pong, explainer, therapist)
# 3) Both
```

### MCP Profiles

Included examples: `core`, `research`, `ui`, `full`

### Demo Agents

Included examples: `pong`, `explainer`, `therapist`

See [examples/agents/README.md](examples/agents/README.md) for details.

---

## Requirements

- **Claude Code CLI** - The `claude` command ([download](https://claude.ai/download))
- **jq** - JSON processor
  - macOS: `brew install jq`
  - Ubuntu/Debian: `sudo apt install jq`
  - Arch: `sudo pacman -S jq`
- **Bash 4.0+**

**Optional:**

- **fzf** - Fuzzy finder for better project selection
  - macOS: `brew install fzf`
  - Ubuntu/Debian: `sudo apt install fzf`
  - Arch: `sudo pacman -S fzf`

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

## License

[WTFPL](LICENSE) - Please do whatever you want with it.

This is a personal project that works for me. Published in case it's useful to someone else.

No support, no promises. Use at your own risk.

---

**Made with Claude Code** 🤖
