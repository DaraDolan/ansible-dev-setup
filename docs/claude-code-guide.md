# Claude Code, Without Reaching For The Mouse

Claude Code can be driven entirely from the keyboard: vim keys in the prompt,
and `less`-style navigation through everything Claude has written. The point
of this guide is to make the mouse wheel optional. Read a long response with
`{` and `j` instead of scrolling for it.

Your settings are managed by this repo. `claude_code_settings` in
`roles/common-software/defaults/main.yml` is **merged** into
`~/.claude/settings.json`, so anything you or Claude Code add by hand
survives a playbook run. It turns on vim editor mode with `jj` as Escape.

## The mental model (30 seconds)

| Place | What it is | How you get there |
|---|---|---|
| **The prompt** | Where you type. Vim INSERT/NORMAL modes, like a one-buffer nvim | You start here |
| **The transcript viewer** | A read-only, `less`-style view of the whole conversation | `Ctrl+O`, then `q` to come back |

Your vim mode and cursor position survive the round trip: leave the prompt in
NORMAL mode, press `Ctrl+O`, read, press `q`, and you're back where you were.

## First, check the renderer

The transcript keys below need **fullscreen rendering**. Run `/tui` to see
which one is active:

- **Says fullscreen:** you're set.
- **Says classic:** run `/tui fullscreen`. It relaunches with the
  conversation intact and remembers the choice. Telemetry is off in this
  setup, and sessions without telemetry start in classic by default, so
  expect to do this once per machine.

`/tui default` switches back if fullscreen ever misbehaves.

## Reading a response: the four keys that matter

Claude finishes. Its answer has scrolled off the top. Instead of reaching for
the wheel:

```
Ctrl+O      open the transcript viewer
{           jump back to your last prompt (the top of Claude's reply)
j j j…      read down, a line at a time, or Ctrl+d for half a page
q           back to the prompt
```

`{` / `}` jump between **your prompts**, like vim paragraph motion. That makes
them the fastest way to move a whole exchange at a time. Hold `{` to walk back
through the session one question at a time.

## Transcript viewer keys

| Key | Does |
|---|---|
| `{` / `}` | Previous / next prompt: **the workhorse** |
| `j` / `k` | One line down / up |
| `Ctrl+d` / `Ctrl+u` | Half a page down / up |
| `Ctrl+f` / `Ctrl+b` (or `Space` / `b`) | Full page down / up |
| `g` / `G` | Top / bottom of the conversation |
| `/` | Search. `Enter` accepts, `Esc` cancels and puts you back where you were |
| `n` / `N` | Next / previous match (still works after closing the search bar) |
| `v` | Open the whole conversation in `$EDITOR`, which is nvim |
| `[` | Dump the conversation into the terminal's own scrollback, for tmux copy mode |
| `?` | Show these shortcuts |
| `q`, `Esc` or `Ctrl+O` | Back to the prompt |

`v` is worth remembering for long sessions: you get the whole transcript in
nvim, with your own search, marks and yank, and `:q` drops you back.

## Scrolling without opening the transcript

From the prompt itself, in fullscreen:

| Key | Does |
|---|---|
| `PgUp` / `PgDn` | Half a screen up / down |
| `Ctrl+Home` | Start of the conversation |
| `Ctrl+End` | Back to the bottom, and resume auto-follow |

Scrolling up pauses auto-follow, so new output won't drag you back down.
These are rebindable in `~/.claude/keybindings.json` (`scroll:*` actions) if
you want them closer to home row.

## Vim mode in the prompt

Normal vim muscle memory mostly works. The essentials:

| Keys | Does |
|---|---|
| `jj` or `Esc` | INSERT → NORMAL (`jj` must be typed within 1 second; pause between the two keys to type a literal `jj`) |
| `i` `a` `I` `A` `o` `O` | Back into INSERT, as in vim |
| `w` `b` `e` `0` `$` `^` `f{c}` `t{c}` | Motions, as in vim |
| `gg` / `G` | Start / end of the prompt |
| `v` / `V` | Visual selection |
| `j` / `k` at the first or last line | Step through your **prompt history** |
| `/` (NORMAL) | Search prompt history, same as `Ctrl+R` |

Gotcha: `/` in NORMAL mode searches history, it doesn't open the slash
command menu. For `/commands`, be in INSERT mode first (`i`, then `/`).

## Other keys worth knowing

| Key | Does |
|---|---|
| `Esc` (while Claude works) | Interrupt so you can redirect; work done so far is kept |
| `Esc Esc` (empty prompt) | Rewind menu: restore code or conversation to an earlier point |
| `Ctrl+G` | Write the prompt in nvim, for long or careful prompts |
| `Ctrl+S` | Stash the current draft; press again on an empty prompt to restore it |
| `Shift+Tab` | Cycle permission modes (Manual → accept edits → plan …) |
| `!` at the start | Shell mode: run a command, Claude sees and responds to the output |
| `Ctrl+B` | Send a running command or agent to the background (**press twice in tmux**) |

## Claude Code inside tmux

Fullscreen Claude draws on the alternate screen, the way nvim does, so
`C-b [` copy mode sees nothing useful. Use `Ctrl+O` and the keys above
instead. If you really want tmux copy mode, press `[` inside the transcript
viewer first to push the conversation into the scrollback.

## When something looks wrong

- **`{`, `j`, `/` do nothing in `Ctrl+O`?** You're on the classic renderer.
  Run `/tui fullscreen`.
- **Screen garbled or half blank?** `Ctrl+L` redraws it, keeping everything.
- **Vim mode or `jj` gone?** Check `~/.claude/settings.json` has
  `"editorMode": "vim"`, or re-apply with
  `ansible-playbook playbook.yml -e @personal-config.yml --tags claude -K`.
  The `jj` remap only works from user settings, not a project's
  `.claude/settings.json`.
- **Want a new setting on every machine?** Add it to `claude_code_settings` in
  `roles/common-software/defaults/main.yml` and re-run with `--tags claude`.

## The full cheat card

| | Keys |
|---|---|
| **Read a reply** | `Ctrl+O` → `{` → `j`/`Ctrl+d` → `q` |
| **Transcript** | `{ }` prompts · `j k` line · `C-d C-u` half page · `g G` ends · `/ n N` search · `v` nvim · `q` out |
| **Prompt view** | `PgUp PgDn` scroll · `Ctrl+Home` top · `Ctrl+End` bottom + follow |
| **Prompt (vim)** | `jj` NORMAL · `j k` at edges = history · `/` history search · `Ctrl+G` edit in nvim |
| **Control** | `Esc` interrupt · `Esc Esc` rewind · `Shift+Tab` mode · `Ctrl+S` stash |
| **Renderer** | `/tui` check · `/tui fullscreen` · `/tui default` · `Ctrl+L` redraw |
