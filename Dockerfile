FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04

RUN apt update && apt install -y wget && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh && \
    apt clean
    
ENV PATH="/opt/conda/bin:$PATH"

WORKDIR /app

COPY . /app

RUN pip install jupyter

RUN conda install -c anaconda git

RUN pip install gcc7

RUN conda create -yn gspl python=3.9 pip
RUN echo "source activate gspl" > ~/.bashrc
ENV PATH /opt/conda/envs/gspl/bin:$PATH

RUN conda install pytorch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 -c pytorch
RUN pip install -r /app/requirements/pyt201_cu118.txt
RUN pip install -r /app/requirements.txt
RUN pip install -r /app/requirements/CityGS.txt

EXPOSE 8888
CMD ["conda", "run", "-n", "horizon_gs", "jupyter", "lab", "--ip='*'", "--port=8888", "--no-browser", "--allow-root"]
