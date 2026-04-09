---
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*)
description: Create a conventional commit (feat, fix, docs, style, refactor, perf, test, chore)
---

## Context

- Git status: !`git status`
- Staged and unstaged changes: !`git diff HEAD`
- Recent commits: !`git log --oneline -10`

## Your task

Analyse all changes and group them into logical commits — do not create one large commit if changes span multiple concerns.

For each logical group:

1. Identify the appropriate conventional commit type
2. Stage only the files belonging to that group
3. Write a subject line: `type(scope): description`
   - Lowercase, no full stop, under 72 characters
   - Scope is optional but encouraged
4. Add a commit body only when the why is not obvious from the code — explain reasoning, tradeoffs, or context a future developer would need. Skip the body for simple changes.
5. Never commit `.env`, credentials, or secrets

### Types

- `feat` — new feature or behaviour
- `fix` — bug fix
- `chore` — maintenance, deps, config, tooling
- `docs` — documentation only
- `refactor` — restructuring without changing behaviour
- `test` — adding or updating tests
- `style` — formatting, whitespace, no logic change
- `perf` — performance improvement

### Example output

```
feat(neovim): replace vim-vsnip with LuaSnip

LuaSnip is the de facto standard snippet engine for Neovim.
Migrated cmp integration and preserved existing snippet files.
```

```
chore(ansible): add Claude commands directory tasks
```

Do not add any commentary outside of the git commands themselves.
