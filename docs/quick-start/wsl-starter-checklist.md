# WSL2 Starter Checklist

A staged path from "WSL is installed" to "working from git every day".
Do one stage at a time and move on only when the previous one feels routine.
Each item says **why** as well as **how**: the why is what makes it stick.

> **Distro:** use **Ubuntu 24.04 LTS**. It is the WSL default, it has the
> most tutorials and Stack Overflow answers, LTS means five years of
> security updates with no forced upgrades, and it is what the rest of
> the team (and `starter.yml` / `playbook.yml`) runs. Matching versions
> means "works on my machine" really does mean yours too. Move to the
> next LTS together, as a team, not one person at a time.

---

## Stage 1: WSL itself

- [ ] **Check what's installed.** In PowerShell:
  ```powershell
  wsl -l -v        # list distros; VERSION must say 2
  wsl --update     # update the WSL kernel/runtime
  ```
  If Ubuntu isn't listed, or you'd rather start clean on the team version:
  `wsl --install -d Ubuntu-24.04`. Inside Ubuntu, `lsb_release -a`
  confirms the version.

- [ ] **Update Ubuntu's packages.**
  ```bash
  sudo apt update && sudo apt upgrade -y
  ```
  *Why:* `apt update` refreshes the list of available packages; `upgrade`
  installs them. `sudo` runs one command as administrator, using the
  password you chose when Ubuntu was installed. That password is
  separate from your Windows one.

- [ ] **Windows Terminal → Settings → Startup → Default profile: Ubuntu.**
  *Why:* every new terminal opens straight into Linux.

- [ ] **Keep all code inside Linux: `~/code`, never `/mnt/c/...`.**
  ```bash
  mkdir -p ~/code && cd ~/code
  ```
  *Why:* `/mnt/c` is your Windows C: drive reached through a translation
  layer. It's many times slower for git and npm, and it causes
  permission and line-ending problems. This is the most common mistake
  people make with WSL.

- [ ] **See Linux files from Windows.**
  ```bash
  explorer.exe .     # opens the current folder in File Explorer
  ```
  The files live under `\\wsl.localhost\Ubuntu-24.04\home\<you>`. It's
  fine to *look* from Windows, but do git and other tools from the
  Ubuntu terminal.

- [ ] **VS Code with the WSL extension.** Install VS Code on *Windows*, add
  the **WSL** extension (by Microsoft), then from Ubuntu:
  ```bash
  cd ~/code && code .
  ```
  The bottom-left corner should say **WSL: Ubuntu-24.04**. *Why:* the
  editor window runs on Windows, but all file access, terminals and
  extensions run in Linux, so it's fast and behaves the same as the
  terminal.

- [ ] **Know the reset button.** If WSL acts strangely, run `wsl --shutdown`
  in PowerShell and then open a new terminal.

---

## Stage 2: Shell basics (alongside the git course)

Use the default shell, **bash**. A fancier shell such as zsh can come later.

- [ ] **Moving around:** `pwd` (where am I?), `ls -la` (what's here, hidden
  files included), `cd folder`, `cd ..` (up one), `cd ~` or just `cd` (home),
  `cd -` (back to the previous folder).
- [ ] **Files:** `mkdir -p a/b`, `touch file`, `cp src dest`, `mv old new`
  (move *and* rename), `rm file`, `rm -r folder`.
  **There is no recycle bin.** `rm` is permanent.
- [ ] **Reading:** `cat file` (whole file), `less file` (scroll it; `q`
  quits, `/word` searches), `head` / `tail -f` (follow a log file live).
- [ ] **Finding:** `rg "text"` searches every file under the current folder.
  `tree -L 2` shows the folder structure.
- [ ] **Help:** `man ls`, `ls --help`. `q` quits.
- [ ] **Speed habits:**
  - `Tab`: completes file and command names. Press it constantly.
  - `↑`: previous commands.
  - `Ctrl+R`: search your command history.
  - `Ctrl+C`: stop whatever is running.
  - `Ctrl+L`: clear the screen.
- [ ] **Read error messages.** Most of them say exactly what's wrong
  ("No such file or directory", "Permission denied"). Read the error
  before asking for help. This is the main skill to build.

*Exercise:* in `~/code/sandbox`, create folders and files, move and rename
them, and delete them again, using only the terminal.

---

## Stage 3: Git identity and GitHub access

**Shortcut:** `starter.yml` in this repo does the packages and git config
in one go (see the end of this page). Doing it by hand once is worth it,
though, because then you know what the playbook does for you.

- [ ] **Use the git inside Ubuntu.** Don't use Git for Windows or GitHub
  Desktop on files under `~`. *Why:* they're two separate gits with
  different line-ending and permission defaults, and mixing them produces
  ghost changes.
- [ ] **Identity and defaults:**
  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "you@company.com"
  git config --global init.defaultBranch main
  git config --global pull.rebase false     # plain merge on pull, as most courses teach
  git config --global core.autocrlf input   # turn any Windows CRLF into LF on commit
  git config --global --list                # check
  ```
- [ ] **SSH key for GitHub:**
  ```bash
  ssh-keygen -t ed25519 -C "you@company.com"   # accept the default path
  cat ~/.ssh/id_ed25519.pub                    # copy this output
  ```
  On GitHub, go to **Settings → SSH and GPG keys → New SSH key** and
  paste it. Then test:
  ```bash
  ssh -T git@github.com    # "Hi <username>! You've successfully authenticated"
  ```
  *Why:* there's no password prompt on every push, and the private key
  (the file *without* `.pub`) never leaves the machine. Never share it.
- [ ] **Practise in a throwaway repo:** in `~/code/sandbox`, run `init`,
  `add`, `commit`, `log`, `diff`, create a branch, merge it, and cause a
  merge conflict on purpose and resolve it. Mistakes here cost nothing.
- [ ] **Clone, change, push:** a personal practice repo on GitHub, cloned
  with the **SSH** URL (`git@github.com:...`), not HTTPS.

---

## Stage 4: A real site under git

This is where the FTP workflow starts to change. Even while deployment is
still over FTP, git becomes the record of what changed, when, and why.

- [ ] **Agree the team rule:** *no edit goes to the server unless it's
  also committed.* Without it, the repo and the live site drift apart and
  the repo stops being trustworthy.
- [ ] **Make lftp refuse unencrypted FTP.** By default, if a server doesn't
  offer encryption, lftp quietly falls back to plain FTP and sends your
  password unencrypted. `starter.yml` adds these two lines to `~/.lftprc`
  (or add them by hand):
  ```
  set ftp:ssl-force true           # refuse to log in without encryption (FTPS)
  set ftp:ssl-protect-data true    # encrypt file transfers too, not just the login
  ```
  If a server then fails with a TLS error, it doesn't support FTPS. Ask
  before making an exception for it.
- [ ] **Pull a copy of the live site (download only).** Our Azure App
  Service sites use FTPS (`ftp://` plus the settings above), not SFTP.
  The host and login are in the Azure portal under the app →
  **Deployment Center → FTPS credentials**.
  ```bash
  mkdir -p ~/code/sitename && cd ~/code/sitename
  lftp -u 'USERNAME' ftp://<host>.ftp.azurewebsites.windows.net
  # inside lftp (it asks for the password; it isn't typed on the command line):
  mirror --verbose /site/wwwroot .              # server → local
  quit
  ```
  **`mirror` downloads; `mirror -R` uploads.** Never run `mirror -R`
  (especially with `--delete`) until you've understood it and tried
  it with `--dry-run` first.
- [ ] **Before the first commit, write `.gitignore` and `.gitattributes`:**
  - Ignore **secrets**: config files containing database passwords or
    API keys (e.g. `.env`, `config.php`, `wp-config.php`). Commit an
    example copy with fake values instead (`config.example.php`).
    *Once a secret is committed, it's in the history for good.*
  - Ignore **generated or bulky folders**: `vendor/`, `node_modules/`,
    caches, logs, and user upload directories.
  - `.gitattributes` containing `* text=auto eol=lf`: line endings are
    then fixed for everyone by the repo itself, not by each person's
    settings.
- [ ] **First commit = the baseline:** `git add -A && git commit -m "Baseline: live site as of YYYY-MM-DD"`.
  Run `git status` first and check that nothing secret is staged.
- [ ] **Push to a private GitHub repo** owned by the company account.
- [ ] **Daily loop:** pull → branch → edit → commit → push → upload the
  changed files → merge. `git diff --name-only main` lists the files to
  upload.

---

## Stage 5: Later, when stages 1–4 feel routine

- [ ] **Local development environment with Docker:** change and test
  locally instead of on the live server. Two ways to run it:
  - **Docker Desktop** with its WSL2 backend: easiest, but needs a paid
    licence for larger companies (over 250 staff or $10M revenue).
  - **Docker Engine installed inside Ubuntu**: free, and you manage it
    yourself.
- [ ] **Deploy from git** rather than picking files by hand.
- [ ] **Nicer tools**, one at a time: `delta` (readable diffs), `fzf`
  (fuzzy `Ctrl+R`), `lazygit` (visual git in the terminal), then zsh +
  starship. The full `playbook.yml` in this repo installs all of them,
  using tags such as `--tags zsh` to add them piece by piece.

---

## Starter profile (`starter.yml`)

Does stage 3's git config, installs the stage 1–4 tools (`git curl wget
unzip openssh-client tree ripgrep jq lftp`), makes lftp require FTPS
(stage 4), and creates `~/code`. It
doesn't change the shell, editor, or prompt.

```bash
sudo apt update && sudo apt install -y git ansible
git clone <this repo> ~/code/dev-setup && cd ~/code/dev-setup
ansible-galaxy collection install -r requirements.yml
cp personal-config.yml.example personal-config.yml   # set your name + email
ansible-playbook starter.yml -e @personal-config.yml -K
```

`-K` asks for your Ubuntu (sudo) password. It's safe to run again at any
time. Running `playbook.yml` later layers the full setup on top.

---

## Notes for whoever is pairing

- **They type, you talk.** People remember what they typed themselves.
- **One new thing per week.** Wait until each tool is routine before adding the next.
- **Short sessions** (30–45 minutes) that end with something working.
- **Let them hit errors** and read the message before you step in.
- Keep a shared cheatsheet of commands as they're learned. It can
  become the team's onboarding README.
