#bin/bash

#groupadd docker
usermod -aG docker $USER
newgrp docker
docker run hello-world
