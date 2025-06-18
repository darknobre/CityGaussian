FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    nano \
    git \
    libx11-6 \
    libgl1-mesa-glx \
    g++ \
    libglew-dev \
    libassimp-dev \
    libboost-all-dev \
    libgtk-3-dev \
    libopencv-dev \
    libglfw3-dev \
    libavdevice-dev \
    libavcodec-dev \
    libeigen3-dev \
    libxxf86vm-dev \
    libembree-dev \
    colmap \
    imagemagick \
    ffmpeg \
    meshlab && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
RUN sudo dpkg -i cuda-keyring_1.0-1_all.deb
RUN sudo apt-get update
RUN sudo apt-get -y install cuda


RUN apt update && apt install -y wget && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh && \
    apt clean

ENV PATH="/opt/conda/bin:$PATH"

WORKDIR /app

COPY . /app

RUN pip install jupyterlab

RUN conda create -yn gspl python=3.9 pip
RUN echo "source activate gspl" > ~/.bashrc
ENV PATH /opt/conda/envs/gspl/bin:$PATH


RUN pip install -r /app/requirements/pyt201_cu118.txt
RUN pip install -v -r /app/requirements.txt
RUN pip install -r /app/requirements/CityGS.txt

EXPOSE 8888
CMD ["conda", "run", "-n", "gspl", "jupyter", "lab", "--ip='*'", "--port=8888", "--no-browser", "--allow-root"]
