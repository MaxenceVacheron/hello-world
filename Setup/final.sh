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
    sudo apt update && sudo apt upgrade -y
fi

# --- Install APT packages ---
if ask "Do you want to install common APT packages (git, vim, zsh, tree, traceroute, htop, ffmpeg, pip, curl, vlc, neofetch)?"; then
    sudo apt install -y git vim zsh tree traceroute htop curl
fi

# --- Install Oh My Zsh ---
if ask "Do you want to install Oh My Zsh?"; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # --- Install zsh-autosuggestions ---
    if ask "Do you want to install zsh-autosuggestions plugin?"; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        echo "✅ zsh-autosuggestions installed."
    fi

    # --- Append custom Zsh config ---
    echo "Appending custom configuration to ~/.zshrc ..."
    cat <<'EOF' >> ~/.zshrc

# ==================================================
# User configuration added by setup.sh
# ==================================================

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes.

### ALIAS ###
# GIT #
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"

# DOCKER #
alias dmysql="docker run --name mysql -e MYSQL_ROOT_PASSWORD=secret -p 3307:3306 -d mysql:5.7"
alias dpma="docker run --name myadmin -d --link mysql:db -p 8080:80 phpmyadmin/phpmyadmin"

# MAC OS #
alias hidden="defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder"
alias show="defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder"

### FUNCTIONS ###
if $LOAD_FUNCTIONS ; then
    alias git-sp="speedPush"
    alias git-sp-n="speedPushN"
    alias drm="dockerRmAll"
    alias drmv="dockerRmAllVolumes"
    alias dc-bu="dockerComposeBuildAndUpDetached"
    alias dc-e="dockerComposeExec"

    speedPush() {
        if [ $1 ]; then 
            git add .
            git commit -m $1
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

    dockerRmAll() {
        docker stop \$(docker ps -a -q)
        docker rm \$(docker ps -a -q)
    }

    dockerRmAllVolumes() {
        docker volume rm \$(docker volume ls -q)
    }

    dockerComposeBuildAndUpDetached() {
        docker-compose build
        docker-compose up -d
    }

    dockerComposeExec() {
        if [ \$1 ] && [ \$2 ]; then
            docker-compose exec \$1 \$2
        else
            echo "Error : bad arguments"
        fi
    }

    mkcd() {
        if [ \$1 ]; then
            mkdir \$1
            cd \$1
        else
            echo "Error : no argument"
        fi
    }

    b() {
        if [ \$1 ]; then
            i=\$1
        else
            i=1
        fi
        count=2
        command='cd ..'
        while [ \$count -le \$i ]; do
            command+="/.."
            (( count++ ))
        done
        eval \$command
    }
fi

# Plugins option in .zshrc
plugins=(
  zsh-autosuggestions
)

source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ==================================================
EOF

    echo "✅ Custom Zsh configuration appended to ~/.zshrc"
fi

# --- Install Docker ---
if ask "Do you want to install Docker?"; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh

    sudo usermod -aG docker "$USER"
    echo "Added $USER to the docker group. You may need to log out and back in."

    if ask "Do you want to run 'docker run hello-world' to test?"; then
        newgrp docker <<EONG
docker run hello-world
EONG
    fi
fi

echo ""
echo "==============================================="
echo " ✅ Setup Complete!"
echo "You can now restart your terminal or log out/in if needed."
echo "==============================================="
