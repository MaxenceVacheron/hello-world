#bin/bash

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
<<<<<<< HEAD
sudo apt-get -y install docker-compose
=======
sudo group add docker
sudo usermod -aG docker $USER
sudo apt-get -y install docker-compose
docker run hello-world
>>>>>>> d9947cb66675dd149b82ed10416b39968ca8eb7d

