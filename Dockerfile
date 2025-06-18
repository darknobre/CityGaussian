FROM pytorch/pytorch:2.0.1-cuda11.8-cudnn8-runtime
RUN apt-get update && apt-get install -y build-essential
    
RUN apt update && apt install -y wget && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh && \
    apt clean

RUN apt-get update && apt-get install -y git
    
ENV PATH="/opt/conda/bin:$PATH"

WORKDIR /app

COPY . /app

RUN pip install jupyter

RUN conda create -yn gspl python=3.9 pip
RUN echo "source activate gspl" > ~/.bashrc
ENV PATH /opt/conda/envs/gspl/bin:$PATH


RUN pip install -r /app/requirements/pyt201_cu118.txt
RUN pip install -v -r /app/requirements.txt
RUN pip install -r /app/requirements/CityGS.txt

EXPOSE 8888
CMD ["conda", "run", "-n", "horizon_gs", "jupyter", "lab", "--ip='*'", "--port=8888", "--no-browser", "--allow-root"]
