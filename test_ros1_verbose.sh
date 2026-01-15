#!/bin/bash
#
# Verbose test script for ROS1 branch
#

set -e

echo "Testing ROS1 branch in Docker (ROS Noetic / Ubuntu 20.04)..."
echo ""

docker pull ros:noetic-ros-base

echo ""
echo "Building package in container (showing all output)..."
echo ""

timeout 180 docker run --rm \
  -v $(pwd):/ws/src/supercamera_ros \
  ros:noetic-ros-base \
  bash -c "
    set -ex
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y python-is-python3 python3-opencv python3-numpy
    
    mkdir -p /ws/src
    cd /ws
    source /opt/ros/noetic/setup.bash
    catkin_make --pkg supercamera_ros
    
    echo ''
    echo '✓ Build successful!'
  "

echo ""
echo "✓ ROS1 tests passed!"
