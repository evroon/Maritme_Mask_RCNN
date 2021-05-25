FROM nvidia/cuda:11.0.3-cudnn8-devel-ubuntu20.04
LABEL maintainer="Erik Vroon <erik.vroon22@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

# Install Python and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-pip \
        git make ffmpeg libsm6 libxext6 nano -y && \
    pip3 install --no-cache-dir --upgrade pip setuptools && \
    echo "alias python='python3'" >> /root/.bash_aliases && \
    echo "alias pip='pip3'" >> /root/.bash_aliases

RUN pip3 install --no-cache-dir --upgrade scipy Pillow cython matplotlib scikit-image==0.16.2 \
      tensorflow==2.4.0 opencv-python imgaug IPython[all] jupyter

# Jupyter Notebook.
# Allow access from outside the container, and skip trying to open a browser.
# NOTE: disable authentication token for convenience. DON'T DO THIS ON A PUBLIC SERVER.
RUN mkdir /root/.jupyter && \
    echo "c.NotebookApp.ip = '0.0.0.0'" \
    "\nc.NotebookApp.open_browser = False" \
    "\nc.NotebookApp.allow_root = True" \
    "\nc.NotebookApp.token = ''" \
    > /root/.jupyter/jupyter_notebook_config.py

WORKDIR /maskrcnn
CMD ["/bin/bash"]

ENTRYPOINT [ "./entrypoint.sh" ]
