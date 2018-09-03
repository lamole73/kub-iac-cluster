#!/bin/bash

set -e

# See: https://docs.docker.com/install/linux/docker-ce/centos/

echo "Installing Docker..."

#################################################
################ UBUNTU
#################################################
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')

#################################################
################ CENTOS
#################################################

## Install required packages. yum-utils provides the yum-config-manager utility, and device-mapper-persistent-data and lvm2 are required by the devicemapper storage driver.
#sudo yum install -y yum-utils
#-sudo yum install -y device-mapper-persistent-data lvm2

## Use the following command to set up the stable repository. You always need the stable repository, even if you want to install builds from the edge or test repositories as well.
#sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

## Optional: Enable the edge and test repositories. These repositories are included in the docker.repo file above but are disabled by default. You can enable them alongside the stable repository.
#-sudo yum-config-manager --enable docker-ce-edge
#-sudo yum-config-manager --enable docker-ce-test

##You can disable the edge or test repository by running the yum-config-manager command with the --disable flag. To re-enable it, use the --enable flag. The following command disables the edge repository.
#-sudo yum-config-manager --disable docker-ce-edge

## Install the latest version of Docker CE, or go to the next step to install a specific version:
#sudo yum install -y docker-ce

## To install a specific version of Docker CE, list the available versions in the repo, then select and install:
## a. List and sort the versions available in your repo. This example sorts results by version number, highest to lowest, and is truncated:
## yum list docker-ce --showduplicates | sort -r
## docker-ce.x86_64            18.03.0.ce-1.el7.centos             docker-ce-stable
## The list returned depends on which repositories are enabled, and is specific to your version of CentOS (indicated by the .el7 suffix in this example).
## b. Install a specific version by its fully qualified package name, which is the package name (docker-ce) plus the version string (2nd column) up to the first hyphen, separated by a hyphen (-), for example, docker-ce-18.03.0.ce.
#-sudo yum install docker-ce-17.03.3.ce-1.el7

########### Alternativelly install via default repositories because docker-ce-17.03.3.ce-1.el7 does not install
#sudo yum install -y docker

#################################################
################ BOTH
#################################################

## Start and enable Docker.
echo "Start and enable Docker..."
sudo systemctl start docker
sudo systemctl enable docker

## If you would like to use Docker as a non-root user, you should now consider adding your user to the "docker" group with something like:
## Remember to log out and back in for this to take effect!
echo "Adding vagrant to docker group..."
sudo usermod -aG docker vagrant

echo "Installing Docker... DONE."

## Verify that docker is installed correctly by running the hello-world image
# sudo docker run hello-world

