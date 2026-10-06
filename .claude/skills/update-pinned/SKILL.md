---
name: update-pinned
description: Check for and apply updates to the pinned release downloads in this repo (Neovim, lazygit, fzf, delta, eza, starship, win32yank). Use when the user asks to update tools, check for new versions, bump Neovim/lazygit/etc., or asks "what's out of date?".
---

# Updating pinned tools

Seven tools are installed from pinned GitHub release tarballs with sha256
checksums (roles/pinned-tarball). Their versions and checksums live in role
defaults. `scripts/update-pinned.py` does the mechanical work; this skill adds
the review and workflow around it. Human-facing docs:
docs/updating-pinned-tools.md.

Never edit versions or checksums by hand — always go through the script, so
checksums come from the real release assets.

## 1. See what's outdated

```bash
scripts/update-pinned.py check
```

If everything is up to date, say so and stop.

## 2. Review release notes before recommending anything

For each outdated tool:

```bash
scripts/update-pinned.py notes <tool>          # add --full if truncated notes matter
```

Read every release between the pin and latest, not just the newest. Look for
breaking changes, removed/renamed flags or config keys, and changed defaults,
and check them against how THIS repo uses the tool (grep before judging):

| Tool | Where the repo depends on it |
|---|---|
| neovim | `roles/neovim/files/**` — `vim.lsp.config` (0.11+ API), lazy.nvim, nvim-treesitter `main` branch (parser ABI), `options.lua` providers |
| lazygit | bound to `<leader>gg` via toggleterm in `lua/plugins/init.lua` |
| fzf | `roles/zsh/files/zshrc` — `fzf --zsh` (needs >= 0.48), `FZF_DEFAULT_OPTS` colour names, Ctrl-T preview options |
| delta | `git_config` in common-software tasks: `core.pager`, `interactive.diffFilter` (`delta --color-only`), `delta.navigate` |
| eza | zshrc aliases `l` / `lt`: `-la --header --git --group-directories-first --icons=auto`, `--tree --level=2 --git-ignore` |
| starship | `roles/zsh/files/starship.toml` — module names, `format` variables, `os.symbols` |
| win32yank | Neovim clipboard under WSL2 (`clipboard=unnamedplus`) |

Report per tool: current → latest, a one-line summary, and anything that
needs a config change. Recommend a subset; patch releases with no impact are
usually safe to take. Ask the user which to bump (AskUserQuestion,
multiSelect) — don't bump without approval.

## 3. Bump, one commit per tool

Work on a branch: if already on an unmerged feature branch, use it;
otherwise create `chore/bump-tools-<YYYY-MM-DD>` from main.

For each approved tool:

```bash
scripts/update-pinned.py bump <tool>           # or: bump <tool> <version>
git diff                                       # must be ONLY the version + checksum lines
```

If a release needs a config change (e.g. a renamed starship module), make it
in the same commit as the bump. Commit as `chore: bump <tool> to <version>`
with a short body summarising what changed upstream that matters here.

Then run `ansible-playbook playbook.yml --syntax-check`.

## 4. Hand over the playbook run

Do NOT run the playbook — it needs the user's sudo password. Give them one
command covering every bumped tool's tag (the script prints each tag):

```bash
ansible-playbook playbook.yml -e @personal-config.yml --tags <tag1>,<tag2> -K
```

Expect 5 changed tasks per bumped tool (versioned dir, download, extract,
remove tarball, relink). A second run should be `changed=0`. A checksum
failure in "Download pinned <tool> tarball" means the pin is wrong — re-run
`scripts/update-pinned.py verify`.

## 5. Post-upgrade checks to suggest

- neovim: `nvim --version`, then `:checkhealth` and `:Lazy`. If highlighting
  errors appear, `:TSUpdate` — a new Neovim can need parsers rebuilt and the
  treesitter handler only fires on config changes, not Neovim bumps.
- lazygit: `lazygit --version`, `<leader>gg` in Neovim.
- fzf: `fzf --version`, Ctrl-R / Ctrl-T in a new shell.
- delta: `git diff` / `git add -p` render through delta.
- eza: `l` and `lt` in a repo.
- starship: open a new shell; check the prompt renders with no warnings
  (`starship explain`).
- win32yank: yank in Neovim, paste in Windows.

## 6. Clean up old versions (after the user confirms all is well)

Old versions are kept for instant rollback (set the version back, re-run the
tag — it only relinks). Once the user is happy:

```bash
ls ~/.local/share/<tool>-releases/       # nvim-releases for Neovim
rm -rf ~/.local/share/<tool>-releases/<old-version>
```

Confirm with the user before deleting.

## Troubleshooting

- `release ... has no asset named ...`: upstream renamed its assets. Update
  the tool's entry in `TOOLS` in `scripts/update-pinned.py` AND the download
  URL in the role together, then `scripts/update-pinned.py verify`.
- `GitHub API rate limit hit`: wait an hour or `export GITHUB_TOKEN=...`.
- Adding a new pinned tool: add version/arch map/checksums to the role
  defaults, an `include_role: pinned-tarball` call in the role (see eza in
  roles/common-software/tasks/main.yml), and an entry in `TOOLS`; then
  `verify`.
