# ledcube_gui

An advanced GUI to control a led cube

## Requirements

* Processing
* ControlP5 library

## Info

This is a GUI displaying a cube in 3D and allowing the creation of animations by hand.

You can also play snake 3D with it :D

The GUI can work with any size of led cube but the serial communication was only made for a 8^3 led cube.

The current serial communication sends frames to the cube with 64 bytes, each byte representing a column.
Frames are stored in a text file, with dimension^3 (512 in my case) 0 and 1, separated by commas (see the test.txt file for the frames format).

A screenshot :D : http://fathost.fr/s/GHoIu
