# 第一阶段：基于Ubuntu 20.04构建ROS1依赖
FROM ubuntu:focal as ros1_builder

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 安装ROS1 Noetic核心
RUN echo "chooses:\n" > fish_install.yaml \
    && echo "- {choose: 1, desc: '一键安装:ROS(支持ROS和ROS2,树莓派Jetson)'}\n" >> fish_install.yaml \
    && echo "- {choose: 1, desc: 更换系统源再继续安装}\n" >> fish_install.yaml \
    && echo "- {choose: 1, desc: 仅更换系统源}\n" >> fish_install.yaml \
    && echo "- {choose: 3, desc: noetic(ROS2)}\n" >> fish_install.yaml \
    && echo "- {choose: 2, desc: noetic(ROS2)基础版(小)}\n" >> fish_install.yaml \
    && apt update && apt install wget python3 python3-distro python3-yaml -y \
    && wget http://fishros.com/install  -O fishros && /bin/bash fishros \
    && rm -rf /var/lib/apt/lists/*  /tmp/* /var/tmp/* \
    && apt-get clean && apt autoclean \
    && rm -rf fish_install.yaml

# 提取关键依赖库
RUN mkdir -p /ros1_libs \
    && cp -r /opt/ros/noetic /ros1_libs/ \
    && cp /usr/lib/x86_64-linux-gnu/libconsole_bridge.so.0.4 /ros1_libs/ \
    && cp /usr/lib/x86_64-linux-gnu/libboost_*1.71.0 /ros1_libs/


# 第二阶段：基于Ubuntu 22.04构建最终镜像
# FROM ubuntu:jammy
# ENV TZ=Asia/Shanghai

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 安装ROS2 Foxy
RUN echo "chooses:\n" > fish_install.yaml \
    && echo "- {choose: 1, desc: '一键安装:ROS(支持ROS和ROS2,树莓派Jetson)'}\n" >> fish_install.yaml \
    && echo "- {choose: 1, desc: 更换系统源再继续安装}\n" >> fish_install.yaml \
    && echo "- {choose: 1, desc: 仅更换系统源}\n" >> fish_install.yaml \
    && echo "- {choose: 1, desc: foxy(ROS2)}\n" >> fish_install.yaml \
    && echo "- {choose: 2, desc: foxy(ROS2)基础版(小)}\n" >> fish_install.yaml \
    && apt update && apt install wget python3 python3-distro python3-yaml -y \
    && wget http://fishros.com/install  -O fishros && /bin/bash fishros \
    && rm -rf /var/lib/apt/lists/*  /tmp/* /var/tmp/* \
    && apt-get clean && apt autoclean \
    && rm -rf fish_install.yaml


# 从第一阶段复制ROS1库
# COPY --from=ros1_builder /ros1_libs /opt/ros/noetic
# >>> Tools <<<
ENV ZSH_CUSTOM=/root/.oh-my-zsh/custom
# zsh
RUN apt-get update -y \
    && apt-get install -y git wget \
    && git clone https://github.com/ohmyzsh/ohmyzsh.git /root/.oh-my-zsh \
    && git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting \
    && sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t ys \
    -p git \
    -p zsh-syntax-highlighting \
    -p zsh-autosuggestions

# # 配置动态库路径
ENV LD_LIBRARY_PATH=/opt/ros/noetic/lib:/opt/ros/humble/lib:$LD_LIBRARY_PATH

RUN apt update && apt install ros-foxy-ros1-bridge ros-foxy-demo-nodes-py ros-foxy-demo-nodes-cpp -y \
    && echo 'ROS1_INSTALL_PATH=/opt/ros/noetic' >> /root/.zshrc \
    && echo 'ROS2_INSTALL_PATH=/opt/ros/foxy' >> /root/.zshrc

# # 启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]