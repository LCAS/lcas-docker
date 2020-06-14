
FROM lcasuol/lcas-docker:xenial-base

RUN apt-get update && apt-get -y dist-upgrade && apt-get install -y ros-kinetic-catkin python-catkin-tools xvfb
RUN git clone --recurse-submodules https://github.com/LCAS/teaching.git
RUN rosdep update
RUN rosdep install -i -y --from-paths . 
RUN apt-get autoremove && apt-get clean
RUN bash -c "source /opt/ros/kinetic/setup.bash && catkin_make -C .."

# run stuff:
# > source ../devel/setup.bash
# > Xvfb :1 -screen 0 1600x1200x16
# > export DISPLAY=:1.0
# > TURTLEBOT_3D_SENSOR=kinect roslaunch turtlebot_gazebo turtlebot_world.launch gui:=false


