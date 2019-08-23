FROM alpine:3.10.2
MAINTAINER Zili Wang

RUN echo http://mirrors.aliyun.com/alpine/v3.10/main > /etc/apk/repositories; \
    echo http://mirrors.aliyun.com/alpine/v3.10/community >> /etc/apk/repositories && \
    apk add --no-cache --virtual=.build-dependencies bash libstdc++ bzip2 unzip glib libxext libxrender wget && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -q -O glibc.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk && \
    wget -q -O glibc-bin.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-bin-2.23-r3.apk && \
    apk add *.apk && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc/usr/lib && \
    export CONDA_DIR=/opt/conda && mkdir -p "$CONDA_DIR" && \
    wget -q -O conda.sh https://repo.continuum.io/miniconda/Miniconda3-4.7.10-Linux-x86_64.sh && \
    bash conda.sh -f -b -p "$CONDA_DIR" && export PATH=$CONDA_DIR/bin:$PATH && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/ && \
    conda config --set show_channel_urls yes && \
    conda config --set ssl_verify no && \
    conda update --all --yes && \
    conda config --set auto_update_conda False && \
    conda install pytorch torchvision cpuonly -c pytorch -y && \
    conda install -c conda-forge --no-update-deps python=3.6.5 numpy scipy pandas uwsgi pytorch-pretrained-bert Flask==1.1.1 Flask-RESTful==0.3.7 \
      WTForms==2.2.1 requests scikit-learn==0.20.3  && \
    conda clean -tipsy && \
    rm -r "$CONDA_DIR/pkgs/" && \
    mkdir -p "$CONDA_DIR/locks" && \
    chmod 777 "$CONDA_DIR/locks" && \
    apk del --purge .build-dependencies

ENV PATH=/opt/conda:$PATH LANG="en_US.utf8" LANGUAGE="en_US:en"
