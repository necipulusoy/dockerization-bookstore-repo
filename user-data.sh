#!/bin/bash
hostnamectl set-hostname ${server-name}
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
# install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
yum install git -y
TOKEN=${user-data-github-token}
USER=${user-data-github-name}
cd /home/ec2-user && git clone https://$TOKEN@github.com/$USER/dockerization-bookstore-repo.git
cd /home/ec2-user/dockerization-bookstore-repo && docker-compose up -d