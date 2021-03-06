# Install `zinit` if not installed
if [ ! -d "${HOME}/.zinit" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
fi
#
## Added by Zinit's installer
source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

### End of Zinit installer's chunk

# Recommended
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

# Install `fzf` binary and tmux helper script
zinit light-mode lucid binary from"gh-r" for \
    sbin"fzf; fzf-tmux" \
        atdelete"rm -vf $ZPFX/man/man1/{fzf,fzf-tmux}.1" \
        dl"https://raw.githubusercontent.com/junegunn/fzf/master/bin/fzf-tmux; \
            https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh; \
            https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh; \
            https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf-tmux.1 -> $ZPFX/man/man1/fzf-tmux.1; \
            https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf.1 -> $ZPFX/man/man1/fzf.1" \
        multisrc"completion.zsh key-bindings.zsh" \
        junegunn/fzf

export FZF_DEFAULT_COMMAND='rg --files --hidden'
# Use ctrl+o to open selected file(s) in vim
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(vim {})+abort' --cycle"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# # Using bat as previewer
export FZF_CTRL_T_OPTS="--preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
# Changing from ** to ~~ the trigger for autocompletion in shell
export FZF_COMPLETION_TRIGGER='~~'

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

    # edit selected
fe() {
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# cd into selected
fd() {
    DIR=`find * -maxdepth 0 -type d -print 2> /dev/null | fzf-tmux` \
        && cd "$DIR"
}

bindkey '^R' fzf-history-widget

##### BEGIN Zinit stuff #####
### needs: zinit, fzf
#
zinit pack for ls_colors

# Load the pure theme, with zsh-async library that's bundled with it.
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

#Pure
autoload -U compinit promptinit
export PURE_CMD_MAX_EXEC_TIME=60
# Make pure theme single line
prompt_newline='%666v'
PROMPT=" $PROMPT"
zstyle :prompt:pure:user color green
zstyle :prompt:pure:host color green
zstyle :prompt:pure:git:branch color white
zstyle :prompt:pure:git:stash show yes

# z
zinit ice wait blockf lucid
zinit light rupa/z

# z tab completion
zinit ice wait lucid
zinit light changyuheng/fz

# z / fzf (ctrl-g)
zinit ice wait lucid
zinit light andrewferrier/fzf-z

# cd
zinit ice wait lucid
zinit light changyuheng/zsh-interactive-cd

# History search by `Ctrl+R`
zinit ice wait lucid
zinit load zdharma/history-search-multi-word

# Tab completions
zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# Syntax highlighting
zinit ice wait lucid atinit'zpcompinit; zpcdreplay'
zinit light zdharma/fast-syntax-highlighting

##### END Zinit stuff #####
