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

# Build & install OpenCV
WORKDIR /tmp/OpenCV
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/4.4.0.zip
RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.4.0.zip
RUN unzip opencv.zip
RUN unzip opencv_contrib.zip
WORKDIR /tmp/OpenCV/build
RUN cmake -GNinja -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-4.4.0/modules ../opencv-4.4.0
RUN ninja
RUN ninja install
WORKDIR /tmp
RUN rm -rf /tmp/OpenCV

RUN echo "export LIBGL_ALWAYS_INDIRECT=1" >> ~/.bashrc

# Install ROS
RUN echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ros-melodic-desktop-full \
      ros-melodic-usb-cam

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
  python-catkin-tools

RUN apt-get clean

RUN echo 'source /opt/ros/melodic/setup.bash' >> ~/.bashrc
RUN echo 'export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/projects/ORB_SLAM3/Examples_old/ROS' >> ~/.bashrc

WORKDIR /
CMD ["bash"]



