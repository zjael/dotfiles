[ -f ~/.bashrc ] && . ~/.bashrc

shopt -s autocd
shopt -s histappend

export PATH=$PATH:$HOME/bin
export HISTSIZE=5000
export HISTFILESIZE=10000

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.bash 2>/dev/null || :