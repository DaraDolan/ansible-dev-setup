# ---------------------------------------------------------------------------
# MANAGED BY ANSIBLE - roles/zsh/files/zinit.zsh (deployed to ~/.zinitrc)
#
# Zinit is the sole plugin manager: oh-my-zsh is no longer installed. The
# oh-my-zsh pieces we actually use are loaded as snippets below; zinit
# downloads them individually from the oh-my-zsh repo.
# ---------------------------------------------------------------------------
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Completions must be in fpath before compinit runs (bottom of this file)
zinit light zsh-users/zsh-completions

# oh-my-zsh snippets. OMZL::git.zsh provides the helper functions
# (git_current_branch etc.) that the git plugin's aliases depend on,
# so it must load first.
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git       # git aliases (gst, gco, gp, ...)
zinit snippet OMZP::laravel   # artisan/laravel helpers
zinit snippet OMZP::sudo      # Esc-Esc to prepend sudo to the current line

zinit light jessarcher/zsh-artisan
# Reminds you when a typed command has an alias. Replaces molovo/tipz,
# which has been unmaintained since 2018.
zinit light MichaelAquilina/zsh-you-should-use
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-autosuggestions
# Loads last on purpose: it patches ZLE widgets set up by earlier plugins.
zinit light zdharma-continuum/fast-syntax-highlighting

# Arrow keys search history by the substring already typed
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Initialise the completion system (oh-my-zsh used to do this for us)
autoload -Uz compinit
compinit
zinit cdreplay -q
