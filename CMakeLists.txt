cmake_minimum_required(VERSION 3.0.2)
project(supercamera_ros)

find_package(catkin REQUIRED COMPONENTS
  rospy
  sensor_msgs
)

catkin_package()

catkin_install_python(PROGRAMS
  scripts/publisher_node
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

install(DIRECTORY launch/
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/launch
)

install(DIRECTORY driver/
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/driver
)

install(PROGRAMS scripts/install_driver.sh
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/scripts
)
