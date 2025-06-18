FROM nvcr.io/nvidia/pytorch:22.06-py3

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
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

# Install Python packages
RUN pip install plyfile tqdm torch==1.13.1
    


WORKDIR /app

COPY . /app

RUN pip install jupyter-lab

RUN conda create -yn gspl python=3.9 pip
RUN echo "source activate gspl" > ~/.bashrc
ENV PATH /opt/conda/envs/gspl/bin:$PATH


RUN pip install -r /app/requirements/pyt201_cu118.txt
RUN pip install -v -r /app/requirements.txt
RUN pip install -r /app/requirements/CityGS.txt

EXPOSE 8888
CMD ["conda", "run", "-n", "horizon_gs", "jupyter", "lab", "--ip='*'", "--port=8888", "--no-browser", "--allow-root"]
