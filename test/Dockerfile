FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install basic tools
RUN apt update && apt upgrade -y && apt install -y sudo

# Create user paolo with home dir
RUN useradd -ms /bin/bash -u 1000 paolo && echo "paolo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory to paolo's home
WORKDIR /home/paolo

# Switch to user paolo
USER paolo
