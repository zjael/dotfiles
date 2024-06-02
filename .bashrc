# User with admin privileges
admin=jakob
if [ -z "$admin" ]; then
  admin=$(whoami)
fi

export SSH_AUTH_SOCK=~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

alias brew='sudo -Hu $admin brew'
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'


eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init bash)"