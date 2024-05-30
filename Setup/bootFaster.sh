sudo apt purge -y snapd && rm -rf ~/snap && sudo rm -rf /snap && sudo rm -rf /var/snap && sudo rm -rf /var/lib/snapd && sudo apt-mark hold snap

udo apt install -y flatpak && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo apt install -y gnome-software gnome-software-plugin-flatpak

sudo systemctl disable NetworkManager-wait-online.service
