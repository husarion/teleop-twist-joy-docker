# teleop-twist-joy-docker

Docker image for https://github.com/ros2/teleop_twist_joy ROS 2 package

## Examples

### Just `joy` node and force feedback

Connect the gamepage to the USB port.

Install and run `evtest`:

```bash
sudo apt install evtest
```

```bash
$ evtest
No device specified, trying to scan all of /dev/input/event*
Not running as root, no devices may be available.
Available devices:
/dev/input/event18:	Logitech Gamepad F710
Select the device event number [0-18]: 
```

create the `joy_params.yaml` file:

```yaml
joy_node:
  ros__parameters:
    dev: "/dev/input/js0"  # Replace with your joystick device
    deadzone: 0.3
    autorepeat_rate: 20.0
    dev_ff: "/dev/input/event18" # based on evtest
```

and start the `joy` node:

```yaml
services:
  joy:
    image: husarion/teleop-twist-joy:humble-2.4.5-20240318
    devices:
      - /dev/input
    volumes:
      - ./joy_params.yaml:/joy_params.yaml
    command: ros2 run joy joy_node --ros-args --params-file /joy_params.yaml
```

list available ROS 2 topics:

```bash
$ ros2 topic list
/joy
/joy/set_feedback
/parameter_events
/rosout
```

#### echo `/joy` topic:

```bash
$ ros2 topic echo /joy
---
header:
  stamp:
    sec: 1710785937
    nanosec: 151868373
  frame_id: joy
axes:
- -0.0
- -0.0
- 0.9999999403953552
- -0.0
- -0.0
- 0.9999999403953552
- 0.0
- 0.0
buttons:
- 0
- 0
- 0
- 0
- 0
- 0
- 0
- 0
- 0
- 0
- 0
```

#### Force feedback

```bash
ros2 topic pub /joy/set_feedback sensor_msgs/msg/JoyFeedback "{type: 1, id: 0, intensity: 1.0}"
```

### Just `teleop_twist_joy` node

Create `params.yaml` file for your gamepad:

```yaml
teleop_twist_joy_node:
  ros__parameters:
    axis_linear:  # Left thumb stick vertical
      x: 1
    scale_linear:
      x: 0.7
    scale_linear_turbo:
      x: 1.5

    axis_angular:  # Left thumb stick horizontal
      yaw: 0
    scale_angular:
      yaw: 0.4

    enable_button: 4  # Left trigger button (get from /joy topic)
    enable_turbo_button: 7  # Right trigger button
```

And run the ROS 2 node:

```yaml
services:
  teleop_twist_joy:
    image: husarion/teleop-twist-joy:humble-2.4.5-20240318
    volumes:
      - ./params.yaml:/params.yaml
    command: ros2 run teleop_twist_joy teleop_node --ros-args --params-file /params.yaml
```

### Running both `joy` and `teleop_twist_joy` nodes

```yaml
services:
  teleop_twist_joy:
    image: husarion/teleop-twist-joy:humble-2.4.5-20240318
    devices:
      - /dev/input
    volumes:
      - ./logitech-f710.yaml:/params.yaml
    command: ros2 launch teleop_twist_joy teleop-launch.py config_filepath:=/params.yaml
```