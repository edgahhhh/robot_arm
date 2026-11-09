#!/usr/bin/env bash
# devcontainer post create
# Edgar Hernandez
# 
# Script that will run after creating a devcontainer
# 
# Builds all ros2 workspaces in robot_sw and installs python libraries from libs
# Also sets up autosourcing of colcon workspaces and 

# autosourcing of ros2 and the autocompletion tools
echo >> ~/.bashrc
echo "# Ros 2" >> ~/.bashrc
echo "source /opt/ros/${ROS_DISTRO}/setup.sh" >> ~/.bashrc
echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc
echo "source /opt/ros/jazzy/share/ros2cli/environment/ros2-argcomplete.bash" >> ~/.bashrc
echo >> ~/.bashrc

# autocompletion for uv
echo "# UV tools" >> ~/.bashrc
echo 'eval "$(uv generate-shell-completion bash)"' >> ~/.bashrc
echo 'eval "eval "$(uvx --generate-shell-completion bash)"' >> ~/.bashrc

# install python libraries in libs
# uv pip install --no-deps -e libs/whatever libs i need :)

# build ros2 workspaces
# TODO

# Source ros2 workspaces
echo source /workspace/Tools/source_all_workspaces.sh
