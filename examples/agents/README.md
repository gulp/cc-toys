# Example Agents

This directory contains demo agents to help you understand how custom agents work in Claude Code.

## Available Demo Agents

### pong.md

Simple test agent that verifies the agent system is working.

**Use case:** Testing agent installation and invocation

```bash
# Activate
agentenv demo

# Test in Claude session
> Use the Task tool with the pong agent
```

### explainer.md

Breaks down complex concepts into simple explanations with examples.

**Use case:** Learning new technologies or explaining code patterns

```bash
# Example usage in Claude
> Use the explainer agent to explain async/await in JavaScript
```

### therapist.md

A tongue-in-cheek agent for when you or your main agent is spiraling.

**Use case:** Comic relief during debugging sessions, perspective reframing

```bash
# When everything is broken
> Bring in the therapist agent - I think we need some perspective
```

## Using These Agents

### Quick Setup

Use `ccup --scaffold` to copy these examples to your project automatically:

```bash
cd your-project
ccup --scaffold
# Choose option 2 (Demo agents) or 3 (Both)
```

### Manual Setup

If you want to copy them manually from the installed examples:

```bash
# Create the agents environment directory
mkdir -p .claude/agents.env

# Copy everything from the examples
cp -r ~/.local/share/cc-toys/examples/agents.env/* .claude/agents.env/
```

### Activating Agents

```bash
agentenv demo    # Activates pong, explainer, therapist
agentenv minimal # Just pong for testing
```

This creates symlinks from `.claude/agents.env/` → `.claude/agents/` based on the profile definition in `agents_config.json`.

### Create Your Own

See the [official sub-agents documentation](https://docs.claude.com/en/docs/claude-code/sub-agents) for how to create custom agents.

---

## Sample Sessions

Want to see the therapist agent in action? Check out [sample_session.txt](sample_session.txt) for a real conversation where Claude discusses "grief over inherited context."

*(Yes, this actually happened during development.)*
