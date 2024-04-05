source "$HOME/.zinit/bin/zi.zsh"

# If you come from bash you might have to change your $PATH.
export PATH=$PATH:$HOME/bin:/usr/bin


if [ -f "$HOME/.powerlevel10k.zsh" ]; then
    source "$HOME/.powerlevel10k.zsh"
fi

# zplugin/zinit
zinit ice depth=1;
zinit light romkatv/powerlevel10k

zinit ice lucid wait atinit='zpcompinit'
zinit light "zdharma/fast-syntax-highlighting"

zinit ice lucid wait atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

zinit ice lucid wait
zinit light zsh-users/zsh-completions

zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh
zinit snippet OMZ::plugins/battery/battery.plugin.zsh
zinit snippet OMZ::plugins/common-aliases/common-aliases.plugin.zsh
zinit snippet OMZ::plugins/autojump/autojump.plugin.zsh

zinit ice lucid wait='1'
zinit snippet OMZ::plugins/git/git.plugin.zsh

zinit light chrissicool/zsh-256color

# zsh completion
zstyle ':completion:*' matcher-list 'm:{a-za-z}={a-za-z}' \
    'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu yes select
autoload -Uz compinit && compinit

# Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zi.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# load some completion
zinit ice mv="*.zsh -> _fzf" as="completion"
zinit snippet 'https://github.com/junegunn/fzf/blob/master/shell/completion.zsh'
zinit snippet 'https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh'
zinit ice as="completion"
zinit snippet 'https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/fd/_fd'
zinit ice mv="*.zsh -> _exa" as="completion"
zinit snippet 'https://github.com/ogham/exa/blob/master/completions/zsh/_exa'

# no ls, yes exa
DISABLE_LS_COLORS=true

# use fd for fzf
export FZF_DEFAULT_COMMAND='fd --type f'

# End of load


# aliases
if [ -f "$HOME/.shell_aliases" ]; then
    source "$HOME/.shell_aliases"
fi


# JAVA
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export JRE_HOME=$JAVA_HOME/jre
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
export CLASSPATH=$CLASSPATH:.:$JAVA_HOME/lib:$JRE_HOME/lib

# Python
eval "`pip completion --zsh`"

# snap
export PATH=$PATH:/snap/bin

# nvm
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# vcpkg
export PATH=$PATH:$HOME/.local/src/vcpkg
autoload bashcompinit
bashcompinit
source $HOME/.local/src/vcpkg/scripts/vcpkg_completion.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/harry/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/harry/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/harry/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/harry/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

