#!/bin/bash
#
# Fast ROS1 test using cached Docker image
#

set -e

echo "Building test Docker image (only needed once)..."
cd $(dirname "$0")
docker build -t supercamera_ros1_test -f Dockerfile.test . 2>&1 | tail -5

echo ""
echo "Testing ROS1 build..."
echo ""

docker run --rm \
  -v $(pwd):/ws/src/supercamera_ros \
  supercamera_ros1_test \
  bash -c "
    set -e
    cd /ws
    source /opt/ros/noetic/setup.bash
    catkin_make --pkg supercamera_ros
    
    echo ''
    echo '✓ ROS1 build successful!'
  "

echo ""
echo "✓ All tests passed!"
