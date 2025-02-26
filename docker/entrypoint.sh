#!/bin/bash

# 加载ROS1环境
source /opt/ros/noetic/setup.bash

# 加载ROS2环境
source /opt/ros/foxy/setup.bash

# 启动桥接
exec ros2 run ros1_bridge dynamic_bridge