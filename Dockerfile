FROM husarnet/ros:humble-ros-core

RUN apt update && apt install -y \
        ros-$ROS_DISTRO-teleop-twist-joy && \
    rm -rf /var/lib/apt/lists/*

COPY joy_params.yaml /
COPY teleop_twist_joy.launch /