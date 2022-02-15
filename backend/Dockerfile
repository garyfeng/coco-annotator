# Backend environment docker image
FROM tensorflow/tensorflow:1.14.0-gpu-py3

RUN apt-get update
RUN apt-get install -y git

WORKDIR /workspace/

# Copy backend
# using the requirements.paddle.txt, which is created by doing a 
# `pip list` from the jsbroks/coco-annotator:webserver-stable image
COPY ./backend/requirements.paddle.txt /workspace/requirements.txt

# Install python package dependices
RUN pip install -r requirements.txt && \
    pip install gunicorn[eventlet]==19.9.0 && \
    pip install pycocotools

# Install maskrcnn
RUN git clone --single-branch --depth 1 https://github.com/matterport/Mask_RCNN.git /tmp/maskrcnn
#RUN cd /tmp/maskrcnn && pip install -r requirements.txt
RUN cd /tmp/maskrcnn && python3 setup.py install

# Install DEXTR
RUN git clone --single --depth 1 https://github.com/jsbroks/dextr-keras.git /tmp/dextr && \
    cd /tmp/dextr && \
    python setup.py install

# Install Paddle Detect
# need to install a version that does not require GPU in this docker file
# see https://github.com/PaddlePaddle/PaddleDetection/blob/release/2.3/docs/tutorials/INSTALL.md
# CPU
RUN python -m pip install paddlepaddle -i https://mirror.baidu.com/pypi/simple
# Clone PaddleDetection repository
RUN git clone https://github.com/PaddlePaddle/PaddleDetection.git

# Install other dependencies
RUN cd PaddleDetection && \
    pip install "Jinja2>=3.0" && \
    pip install -r requirements.txt && \
    python setup.py install
# to fix error of missing libSM
RUN apt-get -y install libsm6 libxrender1 libfontconfig1

RUN apt-get -y -o Dpkg::Options::="--force-confmiss" install --reinstall netbase
