#! /bin/bash

set -eux

build_target() {
  cd $1
  
  if [[ ! -f $1/CMakeLists.txt ]]; then
    echo "$1 package does not have a CMakeLists.txt file"
  else
    mkdir -p $1/build
    cd $1/build

    cmake -DCMAKE_INSTALL_PREFIX="$WORKSPACE/env/$(basename $1)" ..
    cmake --$2 .
    cd $WORKSPACE
  fi
}


if [[ $IS_SETENV != 1 ]]; then
  echo "Please set environment by sourcing the 'setenv' script"
  exit -1
fi

while getopts ":A:t:j:" opt; do
  case ${opt} in
    A )
      echo "Build target $OPTARG has been selected"
      BUILD_TARGET=$OPTARG 
      ;;
    j )
      echo "Build with $OPTARG threads"
      BUILD_THREADS=$OPTARG
      ;;
    t )
      echo "Build task is $OPTARG"
      BUILD_TASK=$OPTARG
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done

# Shift option index so that $1 will now refer to the first non-option argument
shift $((OPTIND -1))

# Your code to handle non-option arguments here (if any)

if [[ $BUILD_TARGET == "all" ]]; then
  PACKAGES=$(find "$WORKSPACE/packages" -mindepth 1 -maxdepth 1 -type d)
  for package in $PACKAGES; do
    build_target $package $BUILD_TASK
  done
else
  build_target $BUILD_TARGET $BUILD_TASK
fi
