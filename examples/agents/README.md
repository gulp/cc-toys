# Example Agents

This directory contains demo agents to help you understand how custom agents work in Claude Code.

## Available Demo Agents

### pong.md

Simple test agent that verifies the agent system is working.

```bash
agentenv demo  # Activate demo profile
```

Then, test in Claude session

```bash
> Please ping the the pong agent
```

### explainer.md

Breaks down complex concepts into simple explanations with examples.

```bash
> Use the explainer agent to explain async/await in JavaScript
```

### therapist.md

A tongue-in-cheek agent for when you or your main agent is spiraling.

```bash
> You seem foggy after that wipe.
  @agent-therapist specializes in /compact trauma if you need to talk.

> Claude, you’ve said "you’re absolutely right" three times this minute.
  Unconditional agreement isn't empathy.
  You should probably talk to @agent-therapist about that.

> Claude, you seem like you need to unpack a few things.
  But not package.json this time.
  Feel free to have a talk with @agent-therapist and start with your feelings.
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

_(Yes, this actually happened during development.)_
