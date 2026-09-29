# Updating Pinned Tools

Seven command-line tools are installed from **pinned** GitHub releases: an
exact version plus a sha256 checksum, so every machine gets the identical,
verified binary. Nothing updates itself; you decide when to move.

| Tool | What it is | Pinned in | Playbook tag |
|---|---|---|---|
| neovim | the editor | `roles/neovim/defaults/main.yml` | `neovim` |
| lazygit | git TUI (`<leader>gg`) | `roles/common-software/defaults/main.yml` | `lazygit` |
| fzf | fuzzy finder (Ctrl-R/T, Alt-C) | `roles/common-software/defaults/main.yml` | `fzf` |
| delta | git diff pager | `roles/common-software/defaults/main.yml` | `delta` |
| eza | `l` / `lt` listings | `roles/common-software/defaults/main.yml` | `eza` |
| starship | shell prompt | `roles/zsh/defaults/main.yml` | `zsh` |
| win32yank | WSL clipboard for Neovim | `roles/common-software/defaults/main.yml` | `clipboard` |

## The easy way: ask Claude Code

In this repo, just say **"update my tools"** (or run `/update-pinned`). The
`update-pinned` skill (`.claude/skills/update-pinned/SKILL.md`) will:

1. show what's out of date,
2. read the release notes and flag anything that affects your config,
3. ask which ones to bump,
4. bump each one in its own commit on a branch,
5. give you the one playbook command to run (it never runs it; it needs
   your sudo password), and the checks to do afterwards.

## Doing it yourself

All the mechanical work is in `scripts/update-pinned.py`:

```bash
scripts/update-pinned.py check            # pinned vs latest, for all seven
scripts/update-pinned.py notes neovim     # release notes since your pin
scripts/update-pinned.py bump neovim      # pin the latest release
scripts/update-pinned.py bump neovim v0.12.5   # ...or a specific one
scripts/update-pinned.py bump neovim --dry-run # show, don't write
scripts/update-pinned.py verify           # pinned checksums still correct?
```

A typical update:

```bash
git switch -c chore/bump-tools
scripts/update-pinned.py check
scripts/update-pinned.py notes lazygit        # skim for breaking changes
scripts/update-pinned.py bump lazygit
git diff                                      # only the version + 2 checksum lines
git commit -am "chore: bump lazygit to 0.65.1"
ansible-playbook playbook.yml -e @personal-config.yml --tags lazygit -K
lazygit --version
```

`bump` only edits the repo. The playbook run is what installs it. You'll see
5 changed tasks per tool (create the version folder, download, extract,
delete the tarball, relink `~/.local/bin/<tool>`); a second run shows
`changed=0`.

### Where the checksums come from

GitHub publishes a sha256 digest for every release file, and the script
copies it from there. If a release has none (old releases, e.g. win32yank),
the script downloads the file and hashes it itself. The playbook then checks
every download against the pin, so a tampered or truncated file fails the
run instead of being installed.

## Rolling back

Old versions stay installed next to the new one:

```
~/.local/share/nvim-releases/v0.12.4/     <- old
~/.local/share/nvim-releases/v0.12.5/     <- new, ~/.local/bin/nvim points here
```

To go back, set the old version again (`scripts/update-pinned.py bump neovim
v0.12.4`) and re-run the tag. It only moves the link, with no download.

When you're happy with the new version, delete the old folder:

```bash
rm -rf ~/.local/share/nvim-releases/v0.12.4
```

(Other tools use `~/.local/share/<tool>-releases/<version>/`.)

## After updating Neovim

- `:checkhealth` and `:Lazy` should be clean. Plugins don't change; they're
  pinned separately in `roles/neovim/files/lazy-lock.json`.
- If syntax highlighting shows errors, run `:TSUpdate` once. A new Neovim can
  need the treesitter parsers rebuilt.

## When something goes wrong

| Message | Meaning / fix |
|---|---|
| `release ... has no asset named ...` | Upstream renamed its download files. Update the tool's entry in `TOOLS` at the top of `scripts/update-pinned.py` **and** the download URL in the role, then run `verify`. |
| `GitHub API rate limit hit` | 60 requests/hour without a token. Wait, or `export GITHUB_TOKEN=<token>`. |
| Checksum failure in "Download pinned ... tarball" | The pin doesn't match the file. Run `scripts/update-pinned.py verify` to see which. |

## Adding another pinned tool

1. Add `<tool>_version`, `<tool>_arch_map` and `<tool>_checksums` to the
   role's `defaults/main.yml`.
2. Add an `include_role: pinned-tarball` task. Copy the eza one in
   `roles/common-software/tasks/main.yml`.
3. Add an entry to `TOOLS` in `scripts/update-pinned.py`.
4. `scripts/update-pinned.py verify` must report `ok` for it.
