#!/bin/bash -e

# this file is executed when building the container
# it installs and configures the necessary applications


apt-get update -qq

apt-get install -y --no-install-recommends menu

# Clean APT install files
apt-get autoremove -y 
apt-get clean -y

