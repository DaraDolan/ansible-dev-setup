# Tmux, For The Way You Actually Work

You currently run several Windows Terminal tabs — one for Neovim, one for
Claude, one for git, one for a server. Tmux replaces that with **one tab that
contains everything**, driven from the keyboard, that also **survives the
terminal closing**. Close the window, reopen it, `tmux attach` — Claude is
still mid-conversation, the server is still running, your editor never
noticed.

Your config is managed by this repo (`roles/zsh/files/tmux.conf`) and is
deliberately close to stock, so any tmux guide on the internet matches your
setup. Mouse support is on — you can click between panes and scroll with the
wheel while your hands learn the keys.

## The mental model (30 seconds)

| Tmux word | What it replaces in your head |
|---|---|
| **Session** | "Everything open for one project" — bombooks, developer-setup, a Bgate product |
| **Window** | One terminal tab — numbered 1, 2, 3 in the status bar at the bottom |
| **Pane** | A split inside a window — editor left, test output right |

Every command starts with the **prefix**: `Ctrl-b`, then release, then the
key. Written as `C-b c` below.

## The eight keys that get you productive

| Keys | Does |
|---|---|
| `C-b c` | New window (opens in your current directory) |
| `C-b 1` … `C-b 5` | Jump straight to window 1–5 |
| `C-b l` | Toggle between your two most recent windows — **the workhorse** |
| `C-b \|` | Split side-by-side |
| `C-b -` | Split top/bottom |
| `C-b h/j/k/l` | Move between panes, vim-style |
| `C-b d` | **Detach** — everything keeps running in the background |
| `C-b ,` | Rename the current window (names show in the status bar) |

That's it. `C-b l` alone replaces 80% of your tab-clicking.

## Your daily layout, as commands

Starting work on a project (bombooks as the example):

```bash
z api                      # zoxide gets you there
tmux new -s bombooks       # named session; the name shows bottom-left
```

Then build your workspace — about fifteen seconds:

```
C-b ,  → type "code"       # window 1: nvim .
C-b c  → claude            # window 2, rename it "ai"     (C-b ,)
C-b c  → lazygit           # window 3, rename it "git"
C-b c  → sail up           # window 4, rename it "server"
```

Now `C-b 1` is your editor, `C-b 2` is Claude, `C-b 3` is git, `C-b 4` is
logs. `C-b l` bounces between the last two you touched — editor ↔ Claude is
the loop you'll live in.

End of day (or terminal crash, same thing now):

```bash
C-b d                      # detach — nothing stops
tmux ls                    # later: list sessions
tmux attach -t bombooks    # everything exactly as you left it
```

Run a second project in parallel as its own session (`tmux new -s setup`)
and switch sessions with `C-b s` — a picker of every session and window.

## Learning a new codebase (the Bgate day-one recipe)

One window, three panes:

```
C-b |          # nvim left, exploration right
C-b -          # split the right side: shell top, notes/tests bottom
```

- **Left pane**: `nvim .` — Telescope (`<leader>ff`, `<leader>/`) for
  structure and content search.
- **Top-right**: a shell for `rg`, `fd`, and `bat` spelunking — search a
  concept, `bat` the file it lands in, open it properly in the left pane.
- **Bottom-right**: `lazygit` — the commit history of a file
  is often the fastest explanation of *why* it looks that way.

Then a second window (`C-b c`) running `claude`, and `C-b l` flips between
"reading the code" and "asking about the code". Claude keeps its full context
while you explore — no more losing the thread because a tab got closed.

Working through a diff is the same shape: lazygit (or `git diff`, paged
through delta) in one pane, the file open in nvim beside it.

## Scrolling and copying

Wheel-scroll works anywhere (mouse is on). For keyboard scrollback:
`C-b [` enters copy mode — move with vim keys, `v` starts a selection,
`y` copies **to the system clipboard** and exits. `q` bails out.

## When something looks wrong

- **Prompt or colors look off inside tmux?** The config forces true color;
  reload it with `C-b r` after any change.
- **Changed the config?** Edit `roles/zsh/files/tmux.conf` in the repo, run
  the playbook with `--tags zsh`, then `C-b r` inside running sessions.
- **Killed a window by accident?** Panes/windows die when their program
  exits — there's no undo, but `exit`/`C-d` is the polite way out.
- **Session gone after a Windows reboot?** WSL itself was shut down —
  tmux survives closed terminals, not a stopped machine.

## The full cheat card

| | Keys |
|---|---|
| **Windows** | `C-b c` new · `C-b 1-9` jump · `C-b l` last · `C-b ,` rename · `C-b &` kill |
| **Panes** | `C-b \|` vsplit · `C-b -` hsplit · `C-b h/j/k/l` move · `C-b z` zoom one pane full-screen · `C-b x` kill |
| **Sessions** | `tmux new -s name` · `C-b d` detach · `tmux attach -t name` · `C-b s` switcher · `tmux ls` |
| **Scrollback** | `C-b [` enter · `v` select · `y` copy+exit · `q` quit |
| **Config** | `C-b r` reload · lives in `roles/zsh/files/tmux.conf` |

`C-b z` (zoom) deserves a special mention: it makes any pane temporarily
full-screen — perfect for going deep in nvim, then `C-b z` again to bring
the surrounding panes back.
