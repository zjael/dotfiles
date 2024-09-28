[ -f ~/.bashrc ] && . ~/.bashrc

# Load ruby environment manager
if which rbenv >/dev/null; then eval "$(rbenv init -)"; fi

# Load Orbstack CLI
# https://orbstack.dev
source ~/.orbstack/shell/init.bash 2>/dev/null || :

shopt -sq cdspell cmdhist extglob histappend

export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.dotfiles/bin
export PATH=$PATH:$HOME/.composer/vendor/bin

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export HISTSIZE=5000
export HISTFILESIZE=10000
export EDITOR=code

# Load NVM (https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Load secretive if installed (https://github.com/maxgoedjen/secretive)
if [ -r "${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh" ]; then
  export SSH_AUTH_SOCK="${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
fi

# Add SSH keys to the ssh-agent (https://developer.github.com/v3/guides/using-ssh-agent-forwarding)
if [ ! $(ssh-add -l | grep -o -e id_rsa) ]; then
  ssh-add "$HOME/.ssh/id_rsa" >/dev/null 2>&1
fi

# User with admin privileges, used as global homebrew user
ADMIN=""
if [ -z "$ADMIN" ]; then
  ADMIN=$(whoami)
fi

alias perm="stat -f '%Lp'"
alias mkdir='mkdir -pv'
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

alias brew='sudo -Hu $ADMIN brew'
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'