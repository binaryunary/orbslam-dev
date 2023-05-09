FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

# Common build tools etc.
RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  git \
  wget \
  curl \
  ninja-build \
  unzip \
  x11-apps \
  # ORB SLAM 3 deps
  libboost-filesystem-dev \
  libboost-serialization-dev \
  libssl-dev

# Install Pangolin deps
RUN apt-get update && apt-get install -y --no-install-recommends \
  libgl1-mesa-dev \
  libwayland-dev \
  libxkbcommon-dev \
  wayland-protocols \
  libegl1-mesa-dev \
  libc++-dev \
  libglew-dev \
  libeigen3-dev \
  libjpeg-dev \
  libpng-dev \
  libavcodec-dev \
  libavutil-dev \
  libavformat-dev \
  libswscale-dev \
  libavdevice-dev

# Build & install Pangolin
WORKDIR /tmp
RUN git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
WORKDIR /tmp/Pangolin/build
RUN cmake -GNinja ..
RUN ninja
RUN ninja install
WORKDIR /
RUN rm -rf /tmp/Pangolin

# Install OpenCV deps
RUN apt-get update && apt-get install -y --no-install-recommends \
  pkg-config \
  libgtk-3-dev \
  libv4l-dev \
  libxvidcore-dev \
  libx264-dev \
  libtiff-dev \
  gfortran \
  openexr \
  libatlas-base-dev \
  python-dev \
  python-numpy \
  python3-dev \
  python3-numpy \
  libtbb2 \
  libtbb-dev \
  libdc1394-22-dev

# Install ROS
RUN echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  ros-melodic-desktop-full \
  ros-melodic-usb-cam \
  ros-melodic-novatel-oem7-driver

RUN apt-get install -y python-rosdep
RUN rosdep init
RUN rosdep update

RUN apt-get install -y \
  vim \
  postgresql-client \
  inetutils-ping \
  gdb \
  libpcl-dev \
  libeigen3-dev \
  libodb-boost-dev \
  odb \
  libodb-pgsql-2.4 \
  python-catkin-tools \
  ccache \
  python-pip \
  python3-pip

RUN apt-get clean

RUN pip install --extra-index-url https://rospypi.github.io/simple/ tf2_ros \
  && pip install --extra-index-url https://rospypi.github.io/simple/ tf \
  && pip install kitti2bag

RUN echo "export LIBGL_ALWAYS_INDIRECT=1" >> ~/.bashrc
RUN echo "export CCACHE_DIR=/ccache" >> ~/.bashrc

WORKDIR /
CMD ["bash"]



