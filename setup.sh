#!/bin/bash
if ! [ $(id -u) = 0 ]; then
    echo "ERROR: Script requires to be run as sudo or root."
    exit 1
fi
sudo pacman -Syu

arch_setup() {
    # Comment or Uncomment each of these functions as required
    
    # Sets up Language, Timezone & Keymap
    LANG="en_DK"
    TIMEZONE="Europe/Copenhagen"
    KEYMAP="dk"
    setup_locale

    # Installs and enables hardwareclock
    #setup_hwclock

    # Installs and enables ufw "Firewall" and block all ports besides 20,80,443
    setup_firewall

    # Installs and utilize reflector to update mirrorlist
    # Possibly setup cronjob to auto update mirrorlist once a week
    setup_mirrorlist

    # Installs and sets up rEFIned with rEFInd-minimal theme
    #setup_rEFIned

    # Installs and sets up zsh with theme
    setup_shell

    # Installs and sets up Touch, TLP & Intel Microcode
    #setup_laptop   

    # Installs and sets up, weekly SSD maintenance, make sure your SSD supports TRIM if unsure run 'lsblk -D'
    #setup_fstrim   

    # Installs the AURHelper "Trizen"
    install_aurhelper

    # Installs a list of packages, list is located in the; install_packages function
    install_packages

    # Sets up services for programs installed from install_packages
    setup_services

    # Sets up dotfiles associated with this repo
    setup_dotfiles
}

setup_locale() {
    echo "#-- Setting Language, Timezone & Keymap --#"
    echo "LANG=$LANG.UTF-8" > /etc/locale.conf
    echo "$LANG.UTF-8 UTF-8" > /etc/locale.gen
    locale-gen

    ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime

    echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
    loadkeys $KEYMAP
}

setup_hwclock() {
    echo "#-- Setting Up Hardware Clock --#"
    sudo pacman -S ntp --noconfirm --needed
    timedatectl set-ntp true
    hwclock --systohc --utc
    systemctl enable --now ntpd.service
}

setup_firewall() {
    echo "#-- Setting Up Firewall --#"
    sudo pacman -S ufw --noconfirm --needed
    iptables -F; iptables -X
    echo 'y' | ufw reset
    echo 'y' | ufw enable
    ufw default deny incoming
    ufw default deny forward
    #ufw logging on
    ufw allow 22,80,443/tcp
    systemctl enable --now ufw.service
}

setup_mirrorlist() {
    echo "#-- Setting Up Mirrorlist --#"
    sudo pacman -S reflector --noconfirm --needed
    sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    sudo reflector --latest 50 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    sudo pacman -Syu
}

setup_rEFIned() {
    echo "#-- Setting Up rEFIned --#"
    pacman -S refind-efi
    refind-install

    mkdir /boot/EFI/refind/themes
    cd /boot/EFI/refind/themes
    git clone https://github.com/EvanPurkhiser/rEFInd-minimal

    chmod -R 755 /boot/EFI/refind
    echo 'include themes/rEFInd-minimal/theme.conf' >> /boot/EFI/refind/refind.conf
}

setup_shell() {
    echo "#-- Setting Up Shell --#"
    sudo pacman -S zsh --noconfirm --needed
    chsh -s $(which zsh)
    git clone https://github.com/zplug/zplug ~/.zplug
}

setup_laptop () {
    echo "#-- Setting Up Laptop --#"
    sudo pacman -S xf86-input-synaptics tlp --noconfirm --needed
	systemctl enable --now tlp
	systemctl enable --now tlp-sleep
	systemctl mask --now systemd-rfkill.service systemd-rfkill.socket

    sudo pacman -S intel-ucode --noconfirm --needed
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    # TODO: Add rEFInd Boot Argument
}

setup_fstrim() {
    echo "#-- Setting Up Fstrim --#"
    pacman -S util-linux --noconfirm --needed
    systemctl enable --now fstrim fstrim.timer
}

install_aurhelper() {
    echo "#-- Installing AURhelper --#"
    sudo pacman -S base-devel --noconfirm --needed

    cd /tmp
    git clone https://aur.archlinux.org/trizen.git
    cd trizen
    makepkg -si

    rm -r /tmp/trizen
    cd ~
}

# Packages to check out: yadm exa rtv dtach autojump bash-snippets nnn googler buku ledger pass gist
install_packages() {
    echo "#-- Installing Packages --#"

    local packages=''
    # System utilities
    packages+=' networkmanager openssh lm_sensors thermald curl wget htop nethogs udevil rar unrar scrot neofetch rsync'

    # Terminal
    packages+=' alacritty-git tree xclip ranger thefuck micro'
    packages+=' fzf jq chkservice jrnl howdoi'

    # Development
    packages+=' git tig'
    packages+=' python python-pip python-setuptools python-virtualenv'
    packages+=' nodejs npm'

    # Security
    packages+=' lynis'

    # Xorg
    packages+=' xorg xorg-xinit xbacklight'

    # Desktop
    packages+=' surf spotify xclip cups'

    # For Fun
    packages+=' cowsay lolcat fortune-mod'

    # Enviroment
    packages+=' bspwm polybar sxhkd'
    packages+=' stow redshift rofi nitrogen compton dunst'

    # Themes
    packages+=' equilux-theme papirus-icon-theme'

    # Fonts
    packages+=''
    
    for pkg in $packages; do
        sudo -u $SUDO_USER trizen -S --needed --noconfirm --noedit $pkg
    done
}

setup_services() {
    echo "#-- Setting Up Services --#"
    sudo systemctl enable --now sshd.service
    sensors-detect
    sudo systemctl enable --now thermald.service
    sudo systemctl enable --now --$SUDO_USER redshift.service
    sudo systemctl enable --now org.cups.cupsd.service
}

setup_dotfiles() {
    echo "#-- Setting Up Dotfiles --#"
    # Install Local Fonts
    sudo cp -avr ./fonts/bitmap/ /usr/share/fonts
    xset fp+ /usr/share/fonts/bitmap
    fc-cache -fv

    cp -r .config ~/.config 
    cp .Xresources .xinitrc .zlogin .zshrc ~/
}

arch_setup