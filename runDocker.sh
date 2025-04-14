#!/bin/bash
sudo docker run --rm -it \
    -u $(id -u):$(id -g) \
    -v "${HOME}/linuxSetup":/home/paolo/linuxSetup \
    -w /home/paolo \
    test_ubuntu \
    bash
