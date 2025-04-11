#!/bin/bash
sudo docker run --rm -it \
    -v "${HOME}/linuxSetup":/home/paolo/linuxSetup \
    -w /home/paolo \
    test_ubuntu \
    bash
