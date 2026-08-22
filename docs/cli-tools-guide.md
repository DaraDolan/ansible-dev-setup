# The New Command-Line Toolkit

Four tools landed in Phase 4 — **fzf**, **bat**, **delta**, and **jq** — plus
keybindings that were wired earlier and are now live. None of them ask you to
change how you work; they upgrade things you already do every day: recalling
commands, opening files, reading diffs, poking at JSON. This guide is the
"why bother" and the ten things worth learning, tuned to your Laravel/Bgate
workflow.

## fzf — stop remembering, start fuzzy-matching

fzf is a fuzzy picker: give it a list, type a few characters *in any order*,
it narrows instantly. Three keybindings put it under your fingers in every
shell:

### `Ctrl-R` — command history (the one you'll use hourly)

The old `Ctrl-R` needed you to remember how a command *started*. Now type any
fragments you remember, in any order:

```
Ctrl-R  then type:  sail mig
```

…matches `sail artisan migrate:fresh --seed` from three weeks ago. Fragments
match anywhere: `ansible zsh` finds `ansible-playbook playbook.yml --tags zsh -K`.
Enter runs it; Tab puts it on the command line to edit first. With 50k lines
of shared history configured in Phase 2, your history is now a searchable
knowledge base of everything you've ever figured out.

### `Ctrl-T` — drop a file path into the command you're typing

Type a command, hit `Ctrl-T` where the filename would go:

```
nvim <Ctrl-T>        # fuzzy-pick the file, with a bat preview pane
git add <Ctrl-T>     # Tab marks several files, Enter inserts them all
```

It's configured to find files with `fd`, which **respects .gitignore** — so
`vendor/` and `node_modules/` never clutter the picker — and the highlighted
file previews with syntax highlighting on the right, so you confirm it's the
right file before touching Enter.

### `Alt-C` — cd without typing paths

`Alt-C` fuzzy-picks any *subdirectory* below you and cds into it. Pairs with
zoxide: `z` for places you've been before, `Alt-C` for exploring downward
from here. And `zi` (zoxide's interactive mode) now works too — it uses fzf
to pick from every directory you've ever visited.

### The habit to build

Anything that outputs a list can feed fzf:

```bash
git branch | fzf                       # pick a branch name
gh pr list | fzf                       # pick a PR
```

When you catch yourself scrolling terminal output looking for a line —
that's an fzf moment.

## bat — cat that shows you what you're looking at

`bat file.php` instead of `cat file.php`: syntax highlighting, line numbers,
git change markers in the gutter (`~` modified, `+` added since last commit),
and it pages long files automatically. Perfect for the "what's in this file?
(without opening the editor)" moment when exploring a codebase.

```bash
bat routes/web.php                # highlighted, numbered, paged
bat -A suspicious.txt             # reveal tabs, spaces, invisible characters
bat config/*.php                  # several files, with headers between them
```

When piped, bat outputs plain text — safe to use anywhere cat works. Ubuntu
installs the binary as `batcat`; the playbook symlinks it so plain `bat`
works.

## delta — git output you can actually read

Nothing to learn: `git diff`, `git log -p`, `git show`, and `git blame` now
come out syntax-highlighted with word-level change emphasis — within a
changed line, only the words that differ get flagged, so a one-variable edit
in a long line jumps out instead of hiding.

The one keybinding: in a multi-file diff, **`n` jumps to the next file,
`N` back** — no more holding space through files you don't care about.
`q` quits, `/` searches, like any pager.

Try the side-by-side view for review sessions:

```bash
git -c delta.side-by-side=true diff       # once
git config --global delta.side-by-side true   # forever, if you like it
```

This complements rather than replaces your other git views: gitsigns for
hunks in the editor, `<leader>gg` lazygit for staging, delta for reading
diffs at the terminal.

## jq — take JSON apart at the command line

The sleeper hit for the Bgate job: data pipelines, cloud CLIs and APIs all
speak JSON, and jq is how you interrogate it without opening an editor. The
mental model: **`.` is the current thing; everything else drills in.**

```bash
# Pretty-print anything (the gateway drug)
curl -s https://api.example.com/orders | jq .

# Drill into fields:  .field   .field[]   .a.b.c
jq '.require' composer.json               # your project's dependencies
php artisan route:list --json | jq '.[].uri'      # every route URI

# Filter with select()
php artisan route:list --json | jq '.[] | select(.method == "POST")'

# Reshape: build a smaller object from a bigger one
az webapp list | jq '.[] | {name, state}'          # Azure apps, two fields
gcloud projects list --format=json | jq '.[].projectId'

# Count things
jq 'length' response.json
```

Those four moves — pretty-print, drill (`.a[].b`), filter (`select`),
reshape (`{a, b}`) — cover 90% of real use. It also composes with fzf:

```bash
php artisan route:list --json | jq -r '.[].uri' | fzf
```

## Cheat card

| | |
|---|---|
| **fzf** | `Ctrl-R` history · `Ctrl-T` file into command (Tab = multi-select) · `Alt-C` cd down · `zi` zoxide picker · `anything \| fzf` |
| **bat** | `bat file` view · `bat -A file` invisibles · plain when piped · gutter shows uncommitted changes |
| **delta** | automatic in `git diff/log/show/blame` · `n`/`N` next/prev file · `q` quit · side-by-side via `delta.side-by-side` |
| **jq** | `jq .` pretty · `.a[].b` drill · `select(.x == "y")` filter · `{a, b}` reshape · `-r` raw strings for piping |

## Where this all lives

Everything here is managed by the repo: the fzf keybindings and fd/bat
integration in `roles/zsh/files/zshrc`, delta's git config in
`roles/common-software/tasks/main.yml`, versions pinned in
`roles/common-software/defaults/main.yml`. Change it there, re-run the
playbook — same rule as everything else in this setup.
