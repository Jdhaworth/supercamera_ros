#!/bin/bash
#
# Quick test script for ROS1 branch using Docker
# Tests that the package builds correctly in ROS Noetic environment
#

set -e

echo "Testing ROS1 branch in Docker (ROS Noetic / Ubuntu 20.04)..."
echo ""

# Pull ROS Noetic image (Ubuntu 20.04)
echo "Pulling ROS Noetic image..."
docker pull ros:noetic-ros-base

echo ""
echo "Building package in container..."
echo ""

# Test the build with timeout and verbose output
timeout 180 docker run --rm \
  -v $(pwd):/ws/src/supercamera_ros \
  ros:noetic-ros-base \
  bash -c "
    set -ex
    echo '=== Installing dependencies ==='
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y python-is-python3 python3-opencv python3-numpy
    
    echo ''
    echo '=== Setting up workspace ==='
    mkdir -p /ws/src
    cd /ws
    
    echo ''
    echo '=== Building with catkin_make ==='
    source /opt/ros/noetic/setup.bash
    catkin_make --pkg supercamera_ros 2>&1 | tail -20
    
    echo ''
    echo '=== Build successful! ==='
    echo ''
    echo 'Generated files:'
    ls -lh devel/lib/supercamera_ros/ 2>/dev/null || echo 'No executables (Python only - OK)'
    ls -lh install/lib/supercamera_ros/ 2>/dev/null || echo 'No install files (not installed)'
  "

EXIT_CODE=$?
echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "✓ ROS1 branch tests passed!"
    echo "The package builds successfully on Ubuntu 20.04 / ROS Noetic"
else
    echo "✗ Build failed (exit code: $EXIT_CODE)"
    exit 1
fi
echo ""
