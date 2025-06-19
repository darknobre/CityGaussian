FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    libgl1-mesa-glx \
    sudo \
    && rm -rf /var/lib/apt/lists/*

ENV CONDA_DIR=/opt/conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh
ENV PATH=$CONDA_DIR/bin:$PATH

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
