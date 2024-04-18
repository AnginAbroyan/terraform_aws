#!/bin/bash

sudo apt-get update -y

sudo apt-get install docker.io -y
sudo systemctl start docker

sudo apt-get install -y awscli
$(aws ecr get-login --no-include-email --region eu-central-1)

aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 767397941516.dkr.ecr.eu-central-1.amazonaws.com

docker pull 767397941516.dkr.ecr.eu-central-1.amazonaws.com/brainscale-simple-app:1.0

docker run -d -p 3000:3000 -e ENV_VAR=brainscale-simple-app 767397941516.dkr.ecr.eu-central-1.amazonaws.com/brainscale-simple-app:1.0

