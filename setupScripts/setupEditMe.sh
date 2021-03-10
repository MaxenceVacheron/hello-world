#bin/bash


# Backing up old .zshrc file
cp ~/.zshrc ~/.zshrc.bak

# Updating .zshrc file
cp zshrc ~/.zshrc

# Dev tools include a full upgrade of the distro, and additional install of git, vim and tree.
sh src/setupDevTools.sh
sh src/cleanInstallDocker.sh
#sh src/setupGestures.sh
sh src/setupOhMyZSH.sh

# Sourcong zshrc file
#source ~/.zshrc
