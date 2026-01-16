# SuperCamera ROS

ROS driver for UseePlus/SuperCamera USB borescope/endoscope cameras.

**Supported cameras:** USB devices with VID:2ce3 PID:3828 (commonly sold as "UseePlus", "Geek Szitman", or generic USB borescope cameras)

**This branch:** ROS1 Noetic (Ubuntu 20.04)  
**Other branches:** `main` - ROS2 Humble/Iron (Ubuntu 22.04)

## Quick Start

### 1. Clone and Build

```bash
cd ~/catkin_ws/src
git clone -b ros1 https://github.com/Jdhaworth/supercamera_ros.git
cd ~/catkin_ws
catkin build supercamera_ros
source devel/setup.bash
```

### 2. Install the Kernel Driver

```bash
roscd supercamera_ros/scripts
sudo ./install_driver.sh
```

This installs a kernel module that creates `/dev/supercamera` when the camera is plugged in.

### 3. Run the Publisher

```bash
# Make sure camera is plugged in
rosrun supercamera_ros publisher_node
```

View the images:
```bash
rosrun rqt_image_view rqt_image_view /supercamera/image_raw
```

## Usage

### Basic Usage

```bash
rosrun supercamera_ros publisher_node
```

### With Custom Topic

```bash
rosrun supercamera_ros publisher_node _topic:=/my/camera/image
```

### Launch File

```bash
roslaunch supercamera_ros supercamera.launch
roslaunch supercamera_ros supercamera.launch topic:=/endoscope/image_raw
```

## Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `~device` | `/dev/supercamera` | Path to camera device |
| `~topic` | `/supercamera/image_raw` | Topic to publish images |
| `~frame_id` | `supercamera_link` | TF frame ID |
| `~queue_size` | `10` | Publisher queue size |
| `~publish_raw` | `true` | Publish raw images (~3MB/s) |
| `~publish_compressed` | `true` | Publish JPEG compressed (~100KB/s) |

## Bandwidth Optimization

For streaming over WiFi, use compressed images only:

```bash
# Publish compressed only (much lower bandwidth)
rosrun supercamera_ros publisher_node _publish_raw:=false

# Or via launch file
roslaunch supercamera_ros supercamera.launch publish_raw:=false
```

Subscribe to compressed topic on remote machine:
```bash
# View compressed images
rosrun image_view image_view image:=/supercamera/image_raw compressed
```

## Troubleshooting

### Camera not detected

1. Check if camera is plugged in: `lsusb | grep 2ce3`
2. Check if driver is loaded: `lsmod | grep supercamera`
3. Check if device exists: `ls -la /dev/supercamera`
4. Reinstall driver: `sudo ./install_driver.sh`

### Permission denied

```bash
sudo chmod 666 /dev/supercamera
```

### Frame drops (~3%)

Due to Linux USB stack limitations with this camera's proprietary protocol, approximately 3% of frames may be incomplete. The driver automatically repeats the last good frame to maintain smooth video.

## Technical Details

### Protocol

The camera uses a proprietary USB bulk transfer protocol (not UVC):
- USB header: 5 bytes (magic 0xBBAA, camera ID, payload length)
- Camera header: 7 bytes (frame ID, camera number, flags)
- JPEG payload data

### Performance

- Resolution: 640x480
- Frame rate: ~13 FPS (hardware limited)
- Latency: <100ms

## License

MIT License

## Contributing

Pull requests welcome! Please test on Ubuntu 20.04 with ROS Noetic before submitting.
