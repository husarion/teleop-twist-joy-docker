ARG ROS_DISTRO=humble

FROM husarnet/ros:$ROS_DISTRO-ros-core

RUN apt update && apt install -y \
        ros-$ROS_DISTRO-teleop-twist-joy && \
    rm -rf /var/lib/apt/lists/*

RUN echo $(dpkg -s ros-$ROS_DISTRO-teleop-twist-joy | grep 'Version' | sed -r 's/Version:\s([0-9]+.[0-9]+.[0-9]+).*/\1/g') >> /version.txt

COPY joy_params.yaml /
COPY teleop_twist_joy_f710_params.yaml /

