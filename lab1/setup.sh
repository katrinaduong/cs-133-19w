#!/bin/sh
sudo apt update
sudo env DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo env DEBIAN_FRONTEND=noninteractive apt install build-essential -y
