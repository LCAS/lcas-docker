
FROM ros:melodic-ros-core-bionic

# HACK: http://stackoverflow.com/questions/25193161/chfn-pam-system-error-intermittently-in-docker-hub-builds
RUN ln -s -f /bin/true /usr/bin/chfn

COPY public.key /tmp/

RUN apt-get update
RUN apt-get install -y curl software-properties-common
RUN curl -s http://lcas.lincoln.ac.uk/repos/public.key | apt-key add -
RUN apt-add-repository http://lcas.lincoln.ac.uk/ubuntu/main
RUN apt-get update && apt-get install -y \
    ros-melodic-rospack ros-melodic-catkin python-rosinstall-generator python-wstool \
    python-bloom vim nano less ssh python-pip tmux python3-ros-buildfarm

RUN pip install bloom

RUN bash -c "rm -rf /etc/ros/rosdep; source /opt/ros/melodic/setup.bash;\
	rosdep init"
RUN curl -o /etc/ros/rosdep/sources.list.d/20-default.list https://raw.githubusercontent.com/LCAS/rosdistro/master/rosdep/sources.list.d/20-default.list
RUN curl -o /etc/ros/rosdep/sources.list.d/50-lcas.list https://raw.githubusercontent.com/LCAS/rosdistro/master/rosdep/sources.list.d/50-lcas.list
RUN mkdir -p /root/.config/rosdistro/
RUN echo "index_url: https://raw.github.com/lcas/rosdistro/master/index.yaml" > /root/.config/rosdistro/index.yaml
RUN echo "index_url: https://raw.github.com/lcas/rosdistro/master/index-v4.yaml" > /root/.config/rosdistro/index-v4.yaml
RUN bash -c "source /opt/ros/melodic/setup.bash;\
	export ROSDISTRO_INDEX_URL=https://raw.github.com/lcas/rosdistro/master/index-v4.yaml; \
        rosdep update"

ENV ROSDISTRO_INDEX_URL https://raw.github.com/lcas/rosdistro/master/index-v4.yaml

RUN mkdir -p workspace/src
WORKDIR workspace/src
RUN bash -c 'source /opt/ros/melodic/setup.bash;\
	export ROSDISTRO_INDEX_URL="https://raw.github.com/lcas/rosdistro/master/index-v4.yaml"; \
        catkin_init_workspace . ; \
	wstool init; \
	rosdep update; \
	apt-get install -y ssh openssh-server shellinabox vim git python-pip tmux openvpn python-wstool; \
	pip install -U tmule; \
	mkdir -p /usr/local/bin ; \
	curl -o /usr/local/bin/rmate https://raw.githubusercontent.com/aurora/rmate/master/rmate; \
	chmod +x /usr/local/bin/rmate; \
'
RUN git config --global user.email 'lcas@lincoln.ac.uk'
RUN git config --global user.name 'L-CAS docker user'
RUN git config --global credential.helper 'store'
RUN curl -o /usr/local/bin/rmate https://raw.githubusercontent.com/aurora/rmate/master/rmate && chmod +x /usr/local/bin/rmate


ADD git-catkin-build.sh /usr/local/bin

