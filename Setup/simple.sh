sudo apt install -y git vim zsh tree traceroute htop ffmpeg pip curl vlc neofetch

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

curl -fsSL https://get.docker.com -o get-docker.sh

sudo apt-get -y install docker-compose

sudo usermod -aG docker $USER
newgrp docker

docker run hello-world

