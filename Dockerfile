FROM registry.cn-shanghai.aliyuncs.com/tcc-public/pytorch:1.1.0-cuda10.0-py3
MAINTAINER Zili Wang

RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/ && \
    conda config --set ssl_verify no && \
    conda config --set ssl_verify no && \
    conda install --no-update-deps textdistance pytorch-pretrained-bert -y && \
    conda clean -tipsy

USER root
RUN apt-get clean && apt-get update && apt-get install -y \
      locales \
      language-pack-fi  \
      language-pack-en && \
      export LANGUAGE=en_US.UTF-8 && \
      export LANG=en_US.UTF-8 && \
      export LC_ALL=en_US.UTF-8 && \
      locale-gen en_US.UTF-8 && \
      dpkg-reconfigure locales && \
      pip install records==0.5.3

ENV LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
