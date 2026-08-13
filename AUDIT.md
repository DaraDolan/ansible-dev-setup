# developer-setup — Portability & Structure Audit

**Date:** 2026-08-13
**Branch audited:** `investigate-bgate`, originally at `db2687f`
**Context:** New job starts 28 September (~6 weeks out). Target OS unknown — Ubuntu, macOS, or Windows+WSL2.

Findings marked **[verified]** were confirmed by running commands on this machine, not inferred from reading.

Findings marked **✅ FIXED** were remediated on this branch after the audit was
written. The original finding text is left intact as the record of what was
wrong; the annotation says what changed.

---

## Remediation Status

A first batch of fixes has landed on this branch. Everything below was applied
and then verified by a real `ansible-playbook --tags user` run (74 ok,
18 changed, 0 failed) plus targeted checks.

| Audit ref | Finding | Status |
|---|---|---|
| §2.1 | No `requirements.yml` for `community.general` | ✅ Fixed |
| §2.1–2.2 | macOS half-installs silently | ⚠️ Guarded, not fixed — `playbook.yml` now asserts Debian and halts. macOS work deliberately deferred. |
| §2.3 | Neovim via snap (needs systemd, absent on hardened images) | ✅ Fixed — pinned static tarball into `$HOME` |
| §2.6 | Three roles fight over `~/.zshrc` | ✅ Fixed — `roles/zsh` is sole owner, verified by parsing all role tasks |
| §3.3 | Nothing version-pinned | ◐ Partial — `lazy-lock.json` committed (59 plugins), Neovim + lazygit pinned with sha256. Node/npm globals still unpinned. |
| §4.1 | Intelephense licence key in git history | ❌ **Still open.** Needs vendor rotation. |
| §4.5 | Invalid `settings.json` keys | ✅ Fixed — verified against docs first; `statusLine`/`enabledPlugins` confirmed valid and kept |
| §5.3 | pint / phpstan / eslint_d / lazygit missing | ✅ Fixed — all four installed and verified resolvable from inside Neovim |
| §5.4 | Keymap collisions | ✅ Fixed — 4 resolved (3 audited + `<C-k>` found during the work); detector reports 0/134 remaining |
| §8 item 3 | No-sudo path for locked-down machines | ◐ Partial — `user` tag added across 71 tasks; `bootstrap.sh` not yet written |

**Not yet touched:** §3.1/§3.2 idempotency, §3.4 brittle patching, §3.5
`update-config.yml` drift, §5.1/§5.2/§5.5/§5.6 dead weight, and the entire
`harness` layer (§7).

**Known verification gaps:** the Composer `~/.local/bin` path skipped on this
machine because Composer already existed at `/usr/local/bin`; the mechanism was
tested separately but has not run for real. The sudo half of the playbook
(apt packages, third-party repos, Playwright browsers) remains unexercised —
a clean-container run is the only way to settle it.

---

## 1. Current Structure

### Entry points

| File | Role |
|---|---|
| `playbook.yml` (10 lines) | The only real playbook. `hosts: all`, `become: yes` at play level, 4 active roles + 1 commented out. |
| `update-config.yml` (38 lines) | Ad-hoc playbook that re-copies Neovim config without reinstalling packages. Duplicates logic from the neovim role. |
| `scripts/dev-setup.sh` | Bash wrapper — checks sudo, installs Ansible, runs the playbook. |
| `test-setup.sh` | Post-install smoke test (checks binaries, PHP extensions). |
| `Dockerfile` / `docker-compose.yml` | Ubuntu 22.04 container for testing the playbook. |
| `ansible.cfg` | 4 lines: inventory path, roles path, no retry files. |
| `inventory/hosts.yml` | Single host: `localhost` with `ansible_connection: local`. |

### Role graph

```
playbook.yml (become: yes)
├── common-software   tags: common, software, python, playwright     725 lines
├── zsh               tags: zsh, shell                                56 lines
├── neovim            tags: neovim, editor, python                   293 lines
├── laravel           tags: laravel, php                             102 lines
└── aws-codecommit    tags: aws, codecommit, git       ← COMMENTED OUT (playbook.yml:10)
```

There are no role dependencies (`roles/neovim/meta/main.yml` declares `dependencies: []`), but there are **implicit** ones: `neovim` needs `uv` and `mise` from `common-software`; `laravel` needs `php` from `common-software`; both `common-software` and `laravel` append to `~/.zshrc`, which the `zsh` role overwrites wholesale. Ordering is load-bearing and undocumented.

### Variable layers

| Layer | Location | Contents |
|---|---|---|
| Role defaults | `roles/common-software/defaults/main.yml` | Git identity, `configure_git`, `install_playwright` |
| OS vars | `roles/*/vars/{Debian,Darwin}.yml` | Package name lists only |
| User override | `personal-config.yml` (gitignored) | Passed via `-e @personal-config.yml` |

There is no `group_vars/`, no `host_vars/`, no `requirements.yml`, and no vault. `common-software` is the only role with a `defaults/`; `zsh`, `neovim`, and `laravel` have none, so everything in them is hardcoded.

### Config-file inventory

- **Neovim** (`roles/neovim/files/`): `init.lua`, `lua/core/{init,options,keymaps,autocmds}.lua` (211-line keymap file), `lua/plugins/{init,copilot}.lua` (1240-line plugin spec), 6 snippet JSON files.
- **Zsh** (`roles/zsh/files/`): `zshrc`, `zinit.zsh`, `p10k.zsh` (~1700 generated lines).
- **Claude** (`roles/common-software/files/`): `claude-settings.json`, `statusline-command.sh`, `claude-commands/commit.md`, `claude-memory/preferences.md`.
- **Laravel** (`roles/laravel/files/`): `laravel-aliases.sh`.
- **Docs**: 26 markdown files under `docs/`, plus a 425-line `CLAUDE.md`.

---

## 2. Portability Risks

### 2.1 Critical — hard failures on macOS

**The `zsh` role has zero OS conditionals.** Every task runs on every platform:

- `roles/zsh/tasks/main.yml:2-5` — `apt: name=zsh`. The `apt` module does not exist on macOS; this aborts the play.
- `roles/zsh/tasks/main.yml:7-11` — sets login shell to `/usr/bin/zsh`. macOS ships zsh at `/bin/zsh`; Homebrew's is `/opt/homebrew/bin/zsh`. Setting a nonexistent shell can lock you out of terminal sessions.
- `roles/zsh/tasks/main.yml:50-56` — appends `/snap/bin` to `PATH` unconditionally. Junk on macOS, junk on any snapless Linux.

**`group:` set to the username.** Every `file:`/`copy:` task uses `group: "{{ lookup('env', 'USER') }}"` (e.g. `roles/neovim/tasks/main.yml:121-122`, `roles/common-software/tasks/main.yml:142-143`). Debian creates a per-user group matching the username; **macOS does not** — the primary group is `staff`. Every one of these tasks fails on macOS.

**`/usr/bin/php` hardcoded.** `roles/laravel/tasks/main.yml:19` runs the Composer installer with `/usr/bin/php`. On macOS that's the (removed since Monterey) system PHP; Homebrew installs to `/opt/homebrew/bin/php`. Composer install fails, and then Pint, Artisan, and the `php` LSP path all fall over.

**No `requirements.yml`.** The playbook uses `homebrew`, `snap`, and `git_config` — all in the `community.general` collection, none in `ansible-core`. On a fresh macOS with `pip install ansible-core` (or a corporate-managed Ansible), these modules are simply missing. Nothing in the repo declares or installs the dependency. **[verified]** local Ansible is `core 2.16.3`.

> **✅ FIXED.** `requirements.yml` added, pinning `community.general >=8.3.0,<12.0.0`,
> with the consuming modules documented inline. README prerequisites updated.

### 2.2 Critical — silent no-ops and half-installs on macOS

**`roles/common-software/vars/Darwin.yml` is a 7-package stub** against 29 packages for Debian:

```yaml
# Darwin.yml           # Debian.yml has, additionally:
git, curl, wget, zsh,  #   build-essential, php + 14 php-* extensions,
python, node, glow     #   ripgrep, fd-find, software-properties-common,
                       #   apt-transport-https, ca-certificates, python3-venv
```

On macOS you get **no PHP, no ripgrep, no fd, no build toolchain**. Nothing errors. The playbook reports green and you have no Laravel environment, and Telescope's file finder (`find_command = {"rg", ...}`, `plugins/init.lua:102`) silently returns nothing.

**Every apt-repo install is Debian-only with no macOS equivalent:**

| Tool | Debian path | macOS path |
|---|---|---|
| GitHub CLI (`gh`) | `common-software:509-556` (first-party apt repo) | **none** |
| Terraform | `common-software:564-610` | `common-software:612-618` ✓ |
| glow | `common-software:620-662` (Charm apt repo) | in `Darwin.yml` package list ✓ |
| Neovim | snap (`neovim:37-43`) | `homebrew` ✓ |
| fzf, luarocks, perl, ruby | `neovim:77-113` | **none** |
| PHP + extensions | `Debian.yml` | **none** |

`gh` is the one that will bite hardest — it's assumed by the git workflow docs and by Claude Code's GitHub plugin (`claude-settings.json`).

### 2.3 High — the snap dependency for Neovim

`roles/neovim/tasks/main.yml:29-43` deliberately removes apt Neovim and installs the snap. This is the single most fragile install in the repo:

- **macOS**: no snap (task is guarded, so Neovim comes from Homebrew — fine).
- **WSL2**: snapd requires systemd, which is opt-in via `/etc/wsl.conf` (`systemd=true`) and is **not managed by this repo**. On a fresh corporate WSL2 image with systemd off, `snap install nvim` fails, and then every downstream task (`nvim --headless "+Lazy sync"`, `TSUpdate`, `checkhealth`) fails or hangs. **[verified]** it works here because this machine already has systemd + snapd.
- **Corporate Ubuntu**: many hardened/managed images have snapd removed by policy.

> **✅ FIXED.** Neovim now installs from the official static tarball, pinned to
> `v0.12.4` with sha256 sums computed from the artefacts (upstream publishes no
> checksum file for these assets). Extracts to
> `~/.local/share/nvim-releases/<version>`, symlinked from `~/.local/bin/nvim`.
> Needs neither systemd nor sudo, so it works under `--tags user`.
> Verified: `VIMRUNTIME` resolves correctly through the symlink, and the stale
> snap has been removed. Version and checksums live in
> `roles/neovim/defaults/main.yml`.

### 2.4 Medium — Windows/WSL2 interop assumptions

- `roles/common-software/tasks/main.yml:686-725` — win32yank download for clipboard support. Correctly guarded on `is_wsl2`. **But there is no non-WSL2 clipboard provider**: no `xclip`/`xsel`/`wl-clipboard` in `Debian.yml`, so `opt.clipboard = "unnamedplus"` (`options.lua:22`) silently does nothing on native Linux. Yank-to-system-clipboard just fails quietly.
- `roles/zsh/files/zshrc:66-72` — Ollama aliased to the Windows binary under `/mnt/c/Users/*/AppData/Local/`. Correctly guarded on `grep -qi microsoft /proc/version`. **But** `codecompanion.nvim` is hardwired to the Ollama adapter (`plugins/init.lua:1216-1233`) and Ollama is never installed by the playbook on any platform. On macOS or native Linux, `<leader>ac` opens a chat window that silently fails to connect.

### 2.5 Medium — macOS-only commands in a Linux-targeted zshrc (reverse portability)

`roles/zsh/files/zshrc`:
- `:61` `alias o="open ."` — `open` is macOS; on Linux it's `xdg-open`.
- `:63` `alias cwd="pwd && pwd | pbcopy && ..."` — `pbcopy` is macOS-only. On Linux this prints "Copied to clipboard 📁" while copying nothing.

The zshrc is a static file copied verbatim to both platforms. It needs to be a template.

### 2.6 Medium — `~/.zshrc` is written by three roles, and one destroys the others

Role order is `common-software → zsh → neovim → laravel` (`playbook.yml:6-9`).

1. `common-software:216-230` appends `export PATH="$HOME/.local/bin:$PATH"` to `~/.zshrc` and `~/.bashrc`.
2. `zsh:38-42` then **copies `files/zshrc` over `~/.zshrc` with default `force: yes`** — deleting step 1's line.
3. `laravel:49-103` then appends Composer PATH + aliases, which survive.

Net effect: `common-software`'s zshrc edit is discarded every single run. It's masked because the copied `zshrc:34` already exports `~/.local/bin`, but the task is dead code that reports "changed" forever. This also means **any hand-edit to `~/.zshrc` is destroyed on every playbook run** without warning.

> **✅ FIXED.** `roles/zsh` is now the sole writer. The competing `lineinfile`
> tasks in `common-software` (UV PATH), `laravel` (Composer PATH, alias
> sourcing) and `zsh` itself (`/snap/bin`) were removed, with a comment at each
> site explaining why. Their content moved into `roles/zsh/files/zshrc`, which
> now carries a MANAGED BY ANSIBLE header. `/snap/bin` is appended rather than
> prepended so a leftover snap cannot shadow `~/.local/bin`.
> Verified by parsing every role's tasks: exactly 1 writer to `~/.zshrc`.

### 2.7 Low — control-node vs target-node assumptions

`lookup('env', 'HOME')` and `lookup('env', 'USER')` are used ~40 times. Lookups execute on the **control** node, not the target. This is correct only because `inventory/hosts.yml` is `localhost` + `ansible_connection: local`. The moment you point this at a remote host (or run it under `become` with a different target user), every path resolves to the wrong home directory. `ansible_env.HOME` / `ansible_user_id` would be correct.

Related: the play sets `become: yes` globally and then negates it with `become: false` on ~35 individual tasks. Inverting this (`become: false` at play level, `become: true` where needed) would be safer and would make the repo usable on a machine where you have **no sudo at all** — a realistic corporate scenario worth designing for.

---

## 3. Idempotency Problems

### 3.1 `shell`/`command` with no `creates` or `changed_when`

| Location | Task | Problem |
|---|---|---|
| `common-software:5-10` | `apt clean && apt update` | Always "changed". Should be `apt: update_cache=yes cache_valid_time=3600`. |
| `common-software:52-57` | `rm -f .../ppa_neovim_ppa_unstable_jammy.list` | Hardcoded **`jammy`** filename. No-ops on noble/plucky/Debian. Cleanup cruft for a migration that already happened. |
| `neovim:93-96` | `cpanm -n Neovim::Ext` | No guard at all. Runs on every play, always "changed", takes minutes. **And the Perl provider is explicitly disabled** at `options.lua:9`. |
| `neovim:239-244` | `nvim --headless "+Lazy sync" +qa` | No `changed_when`. 300s timeout is optimistic on a fresh box doing a full plugin clone + Mason install. |
| `neovim:255-264` | `TSUpdate` with `-c "sleep 30"` | Timing-based synchronisation. Flaky by construction — parsers either aren't done or you waste 30s. |
| `zsh:21-24`, `zsh:27-30` | `curl \| bash` for zoxide/zinit | Has `creates`, so re-runs are safe. But `curl \| shell` swallows curl's exit code — a failed fetch pipes an empty script to a shell that exits 0. **[verified]** a broken fetch yields `pipeline_rc=0`. These can no-op silently and you'd never know. |
| `aws-codecommit:36-41` | `cd /tmp/aws && sudo ./install` | `creates:` is a Jinja conditional that evaluates to an **empty string** on the update path, disabling the guard. |

### 3.2 `changed_when: false` used to hide changes

`common-software` marks 10+ install tasks `changed_when: false` (mise install L266, corepack L279/L303, prettier L393, gemini-cli L417, tree-sitter-cli L441, Playwright L464/L495; `neovim:75` npm neovim). These tasks *do* change the system. The playbook's change count is therefore meaningless — you cannot tell a no-op run from a run that reinstalled four global npm packages.

### 3.3 Nothing is version-pinned

| Thing | Current | Risk |
|---|---|---|
| Node | `node = "lts"` (`common-software:251-252`) | LTS rolls to a new major; the whole npm toolchain moves under you |
| npm globals | `prettier`, `@google/gemini-cli`, `tree-sitter-cli`, `@playwright/test`, `neovim` | all unpinned, all `latest` |
| Neovim | snap `stable` channel | auto-updates; the config uses `vim.lsp.config` (0.11+ API) and would break on a downgrade |
| lazy.nvim | `version: stable` ✓ | the one pin in the repo |
| All ~50 Neovim plugins | no `commit`/`version` except LuaSnip (`v2.*`), neo-tree (`v3.x`), harpoon (`harpoon2`) | no `lazy-lock.json` is committed, so **two machines provisioned a week apart get different plugin versions** |
| Mason LSP servers | `auto_update = false` ✓ but no version pins | |
| Claude Code | native installer, self-updating | |
| win32yank | `v0.1.1` ✓ | |
| uv, mise, zoxide, zinit | install scripts, always latest | |

**The missing `lazy-lock.json` is the highest-impact pin.** It's the difference between "my editor works identically on both machines" and "it worked yesterday."

> **◐ PARTIALLY FIXED.** `roles/neovim/files/lazy-lock.json` now pins all 59
> plugins and is deployed with `force: yes`. Critically, the install task moved
> from `Lazy sync` to `Lazy! restore` — sync was updating every plugin to its
> latest commit and rewriting the lockfile on every run, actively defeating the
> pin. Neovim and lazygit are now pinned with sha256 checksums.
> **Still unpinned:** Node (`lts`), all npm globals, Mason LSP servers, uv,
> mise, zoxide, zinit, Claude Code.
>
> Workflow note: after `:Lazy update` locally, copy the lockfile back with
> `cp ~/.config/nvim/lazy-lock.json roles/neovim/files/lazy-lock.json`.

### 3.4 Brittle in-place patching

- `neovim:267-273` — `replace:` on `~/.local/share/nvim/lazy/nvim-lspconfig/lsp/ts_ls.lua`, patching an upstream bug. Wrapped in `ignore_errors: yes`, so when upstream fixes or renames the file, this silently stops applying and nobody notices. It also gets reverted every time lazy.nvim updates the plugin.
- `neovim:285-294` — `blockinfile` injects `vim.g.python3_host_prog` into `lua/core/init.lua`, a file that was **copied from the repo three tasks earlier**. This creates permanent drift between repo and machine. It's also redundant: `options.lua:5` already sets the same variable. And `update-config.yml` re-copies `lua/core/` without re-adding the block, so running the "quick update" playbook silently removes it.

### 3.5 `update-config.yml` has already drifted from the neovim role

| Copied by | `init.lua` | `lua/core/` | `lua/plugins/` | `python.json` |
|---|---|---|---|---|
| `roles/neovim` (L177-210) | ✓ | ✓ | ✓ | ✓ |
| `update-config.yml` (L18-38) | ✗ | ✓ | ✓ | ✗ |

Two copies of the same logic, already out of sync. `update-config.yml` also registers `whoami` into `username_result` and never uses it, and shells out for `$HOME` instead of using facts.

### 3.6 Ordering bug: symlink before parent directory

`common-software:20-26` creates `~/.local/bin/fd` → `/usr/bin/fdfind`. The `file` module does **not** create parent directories for `state: link`. `~/.local/bin` is only explicitly created at L694 (and only when `is_wsl2`), or as a side-effect of the uv installer at L210. On a genuinely fresh non-WSL2 Debian box, this task runs first and fails.

---

## 4. Secrets & Machine-Specific Values in Git

### 4.1 Committed secret — act on this first

**`roles/neovim/tasks/main.yml:158-165` writes a hardcoded Intelephense Premium licence key (`00QWFAL4F6OR8QP`) into the repo.**

It's a paid per-user licence, in plaintext, in git history, on a repo whose remote is `origin/main`. Removing the line does not remediate it — the value is in every historical commit.

Required: **rotate the key with Intelephense**, then move the new one to `ansible-vault` or an env-var lookup. The consuming code (`plugins/init.lua:383-387`) already reads it from `~/.config/intelephense/licence.txt` at runtime, which is the right shape — only the source of the value is wrong.

### 4.2 Machine-specific values

| Location | Value | Issue |
|---|---|---|
| `test-setup.sh:232` | `/home/dara/development/ansible-dev-setup/test-setup.sh` | Absolute path to a directory that doesn't exist on this machine (repo lives at `~/code/developer-setup`). Dead on arrival everywhere. |
| `roles/zsh/files/zshrc:64` | `alias os='cd ~/code/php/open-source'` | Personal directory layout |
| `roles/zsh/files/zshrc:66-72` | `/mnt/c/Users/*/AppData/Local/Programs/Ollama/` | Windows-host path |
| `roles/laravel/tasks/main.yml:66-73` | creates `~/development/projects` | Conflicts with actual layout (`~/code/...`). Aliases `dev`/`projects` (`laravel-aliases.sh:16-17`) point at the wrong tree. |
| `roles/neovim/meta/main.yml:3` | `author: Your Name` | Unfilled template |

### 4.3 Config that will be wrong at the new job

`roles/common-software/files/claude-memory/preferences.md` is deployed to `~/.claude/memory/` and asserts:

> "I work on WSL2 Ubuntu across two home machines kept in sync via Ansible"

This is deployed with **`force: no`** (`common-software:203`), so once written it is *never* updated by subsequent runs. On the work machine it will be both wrong and unfixable-by-playbook. It needs to be a template driven by host vars.

### 4.4 Git identity defaults are dangerously quiet

`roles/common-software/defaults/main.yml:9-10`:

```yaml
git_user_name:  "{{ ansible_user_id | title }}"
git_user_email: "{{ ansible_user_id }}@example.com"
```

If you forget `-e @personal-config.yml`, the playbook silently sets your **global** git identity to `dara@example.com` and you push commits to your new employer's repos with a bogus author. Meanwhile `.gitignore:3` excludes `*-config.yml`, so `personal-config.yml` is never in the repo — on a new machine you must remember to recreate it from the example. Failure mode and safeguard are pointed in opposite directions.

Also: `.gitignore:3`'s `*-config.yml` glob is broader than intended. Any future legitimate file like `mcp-config.yml` or `work-config.yml` would be silently untracked.

### 4.5 Claude settings keys that appear to do nothing

`roles/common-software/files/claude-settings.json` sets `allowedTools: ["*"]`, `enableTelemetry: false`, and `ignorePatterns`. None of these match current Claude Code settings schema keys (permissions live under `permissions.allow`/`deny`; telemetry is controlled by env vars, which `zshrc:50-55` does correctly). These are almost certainly ignored silently. Worth validating against the current schema before carrying them forward — a permission model you believe is configured but isn't is worse than none.

> **✅ FIXED**, after checking the docs rather than assuming. All three of
> `allowedTools`, `enableTelemetry` and `ignorePatterns` are confirmed
> undocumented and were removed. Telemetry moved to the documented `env`
> mechanism (`CLAUDE_CODE_ENABLE_TELEMETRY`, `DISABLE_TELEMETRY`).
>
> `ignorePatterns` was **not** recreated as `permissions.deny` rules: its intent
> was noise filtering, which the tool already handles, and denying reads on
> `vendor/**` would block legitimate library inspection.
>
> The doc lookup also claimed `statusLine` and `enabledPlugins` were invalid.
> That contradicts observed behaviour — the statusline renders and the context7
> plugin loads — so both were kept. Treat that part of the lookup as unreliable,
> not the docs.

---

## 5. Dead Weight

### 5.1 Roles and infrastructure

- **`roles/aws-codecommit/`** — 140 lines + 2 var files, commented out of the playbook since it was added. AWS CodeCommit is closed to new customers. Delete.
- **`Dockerfile` + `docker-compose.yml`** — Ubuntu 22.04 test harness using `pip3 install ansible`, which fails on modern PEP-668 Debian. Not referenced by the README's main flow. Either fix as a real CI target (valuable, see §7) or delete.
- **`docs/finance-project/`** — 5 files of personal project documentation, unrelated to environment provisioning.
- **`nvim_treesitter_health.log`** — untracked working-tree cruft (ignored by `*.log`).

### 5.2 Installed, then explicitly disabled

`roles/neovim/tasks/main.yml:84-105` installs `perl`, `cpanminus`, `Neovim::Ext`, `ruby`, and `ruby-dev` — several minutes of build time per run (the `cpanm` task has no idempotency guard, §3.1). `roles/neovim/files/lua/core/options.lua:8-9` then sets:

```lua
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
```

Pure waste. `luarocks` (L77-82) and `fzf` (L108-113) are likewise unused — telescope-fzf-native is compiled from source at L246 and doesn't need the `fzf` binary.

### 5.3 Neovim config that assumes tools the playbook never installs

**[verified] on this machine — all four are missing:**

| Config | Expects | Actual | Failure mode |
|---|---|---|---|
| `conform.nvim` `php = { "pint" }` (`plugins/init.lua:663`) | `pint` | **MISSING** | Format-on-save silently falls back to LSP formatting for every PHP file |
| `nvim-lint` `php = { "phpstan" }` (`plugins/init.lua:572`) | `phpstan` | **MISSING** | Linting silently never runs |
| `nvim-lint` js/ts = `eslint_d` (`plugins/init.lua:568-571`) | `eslint_d` | **MISSING** | Same |
| `toggleterm` `<leader>gg` (`plugins/init.lua:1022-1028`) | `lazygit` | **MISSING** | Runtime error on keypress |

The Pint one matters most: **`CLAUDE.md:74` documents "Laravel Pint (installed globally via Ansible)"** and `roles/laravel/tasks/main.yml:31-37` has the install task **commented out**. The documentation asserts a capability the playbook removed.

> **✅ FIXED.** All four installed: Pint and PHPStan via `composer global`
> (replacing the commented-out block), `eslint_d` via the existing mise/npm
> pattern, lazygit as a checksum-pinned tarball into `~/.local/bin`.
>
> Both linters prefer a project-local `vendor/bin` copy and fall back to the
> global one, so these are backstops for projects that don't ship their own.
>
> Verified from inside a real Neovim session with a PHP buffer open:
> `pint=true phpstan=true lazygit=true conform=true`. The CLAUDE.md claim is
> now true and needed no edit.
>
> Related change: Composer itself moved from `/usr/local/bin` (sudo,
> hardcoded `/usr/bin/php`) to `~/.local/bin` (no sudo, `php` from PATH), so
> the Pint/PHPStan tasks actually work under `--tags user`. PHP itself still
> needs apt, so that tag delivers PHP tooling only where PHP already exists.

### 5.4 Keymap collisions (later binding silently wins)

`roles/neovim/files/lua/core/keymaps.lua` is loaded top-to-bottom, so the second definition overwrites the first:

| Key | First binding | Second binding (wins) |
|---|---|---|
| `<leader>cc` | L127 "Open project in Claude Code" | L165 catppuccin colorscheme |
| `<leader>tn` | L46 Test Nearest | L196 toggle line numbers |
| `<leader>tv` | L50 Test Visit | L171 vertical terminal |

The Claude Code launcher is dead — which matters given the harness goals. (`<leader>ai` from toggleterm at `plugins/init.lua:1036` still works.)

> **✅ FIXED**, and a fourth collision was found while making the change:
> `<C-k>` split-navigation was being overwritten by LSP signature help.
>
> | Key | Resolution |
> |---|---|
> | `<leader>cc` | Both `:!claude` mappings removed. `<leader>ai` (floating toggleterm) is the working binding; `<leader>ce` called `claude edit`, which is not a Claude Code subcommand. `<leader>cc` stays with catppuccin. |
> | `<leader>tn` / `<leader>tv` | UI toggles moved to `<leader>u*`, terminals to `<leader>T*`. `<leader>t*` is now vim-test's alone, restoring Test Nearest and Test Visit. |
> | `<C-k>` | Signature help moved to `gK`; split navigation restored. |
>
> A detector over all three Lua config files reports **0 exact collisions
> remaining out of 134 mappings**. Docs in `docs/neovim/keybindings.md`,
> `docs/README.md` and `docs/daily-workflow/README.md` updated to match.

### 5.5 Plugins configured but effectively inert

- **`tailwindcss-colorizer-cmp.nvim`** (`plugins/init.lua:621-628`) — `setup()` is called, but the plugin only does anything if it's wired into nvim-cmp's `formatting.format`. It isn't. Zero visible effect.
- **`vim-projectionist`** (L280) — installed, no projections defined anywhere.
- **`cmp_luasnip`** declared twice (L319 standalone, L513 as a cmp dependency).
- **`alpha-nvim` dashboard** (L830-878) — the `p` button calls `:Telescope projects`; the `telescope-project` extension is not installed. Broken button. The `s` (SessionRestore) button works, but `auto-session` is configured with `auto_restore_enabled = false`.
- **`codecompanion.nvim`** (L1210-1239) — hardwired to Ollama, which the playbook never installs on any platform (§2.4). This is the **third** AI assistant in the config alongside Copilot and Claude Code.
- **`markdown-preview.nvim`** (L321-325) — `build = "cd app && npm install"` requires `npm` on `PATH` during headless `Lazy sync`; the Ansible task at `neovim:239-244` doesn't export mise shims (unlike every other npm task in the repo, which does). Likely silently unbuilt.
- **Three colorschemes** — nord (active) + catppuccin + kanagawa (lazy).
- **Two file explorers** — neo-tree (`<leader>e`/`<leader>n`) + oil (`<leader>o`).
- **`vim-test`** (L290-299) configured for `phpunit` while `docs/testing/pest-guide.md` and `zshrc:79` standardise on Pest; also overlaps `laravel.nvim`'s test runner.

### 5.6 Shell dead weight

- `roles/zsh/files/zinit.zsh:8` and `:10` **both** load powerlevel10k — the second with `zinit ice depth=1`. Double-loaded prompt on every shell start.
- `roles/zsh/files/zshrc:6-18` — oh-my-zsh plugins for `tmux`, `tmuxinator` (tmux is never installed), `aws` (role disabled), `docker`, `docker-compose` (Docker is never installed).
- Both oh-my-zsh **and** zinit are loaded, which is a meaningful startup cost for overlapping functionality.

---

## 6. Proposed Restructure — `base` / `toolchain` / `harness`

### 6.1 Design principles

1. **OS dispatch at the task-include level, not with `when:` sprinkled per task.** `include_tasks: "packages-{{ ansible_os_family }}.yml"` fails loudly on an unsupported OS instead of no-opping through 700 lines.
2. **Privilege separation by tag.** Everything installable without sudo carries the `user` tag. `ansible-playbook site.yml --tags user` must fully work on a machine where you have no admin rights. This is the single most important hedge against an unknown corporate machine.
3. **Templates, not static file copies**, for anything containing a path, a hostname, or an OS-conditional (`zshrc`, `gitconfig`, `settings.json`, `AGENTS.md`).
4. **Facts, not lookups.** `ansible_env.HOME` / `ansible_user_id`, never `lookup('env', ...)`.
5. **One source of truth per config file.** Kill `update-config.yml`; replace with `--tags config`.

### 6.2 File tree

```
developer-setup/
├── ansible.cfg
├── requirements.yml                     # NEW — pins community.general, ansible.posix
├── site.yml                             # replaces playbook.yml
├── bootstrap.sh                         # NEW — installs ansible, clones, runs site.yml
├── inventory/hosts.yml
├── group_vars/
│   └── all/
│       ├── main.yml                     # shared defaults (versions, feature flags)
│       └── vault.yml                    # ansible-vault: intelephense key, tokens
├── host_vars/
│   ├── work.yml                         # NEW — work machine: no personal aliases, MCP off
│   └── home.yml                         # NEW — home machines
│
├── roles/
│   ├── base/                            # tag: base
│   │   ├── defaults/main.yml
│   │   ├── vars/{Debian,Darwin}.yml     # package NAME MAPS, kept at parity
│   │   ├── tasks/
│   │   │   ├── main.yml                 # dispatch + assert supported OS
│   │   │   ├── packages-Debian.yml
│   │   │   ├── packages-Darwin.yml
│   │   │   ├── locale.yml               # Debian only
│   │   │   ├── shell.yml                # zsh, omz, zinit, p10k    [tags: shell, user]
│   │   │   ├── clipboard.yml            # win32yank | wl-clipboard | pbcopy
│   │   │   └── fonts.yml                # Nerd Font, all 3 platforms
│   │   ├── templates/
│   │   │   ├── zshrc.j2                 # OS-conditional aliases, PATH, ollama block
│   │   │   ├── zshenv.j2
│   │   │   └── aliases.zsh.j2
│   │   └── files/p10k.zsh
│   │
│   ├── toolchain/                       # tag: toolchain
│   │   ├── defaults/main.yml            # ALL version pins live here
│   │   ├── vars/{Debian,Darwin}.yml
│   │   ├── tasks/
│   │   │   ├── main.yml
│   │   │   ├── git.yml                  # identity (asserted), aliases, delta
│   │   │   ├── php.yml                  # php+ext, composer (checksummed), pint, larastan
│   │   │   ├── node.yml                 # mise, node (pinned), corepack, npm globals
│   │   │   ├── python.yml               # uv
│   │   │   ├── cli.yml                  # rg, fd, gh, lazygit, glow, jq, fzf
│   │   │   ├── neovim-install.yml       # OS-appropriate: brew | mise | tarball
│   │   │   └── neovim-config.yml        # [tags: config] — replaces update-config.yml
│   │   ├── files/nvim/                  # moved verbatim from roles/neovim/files
│   │   │   ├── init.lua
│   │   │   ├── lazy-lock.json           # NEW — committed plugin pins
│   │   │   ├── lua/core/*.lua
│   │   │   ├── lua/plugins/*.lua
│   │   │   └── snippets/*.json
│   │   └── templates/gitconfig.j2
│   │
│   └── harness/                         # tag: harness       ← NEW LAYER
│       ├── defaults/main.yml
│       ├── tasks/
│       │   ├── main.yml
│       │   ├── agents.yml               # AGENTS.md + tool-specific pointers
│       │   ├── skills.yml               # ~/.claude/skills/*/SKILL.md
│       │   ├── mcp.yml                  # MCP servers, individually toggleable
│       │   ├── hooks.yml                # settings.json hooks + hook scripts
│       │   ├── commands.yml             # slash commands
│       │   └── review.yml               # Neogit/Diffview config + git review aliases
│       ├── templates/
│       │   ├── AGENTS.md.j2
│       │   ├── claude-settings.json.j2  # permissions, hooks, statusLine, env
│       │   ├── claude-memory.md.j2      # replaces the frozen preferences.md
│       │   └── mcp.json.j2
│       └── files/
│           ├── skills/
│           │   ├── review-agent-diff/SKILL.md
│           │   ├── laravel-conventions/SKILL.md
│           │   ├── pest-testing/SKILL.md
│           │   └── ansible-role/SKILL.md
│           ├── hooks/
│           │   ├── format-edited-file.sh
│           │   ├── guard-sensitive-paths.sh
│           │   └── guard-destructive-artisan.sh
│           ├── commands/commit.md
│           ├── statusline-command.sh
│           └── nvim/review.lua          # neogit + diffview + review keymaps
│
├── molecule/ or .github/workflows/      # OPTIONAL — replaces Dockerfile
└── docs/
```

### 6.3 Tag scheme

| Tag | Selects |
|---|---|
| `base` / `toolchain` / `harness` | whole layers |
| `user` | everything runnable **without sudo** — the no-admin fallback |
| `config` | config-file deployment only — replaces `update-config.yml` entirely |
| `shell`, `php`, `node`, `python`, `nvim`, `cli`, `git` | within toolchain |
| `agents`, `skills`, `mcp`, `hooks`, `review` | within harness |

Day-one command on an unknown machine:

```bash
./bootstrap.sh                                    # detects OS, installs ansible, runs everything
ansible-playbook site.yml --tags user             # no-sudo fallback
ansible-playbook site.yml --tags config           # fast config refresh
ansible-playbook site.yml --tags harness          # agent setup only
```

---

## 7. The `harness` Layer — What It Should Install and Template

The premise: agent config has converged on portable formats, and **reviewing agent output is the bottleneck**, not producing it. The harness layer should optimise for review throughput.

### 7.1 `AGENTS.md` — conventions

Two levels, both templated:

- **`~/.config/agents/AGENTS.md`** (personal, machine-aware) — your working style, your stack fluency, what you want explained vs. assumed. Templated from `host_vars`, so the work machine says "work machine, corporate Laravel monolith" and home says "WSL2, two machines, Ansible-synced". This directly fixes §4.3's frozen `preferences.md`.
- **Per-repo `AGENTS.md`** (checked into each project) — build/test/lint commands, directory conventions, PR expectations. The harness role ships a **generator skill/command**, not the file itself, since it's per-project.

Wire-up: `~/.claude/CLAUDE.md` containing `@~/.config/agents/AGENTS.md`, so one file feeds Claude Code, and other tools that read `AGENTS.md` natively pick it up directly.

**Tradeoff I'm uncertain about:** how much to put in the personal-global file. Too much and it burns context on every session in every repo. My recommendation is to keep the global file under ~40 lines (working style + review preferences only) and push all stack/convention detail into skills, which load on demand.

### 7.2 Skills directory — `SKILL.md` format

`~/.claude/skills/<skill-name>/SKILL.md`, YAML frontmatter with `name` and `description`, body under ~500 lines, supporting material in `references/` for progressive disclosure.

Proposed initial set, ordered by expected use:

1. **`review-agent-diff`** — the highest-value one. A written procedure for reviewing a branch an agent produced: get the merge-base diff, read it hunk-by-hunk in Diffview, the specific things to check in Laravel code (N+1s introduced in loops, mass-assignment, missing authorisation on new routes, migrations without a `down()`, tests that assert nothing), and how to stage partial acceptance in Neogit.
2. **`laravel-conventions`** — your house rules: form requests over inline validation, actions/services layout, Eloquent vs query builder, when a job vs a listener.
3. **`pest-testing`** — Pest idioms, datasets, `RefreshDatabase` discipline, factory conventions. Note the repo currently has both a Pest guide and a `vim-test` config pointing at phpunit (§5.5).
4. **`ansible-role`** — how to add to *this* repo idempotently: `creates`/`changed_when` requirements, OS dispatch pattern, the tag scheme, the no-sudo constraint.

**Tradeoff:** skills only fire when the `description` matches the task. The description field does more work than the body. Expect to iterate on descriptions for the first few weeks; treat a skill that never triggers as a description bug, not a content bug.

### 7.3 MCP server configuration

Template `~/.claude.json` (user scope) from a `harness_mcp_servers` list in `group_vars`/`host_vars`, with each server individually toggleable and **credentials from vault, never literals**.

Sensible defaults:

| Server | Home | Work | Why |
|---|---|---|---|
| context7 (docs lookup) | on | on | read-only, low risk |
| playwright | on | on | already installed by the toolchain layer |
| github | on | **ask first** | needs a token; scope it to read + PR comment |
| filesystem / DB servers | off | off | broad blast radius, little marginal value over the built-in tools |

**Strong recommendation, and a real tradeoff:** default every code-transmitting MCP server to **off** in `host_vars/work.yml`. You will not know your new employer's AI tooling policy on day one, and provisioning a machine that ships repo contents to third-party endpoints before you've read that policy is a bad first week. Turning one on later is a one-line var change.

### 7.4 Hooks

Hooks are where the harness earns its keep, because they enforce things the agent can't forget:

| Event | Matcher | Script | Purpose |
|---|---|---|---|
| `PostToolUse` | `Write\|Edit` | `format-edited-file.sh` | Run `pint`/`prettier` on the file just written. **Agents don't edit through Neovim, so `conform.nvim` never sees their changes** — without this, every agent diff is polluted with formatting noise, which is exactly what makes review slow. |
| `PreToolUse` | `Write\|Edit` | `guard-sensitive-paths.sh` | Deny writes to `.env`, `*.pem`, `*.key`, `storage/`, `vendor/`, `node_modules/` |
| `PreToolUse` | `Bash` | `guard-destructive-artisan.sh` | Deny `migrate:fresh`/`db:wipe`/`migrate --force` unless `APP_ENV=local` |
| `Stop` | — | `notify.sh` | Desktop/terminal notification when a long run finishes |

**Tradeoff:** hooks run synchronously on every matching tool call. Keep each under ~1s. A `Stop` hook that runs the full test suite feels great for a week and then you disable it; a `PostToolUse` formatter that runs on one file is fast enough to keep forever. Start with the formatter and the two guards only.

The formatting hook also has a **hard dependency on the toolchain layer actually installing Pint** — which today it does not (§5.3). These two changes have to ship together.

### 7.5 Git review tooling — Neogit + Diffview

Currently the config has Diffview (`plugins/init.lua:1041-1050`, only `<leader>gd` → `DiffviewOpen`), vim-fugitive, gitsigns, and a `lazygit` binding to a binary that isn't installed. That's four overlapping tools and no actual *review* workflow.

Proposed `harness/files/nvim/review.lua`:

- **`NeogitOrg/neogit`** with `integrations = { diffview = true, telescope = true }` — magit-style staging, which is the right interface for accepting an agent's work hunk-by-hunk rather than all-or-nothing.
- Keymaps built around reviewing a branch, not viewing a file:
  - `<leader>gs` — Neogit status
  - `<leader>gr` — `DiffviewOpen origin/main...HEAD` (merge-base diff = "what did the agent actually change")
  - `<leader>gR` — `DiffviewOpen HEAD~1` (last commit)
  - `<leader>gf` — `DiffviewFileHistory %` (this file's history)
  - `<leader>gl` — `DiffviewFileHistory` (branch log with diffs)
- **`git-delta`** installed by the toolchain layer and set as `core.pager` — same review quality outside Neovim, including in the agent's own `git diff` output.
- **Decide between `lazygit` and Neogit and delete the other binding.** Keeping a keymap to an uninstalled binary is worse than having neither.
- Retire `vim-fugitive` unless you specifically want `:GBrowse` (currently bound at `keymaps.lua:38`) — Neogit + Diffview + gitsigns covers the rest.

---

## 8. Ranked by Leverage — Day One on an Unknown OS

### Tier 0 — Blocking. Do these before 28 September.

| # | Change | Why it's first | Effort |
|---|---|---|---|
| 1 | **Rotate the Intelephense licence key**, then vault it | It's a paid credential in git history. Rotation is the only real fix, and it takes a vendor round-trip — start now. | 1h + vendor wait |
| 2 | **Make the playbook survive macOS**: OS dispatch in the shell role, `group` from facts not `$USER`, PHP path from a fact, `requirements.yml` for `community.general` | If they hand you a Mac, the playbook currently aborts in the zsh role and you have *nothing*. This is the whole point of the exercise. | 1 day |
| 3 | **`bootstrap.sh` + a no-sudo path (`--tags user`)** | You get one shot at a locked-down machine, possibly without admin. A curl-able bootstrap that degrades gracefully is worth more than any individual tool. | 0.5 day |
| 4 | **Commit `lazy-lock.json`; pin Node, npm globals, and Neovim** | Without this, "identical environment on two machines" is untrue and you'll debug editor differences during your first sprint. | 2h |
| 5 | **Make git identity fail loudly** (`assert` that `git_user_email` was supplied, drop the `@example.com` default) | Wrong author email on commits to a new employer's repos is a visible, embarrassing, hard-to-rewrite mistake. | 15min |
| 6 | **Template `~/.zshrc` and fix the three-role clobber** (§2.6) | Every role currently fights over this file, and hand-edits are silently destroyed. Everything else in `base` depends on it being sane. | 3h |

### Tier 1 — Highest day-one payoff.

| # | Change | Why | Effort |
|---|---|---|---|
| 7 | **Install the tools the config already assumes**: `pint`, `larastan`/`phpstan`, `eslint_d`, and either `lazygit` or drop its binding | Four silently-broken features **[verified missing]**. Fixing these is cheap and immediately makes format-on-save and linting real. | 3h |
| 8 | **Harness: `AGENTS.md` template + `PostToolUse` formatting hook + the two guard hooks** | The formatting hook is the single biggest review-speed win — it removes formatting noise from every agent diff. Depends on #7. | 1 day |
| 9 | **Harness: Neogit + Diffview review workflow** (§7.5) | Directly targets the stated bottleneck. Merge-base diff review is a different and much better workflow than what's configured today. | 0.5 day |
| 10 | **Nerd Font install on Linux and macOS** (currently a `debug` message on Linux, `neovim:233-236`) | On day one the entire UI — lualine, neo-tree, alpha, devicons — renders as tofu boxes. Cosmetic, but it's the first thing you see and it undermines confidence in the whole setup. | 2h |
| 11 | **Replace snap-Neovim with a portable install** (§2.3) | Snap is the most likely single point of failure on a corporate WSL2 or hardened Ubuntu image. | 3h |

### Tier 2 — Do after you know the machine.

| # | Change | Why | Effort |
|---|---|---|---|
| 12 | **Skills directory** — start with `review-agent-diff` only | High value, but the content should be informed by the actual codebase you'll be reviewing. Write the scaffolding now, the content in week one. | 0.5 day + ongoing |
| 13 | **MCP config templated, work defaults off** (§7.3) | Correct default is "off" until you've read the AI policy, so this is deliberately low-urgency. | 3h |
| 14 | **Idempotency pass** — `changed_when`/`creates` on the ~15 offenders in §3 | Quality-of-life. Makes run output meaningful. Doesn't block anything. | 0.5 day |
| 15 | **Delete dead weight** — `aws-codecommit`, Perl/Ruby providers, `finance-project` docs, `codecompanion` (or Copilot — pick one AI plugin), duplicate p10k load, one of neo-tree/oil | Every deleted line is a line that can't break on an unfamiliar OS. Also cuts several minutes off provisioning. | 0.5 day |
| 16 | **Fix keymap collisions** (§5.4) and audit the inert plugins (§5.5) | `<leader>cc` for Claude Code is currently dead, which matters for the harness goal. | 2h |
| 17 | **Replace the Docker test harness with a real CI matrix** (Ubuntu 24.04 + macOS runners on GitHub Actions) | This is how you'd actually *know* the macOS path works before you need it. Genuinely valuable, but only after #2 lands. | 1 day |

---

## 9. Where I'm Uncertain

**Neovim install method.** I recommend moving off snap, but the alternatives all have caveats: AppImage needs FUSE (often absent in WSL2 and containers); the official tarball needs a manual PATH and update story; `mise use -g neovim` works but lags releases slightly; Homebrew is fine on macOS but may be blocked by MDM on a corporate Mac. **I'd test the tarball-to-`~/.local` approach first** — it's the only one that needs no sudo and no runtime — but I haven't verified it against your config's 0.11+ API requirements on all three platforms.

**Homebrew availability on a corporate Mac.** If Homebrew is blocked or needs admin, the entire `Darwin` path collapses. The hedge is to route as much as possible through `mise` (node, python, and — slowly — php), which installs into `$HOME`. I don't know whether mise's PHP builds are fast or reliable enough for daily use; worth a timed test before relying on it.

**Whether to keep three AI assistants.** Copilot, Claude Code, and codecompanion+Ollama all currently ship. At a new job only what's licensed will work, and Ollama isn't installed anywhere by this playbook. I'd make the AI plugin set a variable and default the work machine to whatever's licensed — but that's a decision you can only make after 28 September.

**Nix/home-manager.** It would solve the cross-OS problem far more rigorously than Ansible. It's also a multi-week investment with a steep learning curve, six weeks before a job change. **I do not recommend it now** — but if the macOS work in #2 turns out to be more painful than estimated, it's worth revisiting later in the year rather than accreting more `when: ansible_os_family` branches indefinitely.

**Claude settings schema.** §4.5 flags `allowedTools`/`enableTelemetry`/`ignorePatterns` as probably-ignored keys. I'm inferring this from the current schema shape rather than from a spec I can point at — worth confirming with `claude config` or the docs before the harness template carries them forward.

---

## Next Step

The first batch is done (see **Remediation Status** at the top): items 4, 5(partial),
6, 7 and 11 from the ranking, plus the platform guard and the `user` tag.

The highest-value remaining work, in order:

1. **Rotate the Intelephense licence key** (§4.1, Tier 0 item 1). Still the only
   finding with a real external consequence. Needs a vendor round-trip, so it
   gates on nothing but your time.
2. **Make git identity fail loudly** (§4.4, Tier 0 item 5). Fifteen minutes, and
   it prevents pushing commits authored as `dara@example.com` to a new
   employer's repos.
3. **The macOS work** (§2, Tier 0 item 2). Currently guarded rather than fixed.
   Only worth doing once you know whether you're getting a Mac — but if you are,
   it is a day of work you cannot compress into the first week.
4. **The harness layer** (§7). The `PostToolUse` formatting hook is the single
   biggest review-speed win and now has its dependency satisfied, since Pint is
   installed.
5. **A clean-container CI run** (Tier 2 item 17). The sudo half of the playbook
   has never been exercised end-to-end; this is how you find out before the new
   machine does.
