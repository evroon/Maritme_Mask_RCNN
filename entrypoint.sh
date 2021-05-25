#!/bin/bash

tensorboard --host 0.0.0.0 --logdir logs &
jupyter-notebook --allow-root --ip="0.0.0.0" &
python3 setup.py install &
bash
