# Mask R-CNN
[![docker-build](https://github.com/evroon/mask-rcnn/actions/workflows/main.yml/badge.svg)](https://github.com/evroon/mask-rcnn/actions/workflows/main.yml)

This repository tries to simplify the process of creating a Dataset and training Mask R-CNN from scratch. Specifically, a maritime dataset of 176 images is created which include 5 classes: buoys (green), land (red), sea (dark blue), sky (turquoise) and ships (white). Training this dataset on Mask R-CNN allows the semantic segmentation of live video coming from cameras on board an maritime vessel, enabling it, in the future, to recognize, understand and act upon its surroundings autonomously.

This fork improves the work from Allopart by implementing tensorflow 2.2.0 support, which is merged from [leekunhee](https://github.com/leekunhee/Mask_RCNN/tree/tensorflow2.0)'s tensorflow2.0 branch.

![Mask-RCNN on the DTU Maritime Dataset](assets/maritime_intro.png)

For more information on [Mask R-CNN](https://arxiv.org/abs/1703.06870) please visit their official github repo (https://github.com/matterport/Mask_RCNN) or their paper.

The repository includes:
* Source code forked from the official Mask R-CNN repository.
* The handmade Maritime Dataset
* Instructions on how to train from scratch your network
* A jupyter notebook to visualize the detection pipeline
* Code for running the detection on a simple webcam or under the ROS framework

# Getting Started

* All code has been tested under the Tensorflow 1.7 environment. Please follow (https://www.tensorflow.org/install/) for more information on how to install tensorflow on your machine.

* Follow [Mask R-CNN](https://github.com/matterport/Mask_RCNN) for installation instructions.

* Create your own dataset: find enough images to represent broadly all the classes you aim to detect. Use the LabelMe python software to create *.json* files that include the polygonal representation of the masked classes. LabelMe can be installed under the tensorflow environment from [LabelMe](https://github.com/wkentaro/labelme) or with:
   ```bash
   pip install labelme
   ```

* Prepare your dataset: edit the *image_list.txt* and *labels.txt* files accordingly. Convert all *.jpg* files to *.png* if necessary.

* [loader.py](Train_own_dataset/training_codes/loader.py) creates a mask for every instance of every class of every image in your training set. If the *.json* files have not been created by *LabelMe*, then the [JSON_parser.py](Train_own_dataset/training_codes/JSON_parser.py) file will most likely need to be modified.
 ```bash
   python loader.py
   ```

* Create a validation folder and add some of the training images there (at least one).

* [showdata.py](mrcnn/showdata.py) to visualize the created instance masks. Usage:
   ```bash
   python showdata.py N (where N is the number of image in training folder (f.ex. 00025)).
   ```

*  Download pre-trained COCO weights (mask_rcnn_coco.h5) from the [releases page](https://github.com/matterport/Mask_RCNN/releases).

* To start training the network please create your own config file or modify [maritime.py](mrcnn/maritime.py). Start training, using the pre-generated COCO weights as starting point, with:
 ```bash
   python maritime.py --dataset="/path/to/dataset/" --model="coco"
   ```
The weights will be saved every epoch in the *logs* folder.

* [maritime.ipynb](mrcnn/maritime.ipynb) to visualize the results through Jupyter Notebook. Some results are shown as follows:

![Jupyter Notebook results](assets/f_pass.png)

* [mask_rcnn_webcam.py](Train_own_dataset/running_codes/mask_rcnn_webcam.py) to run the trained network on the video stream from an USB camera.

* [mask_rcnn_node.py](Train_own_dataset/running_codes/mask_rcnn_node.py) to run the trained network on the video stream from an Kinect using the ROS framework.

* [mask_rcnn_video.py](Train_own_dataset/running_codes/mask_rcnn_video.py) to run the trained network on a specific video and save the results as a video too.

### [Real-time Video Demo](https://www.youtube.com/watch?v=_vmKbbW1FuM)
[![Mask RCNN on DTU Maritime Dataset](assets/maritime_video.gif)](https://www.youtube.com/watch?v=_vmKbbW1FuM)

# Training on MS COCO
We're providing pre-trained weights for MS COCO to make it easier to start. You can
use those weights as a starting point to train your own variation on the network.
Training and evaluation code is in `samples/coco/coco.py`. You can import this
module in Jupyter notebook (see the provided notebooks for examples) or you
can run it directly from the command line as such:

```
# Train a new model starting from pre-trained COCO weights
python3 samples/coco/coco.py train --dataset=/path/to/coco/ --model=coco

# Train a new model starting from ImageNet weights
python3 samples/coco/coco.py train --dataset=/path/to/coco/ --model=imagenet

# Continue training a model that you had trained earlier
python3 samples/coco/coco.py train --dataset=/path/to/coco/ --model=/path/to/weights.h5

# Continue training the last model you trained. This will find
# the last trained weights in the model directory.
python3 samples/coco/coco.py train --dataset=/path/to/coco/ --model=last
```

You can also run the COCO evaluation code with:
```
# Run COCO evaluation on the last trained model
python3 samples/coco/coco.py evaluate --dataset=/path/to/coco/ --model=last
```

The training schedule, learning rate, and other parameters should be set in `samples/coco/coco.py`.


# Training on Your Own Dataset

Start by reading this [blog post about the balloon color splash sample](https://engineering.matterport.com/splash-of-color-instance-segmentation-with-mask-r-cnn-and-tensorflow-7c761e238b46). It covers the process starting from annotating images to training to using the results in a sample application.

In summary, to train the model on your own dataset you'll need to extend two classes:

```Config```
This class contains the default configuration. Subclass it and modify the attributes you need to change.

```Dataset```
This class provides a consistent way to work with any dataset.
It allows you to use new datasets for training without having to change
the code of the model. It also supports loading multiple datasets at the
same time, which is useful if the objects you want to detect are not
all available in one dataset.

See examples in `samples/shapes/train_shapes.ipynb`, `samples/coco/coco.py`, `samples/balloon/balloon.py`, and `samples/nucleus/nucleus.py`.

## Citation
Use this bibtex to cite this repository:
```
@misc{matterport_maskrcnn_2017,
  title={Mask R-CNN for object detection and instance segmentation on Keras and TensorFlow},
  author={Waleed Abdulla},
  year={2017},
  publisher={Github},
  journal={GitHub repository},
  howpublished={\url{https://github.com/matterport/Mask_RCNN}},
}
```
