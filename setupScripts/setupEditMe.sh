#bin/bash

# Dev tools include a full upgrade of the distro, and additional install of git, vim and tree.
sh src/setupDevTools.sh
sh src/setupOhMyZSH.sh
sh src/cleanInstallDocker.sh
#sh src/setupGestures.sh

# Backing up old .zshrc file
cp ~/.zshrc ~/.zshrc.bak

# Updating .zshrc file
cp zshrc ~/.zshrc
