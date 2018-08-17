FROM nvidia/cuda:9.0-cudnn7-devel-centos6

#
# Docker image to build conda-forge friendly packages depending on cuda/cudnn.
#
# Usage
# -----
# Build it, push to docker hub (see the two scripts, knowing appropriate credentials is compulsory)
# In conda-forge like recipes, tweak conda-forge.yml as needed. For example:
#  docker:
#    # Setting the image is compulsory
#    image: loopbio/linux-anvil-cudnn
#    # Using nvidia-docker is optional, but needed if wanting to test against GPU or for the likes of neon
#    command: docker --runtime nvidia
#
# Notes:
# ------
#
#  - We decided to use CUDA and CUDNN as published in defaults
#   (so choose the adequate tag for the image, e.g. 9.0-cudnn7-devel-centos6)
#
#  - If we need to go for newer CUDA stacks, we can package them ourselves
#    (or use the numba channel that usually includes more up to date versions)
#
#  - In any case we should strive to minimize the number or redundant
#    CUDA/CUDNN runtimes present in an environment
#
#  - Conda-forge has added very recently (3 hours ago) a cuda-dev package:
#    https://github.com/conda-forge/staged-recipes/pull/6372
#    https://github.com/conda-forge/cudatoolkit-dev-feedstock
#
#  - nvidia has migrated the source of their docker files
#      https://hub.docker.com/r/nvidia/cuda/
#      https://github.com/NVIDIA/nvidia-docker/commit/ffcf3becde7b965d00170ba7ba5db1a58e2e13b4
#    Now each system image is in a branch, we want this one:
#      https://gitlab.com/nvidia/cuda/tree/centos6
#    Concretely:
#      https://gitlab.com/nvidia/cuda/blob/centos6/9.0/devel/cudnn7/Dockerfile
#
#  - Images used for defaults as of 20180817:
#      https://github.com/jjhelmus/docker-images
#    As documented in, e.g. tensorflow
#      https://github.com/AnacondaRecipes/tensorflow_recipes/tree/master/tensorflow-base-gpu
#
#  - This is very much in the same spirit as:
#    https://github.com/conda-forge/docker-images/pull/21
#

MAINTAINER Santi Villalba <sdvillal@gmail.com>

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8

# Add a timestamp for the build. Also, bust the cache.
ADD https://now.httpbin.org/when/now /opt/docker/etc/timestamp

# Resolves a nasty NOKEY warning that appears when using yum.
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

# Install basic requirements.
RUN yum update -y && \
    yum install -y \
                   bzip2 \
                   make \
                   patch \
                   sudo \
                   tar \
                   which \
                   libXext-devel \
                   libXrender-devel \
                   libSM-devel \
                   libX11-devel \
                   mesa-libGL-devel && \
    yum clean all

# Install devtoolset 2 - remove this once we move to the new compilers
# See: https://github.com/jjhelmus/docker-images/blob/master/pkg_build_cuda90_cudnn7_centos6_notoolset/Dockerfile
RUN yum update -y && \
    yum install -y \
                   centos-release-scl \
                   yum-utils && \
    yum-config-manager --add-repo http://people.centos.org/tru/devtools-2/devtools-2.repo && \
    yum update -y && \
    yum install -y \
                   devtoolset-2-binutils \
                   devtoolset-2-gcc \
                   devtoolset-2-gcc-gfortran \
                   devtoolset-2-gcc-c++ && \
    yum clean all

# Run common commands
COPY scripts/run_commands /opt/docker/bin/run_commands
RUN /opt/docker/bin/run_commands

# Add a file for users to source to activate the `conda`
# environment `root` and the devtoolset compiler. Also
# add a file that wraps that for use with the `ENTRYPOINT`.
COPY scripts/entrypoint_source /opt/docker/bin/entrypoint_source
COPY scripts/entrypoint /opt/docker/bin/entrypoint

# Ensure that all containers start with tini and the user selected process.
# Activate the `conda` environment `root` and the devtoolset compiler.
# Provide a default command (`bash`), which will start if the user doesn't specify one.
ENTRYPOINT [ "/opt/conda/bin/tini", "--", "/opt/docker/bin/entrypoint" ]
CMD [ "/bin/bash" ]
