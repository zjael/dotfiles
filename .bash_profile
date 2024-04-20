[ -f ~/.bashrc ] && . ~/.bashrc

shopt -s autocd
shopt -s histappend

export PATH=$PATH:$HOME/bin
export PATH=~/.composer/vendor/bin:$PATH
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export HISTSIZE=5000
export HISTFILESIZE=10000

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.bash 2>/dev/null || :