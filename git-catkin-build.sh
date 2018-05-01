#!/bin/bash

WORKSPACE=""

while getopts "hw:" opt; do
  case ${opt} in
    h )
      echo "Usage: [opts] git-url"
      echo " -h 	Display this help message."
      echo " -w 	workspace-dir"
      exit 0
      ;;
    w )
      WORKSPACE="$OPTARG"
      ;;
    \? )
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

GITURL="$1"


if [ -z "$WORSPACE" ]; then
  WORKSPACE=`mktemp -p /tmp  -d catkin_ws.XXXXX`
fi

echo "building in workspace $WORKSPACE" >& 2

if [ -z "$GITURL" ]; then
  echo "git-url needs to be provided" >& 2
  exit 1
fi


mkdir -p "$WORKSPACE/src"
cd "$WORKSPACE"
git -C "$WORKSPACE/src" clone --recursive "$GITURL" \
  && apt-get update \
  && rosdep update \
  && rosdep install --from-paths . -i -y \
  && catkin_make_isolated --install \
  || /bin/bash -i
