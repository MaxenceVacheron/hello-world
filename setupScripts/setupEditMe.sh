#bin/bash

# Dev tools include a full upgrade of the distro, and additional install of git, vim and tree.
sh src/setupDevTools.sh
sh src/cleanInstallDocker.sh
sh src/setupUserAndTestDocker.sh
sh src/setupZSHandOMZSH.sh
#sh src/setupGestures.sh



# Backing up old .zshrc file
cp ~/.zshrc ~/.zshrc.bak

# Updating .zshrc file
cp zshrc ~/.zshrc
