# Claude Code Agents

This project uses specialized agents for various architectural and technical tasks.

## Available Agents

### 🏗️ AI Solutions Architect (`ai-solutions-architect.md`)

**Specialization:** Expert in complex AI solutions with deep knowledge of modern technologies

**Expertise:**
- Flutter 3.27+ with Material Design 3 (tokens v6.1)
- TypeScript 5.6+ for Firebase Cloud Functions
- Firebase AI Logic (Sept 2025 updates) - hybrid inference
- Firebase Genkit with multi-provider orchestration
- OpenAI GPT-4.1 family (1M context, function calling)
- Flutter Gemma with MediaPipe GenAI v0.10.24
- xAI Grok, GitHub Models, Llama 3.1

**When to invoke:**
```
- Designing new AI service integrations
- Migrating from deprecated packages (google_generative_ai → firebase_ai)
- Optimizing multi-model architectures
- Implementing hybrid on-device/cloud inference
- Troubleshooting Firebase Genkit deployments
- Making architectural decisions about model selection
- Reviewing security and cost implications
- Planning Flutter + AI application architecture
```

**Usage examples:**

```
@ai-solutions-architect Design a hybrid inference system
with fallback between on-device Gemma and cloud Gemini

@ai-solutions-architect How to migrate from google_generative_ai to firebase_ai
without breaking changes?

@ai-solutions-architect Optimize AI call costs considering
GPT-4.1-mini vs Gemini 2.0 Flash

@ai-solutions-architect Review current multi-AI integration architecture
and suggest improvements
```

## Project Context

Agents have access to:
- **MODERNIZATION_PLAN_2025.md** - architecture migration plan
- **README.md** - technical documentation
- **CLAUDE.md** - development rules

Agents automatically consider:
- Critical migration deadlines (August 2025)
- Current architecture (6 AI services)
- Target architecture (5 modern services)
- Backward compatibility constraints

## Best Practices

1. **Be specific** in agent requests
2. **Provide context** of current work
3. **Mention constraints** (budget, deadlines, performance)
4. **Ask for trade-offs** between solution options

## Adding New Agents

Create a file `.claude/agents/your-agent-name.md` with structure:

```markdown
# Agent Name

You are an expert in [domain]...

## Core Expertise
- Technology 1
- Technology 2

## Best Practices
...

## When to Call This Agent
...
```

Then update this README with the agent description.

---

**Version:** 1.0.0
**Created:** 2025-10-18
**Last Updated:** 2025-10-18
