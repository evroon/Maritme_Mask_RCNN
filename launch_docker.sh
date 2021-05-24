#!/bin/bash

docker run -it --rm --gpus all \
           --volume=$(pwd):/maskrcnn:rw \
           -p 8888:8888 \
           -p 6006:6006 \
           $USER/maskrcnn:latest
