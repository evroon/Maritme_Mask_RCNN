# Based on: https://github.com/Cuda-Chen/mask-rcnn-docker

FROM ubuntu:20.04
LABEL maintainer="Erik Vroon <erik.vroon22@gmail.com>"

ENV TEMP_MRCNN_DIR /tmp/mrcnn
ENV TEMP_COCO_DIR /tmp/coco
ENV MRCNN_DIR /mrcnn

ARG DEBIAN_FRONTEND=noninteractive

# Essentials: developer tools, build tools, OpenBLAS
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils git curl vim unzip openssh-client wget \
    build-essential cmake \
    libopenblas-dev

# Install Python and dependencies
RUN apt-get install -y --no-install-recommends python3-dev python3-pip python3-tk && \
    pip3 install --no-cache-dir --upgrade pip setuptools && \
    echo "alias python='python3'" >> /root/.bash_aliases && \
    echo "alias pip='pip3'" >> /root/.bash_aliases

# Pillow and it's dependencies
RUN apt-get install -y --no-install-recommends libjpeg-dev zlib1g-dev && \
    pip3 --no-cache-dir install Pillow

# Science libraries and other common packages
RUN pip3 --no-cache-dir install \
    numpy scipy scikit-image matplotlib Cython imgaug \
    tensorflow==2.2.0 pydot_ng keras pycocotools

# Jupyter Notebook
#
# Allow access from outside the container, and skip trying to open a browser.
# NOTE: disable authentication token for convenience. DON'T DO THIS ON A PUBLIC SERVER.
RUN pip3 --no-cache-dir install jupyter && \
    mkdir /root/.jupyter && \
    echo "c.NotebookApp.ip = '0.0.0.0'" \
         "\nc.NotebookApp.open_browser = False" \
         "\nc.NotebookApp.allow_root = True" \
         "\nc.NotebookApp.token = ''" \
         > /root/.jupyter/jupyter_notebook_config.py


# OpenCV 4.5.0 + dependencies
RUN apt-get install -y --no-install-recommends \
    libjpeg8-dev libtiff5-dev libpng-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libgtk2.0-dev \
    liblapacke-dev checkinstall

# Get source from github and compile
RUN git clone -b 4.5.0 --depth 1 https://github.com/opencv/opencv.git /usr/local/src/opencv
RUN cd /usr/local/src/opencv && mkdir build && cd build && \
    cmake -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D BUILD_TESTS=OFF \
          -D BUILD_PERF_TESTS=OFF \
          -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
          .. && \
    make -j"$(nproc)" && \
    make install

RUN git clone https://github.com/leekunhee/Mask_RCNN.git $TEMP_MRCNN_DIR
RUN git clone https://github.com/philferriere/cocoapi.git $TEMP_COCO_DIR

RUN cd $TEMP_MRCNN_DIR && python3 setup.py install

RUN cd $TEMP_COCO_DIR/PythonAPI && \
    sed -i "s/\bpython\b/python3/g" Makefile && \
    make

RUN mkdir -p $MRCNN_DIR/coco

WORKDIR /maskrcnn
CMD ["/bin/bash"]

# Expose port for tensorboard and jupyter notebook respectively
EXPOSE 6006
EXPOSE 8888
