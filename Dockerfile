ARG ROS_DISTRO=humble

FROM husarnet/ros:$ROS_DISTRO-ros-core

RUN apt update && apt install -y \
        ros-$ROS_DISTRO-teleop-twist-joy && \
    rm -rf /var/lib/apt/lists/*

COPY joy_params.yaml /
COPY teleop_twist_joy_f710_params.yaml /