#!/usr/bin/env bash

# ===============================================
# Linux Setup Script — Interactive Installer
# ===============================================

set -e  # Exit on error

# --- Helper function ---
ask() {
    local prompt="$1"
    local response
    read -rp "$prompt [y/N]: " response
    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

echo "==============================================="
echo " 🧩 Welcome to the Linux Setup Script"
echo "==============================================="
echo ""

# --- Update system ---
if ask "Do you want to update and upgrade the system?"; then
    echo "Updating system..."
    sudo apt update && sudo apt upgrade -y
fi

# --- Install APT packages ---
if ask "Do you want to install common APT packages (git, vim, zsh, tree, htop, curl, etc.)?"; then
    sudo apt install -y git vim zsh tree traceroute htop curl ffmpeg python3-pip vlc neofetch
fi

# --- Install Oh My Zsh ---
if ask "Do you want to install Oh My Zsh?"; then
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh is already installed. Skipping..."
    else
        echo "Installing Oh My Zsh..."
        # --unattended prevents the new shell from pausing the script
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # --- Install zsh-autosuggestions ---
    if ask "Do you want to install zsh-autosuggestions plugin?"; then
        if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
            echo "✅ zsh-autosuggestions downloaded."
            sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions)/' ~/.zshrc
        else
            echo "zsh-autosuggestions already exists."
        fi
    fi

    # --- Append custom Zsh config ---
    echo "Appending custom configuration to ~/.zshrc ..."
    
    cat <<'EOF' >> ~/.zshrc

# ==================================================
# User configuration added by setup.sh
# ==================================================

# --- ALIASES ---

# GIT
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"

# DOCKER
alias dmysql="docker run --name mysql -e MYSQL_ROOT_PASSWORD=secret -p 3307:3306 -d mysql:5.7"
alias dpma="docker run --name myadmin -d --link mysql:db -p 8080:80 phpmyadmin/phpmyadmin"

# MAC OS
alias hidden="defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder"
alias show="defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder"

# --- FUNCTIONS ---

# Git Speed Push
alias git-sp="speedPush"
alias git-sp-n="speedPushN"

speedPush() {
    if [ -n "$1" ]; then 
        git add .
        git commit -m "$1"
        git push -f
    else
        git add .
        git commit --amend --no-edit
        git push -f
    fi
}

speedPushN() {
    git add .
    git commit --amend --no-edit -n
    git push -f --no-verify
}

# Docker Shortcuts
alias drm="dockerRmAll"
alias drmv="dockerRmAllVolumes"
alias dc-bu="dockerComposeBuildAndUpDetached"
alias dc-e="dockerComposeExec"

dockerRmAll() {
    if [ -n "$(docker ps -a -q)" ]; then
        docker stop $(docker ps -a -q)
        docker rm $(docker ps -a -q)
    else
        echo "No containers to remove."
    fi
}

dockerRmAllVolumes() {
    if [ -n "$(docker volume ls -q)" ]; then
        docker volume rm $(docker volume ls -q)
    else
        echo "No volumes to remove."
    fi
}

dockerComposeBuildAndUpDetached() {
    docker-compose build
    docker-compose up -d
}

dockerComposeExec() {
    if [ -n "$1" ] && [ -n "$2" ]; then
        docker-compose exec "$1" "$2"
    else
        echo "Error : bad arguments. Usage: dc-e <service> <command>"
    fi
}

mkcd() {
    if [ -n "$1" ]; then
        mkdir -p "$1"
        cd "$1"
    else
        echo "Error : no argument"
    fi
}

b() {
    local count=0
    local target=${1:-1}
    local path=""
    while [ "$count" -lt "$target" ]; do
        path+="../"
        (( count++ ))
    done
    cd "$path"
}

# ==================================================
EOF

    echo "✅ Custom Zsh configuration appended to ~/.zshrc"
    
    # Change shell
    echo "Changing default shell to zsh..."
    sudo chsh -s "$(which zsh)" "$USER"
fi

# --- Install Docker ---
# FIX: Removed the "if command -v docker" check. 
# We trust the user. If they say Yes, we run the installer.
if ask "Do you want to install Docker?"; then
    echo "Installing (or updating) Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh

    sudo usermod -aG docker "$USER"
    echo "Added $USER to the docker group."
    
    if ask "Do you want to attempt running 'hello-world' now?"; then
         # Use || true to prevents script exit if permissions aren't ready yet
        newgrp docker <<EONG || true
        docker run hello-world
EONG
    fi
fi

echo ""
echo "==============================================="
echo " ✅ Setup Complete!"
echo " ⚠️  IMPORTANT: Please Log Out and Log Back In for Docker permissions and Zsh to take effect."
echo "==============================================="
