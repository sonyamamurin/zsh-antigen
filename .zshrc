setopt HIST_IGNORE_DUPS

ZSHA_BASE=$HOME/.antigen
source $ZSHA_BASE/antigen.zsh

LS_COLORS='no=00;37:fi=00:di=00;33:ln=04;36:pi=40;33:so=01;35:bd=40;33;01:'
export LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle textmate
#antigen bundle command-not-found
antigen bundle djui/alias-tips

if [[ $OSTYPE == darwin* ]] ; then
	antigen-bundle osx
	source $HOME/.zshrc_mac
	#echo 'Mac settings'
	
elif [ "$OSTYPE"="linux-gnu" ]; then
	source $HOME/.zshrc_linux
else
	echo 'OSTYPE is wrong'
fi

if [ `whoami` = "gudrun" ]; then
	source $HOME/.githubtoken
	alias lg='echo "Already logged in as Gudrun"'
fi

#Platform independent aliases

alias ll='ls -lh'
alias la='ls -A'
alias l='ls'
alias l.='ls -d .*'
alias cd..='cd ..'
alias mkdir='mkdir -pv'
alias rmi='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ..='cd ..'

alias zshconfig='$EDITOR ~/.zshrc'

alias arka='ssh farligm@a.tetov.se'

alias watch='watch -n30 '

alias whatmp3='whatmp3 --skipgenre'
alias whatmp3n='whatmp3 --V0 -n '

alias dithr='mkdir ../"${PWD##*/}_16"; for flac in *.flac; do sox -S "${flac}" -G -b 16 ../"${PWD##*/}_16"/"${flac}" rate -v -L 48000 dither; done'

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme gentoo

# Tell antigen that you're done.
antigen apply

PROMPT='%(!.%{$fg[red]%}.%{$fg[green]%}%n@)%m %{$fg[blue]%}%(!.%1~.%~) $(git_prompt_info)%_%{$fg[white]%}$(prompt_char)%{$reset_color%} '